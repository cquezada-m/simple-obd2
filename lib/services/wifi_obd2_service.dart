import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../models/dtc_code.dart';
import 'app_logger.dart';
import 'obd2_base_service.dart';

/// Servicio OBD2 via WiFi (TCP Socket).
/// Los adaptadores ELM327 WiFi crean un hotspot al que el
/// dispositivo se conecta. La comunicación es por socket TCP,
/// típicamente en 192.168.0.10:35000.
class WifiObd2Service implements Obd2BaseService {
  Socket? _socket;
  String _buffer = '';
  bool _connected = false;

  /// Mutex simple para serializar comandos al socket.
  Completer<void>? _commandLock;

  /// IP y puerto por defecto de adaptadores ELM327 WiFi
  static const String defaultHost = '192.168.0.10';
  static const int defaultPort = 35000;

  /// Callback que el provider puede asignar para enterarse de
  /// desconexiones inesperadas (socket error / onDone).
  void Function()? onDisconnected;

  @override
  bool get isConnected => _connected && _socket != null;

  static final _log = AppLogger.instance;

  /// Conecta al adaptador OBD2 WiFi via TCP socket
  Future<void> connect({
    String host = defaultHost,
    int port = defaultPort,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _log.log(
      LogCategory.connection,
      'WiFi: connecting to $host:$port (timeout: ${timeout.inSeconds}s)',
    );
    try {
      _socket = await Socket.connect(host, port, timeout: timeout);
    } on SocketException catch (e) {
      _connected = false;
      _log.log(
        LogCategory.error,
        'WiFi: connection failed to $host:$port',
        '$e',
      );
      throw Exception(
        'No se pudo conectar a $host:$port. '
        'Verifica la conexión WiFi al adaptador OBD2. ($e)',
      );
    }
    _connected = true;
    _log.log(
      LogCategory.connection,
      'WiFi: TCP socket connected to $host:$port',
    );

    _socket!.listen(
      (data) {
        _buffer += utf8.decode(data, allowMalformed: true);
      },
      onError: (e) {
        _log.log(LogCategory.error, 'WiFi: socket error', '$e');
        _handleUnexpectedDisconnect();
      },
      onDone: () {
        _log.log(LogCategory.connection, 'WiFi: socket closed by adapter');
        _handleUnexpectedDisconnect();
      },
    );

    // Inicializar ELM327
    _log.log(LogCategory.connection, 'WiFi: initializing ELM327');
    await _sendCommand('ATZ');
    await Future.delayed(const Duration(seconds: 1));
    await _sendCommand('ATE0');
    await _sendCommand('ATL0');
    await _sendCommand('ATS0');
    await _sendCommand('ATH0');
    await _sendCommand('ATSP0');
    _log.log(LogCategory.connection, 'WiFi: ELM327 initialized');
  }

  void _handleUnexpectedDisconnect() {
    _connected = false;
    _socket?.destroy();
    _socket = null;
    // Liberar cualquier comando en espera
    if (_commandLock != null && !_commandLock!.isCompleted) {
      _commandLock!.complete();
    }
    onDisconnected?.call();
  }

  @override
  Future<void> disconnect() async {
    _log.log(LogCategory.connection, 'WiFi: disconnecting');
    _connected = false;
    try {
      await _socket?.close();
    } catch (_) {}
    _socket?.destroy();
    _socket = null;
    // Liberar lock pendiente
    if (_commandLock != null && !_commandLock!.isCompleted) {
      _commandLock!.complete();
    }
  }

  /// Adquiere el lock para enviar un comando. Solo un comando a la vez.
  Future<void> _acquireLock() async {
    while (_commandLock != null && !_commandLock!.isCompleted) {
      await _commandLock!.future;
    }
    _commandLock = Completer<void>();
  }

  void _releaseLock() {
    if (_commandLock != null && !_commandLock!.isCompleted) {
      _commandLock!.complete();
    }
  }

  /// Envía un comando AT/OBD y espera la respuesta (delimitada por '>').
  /// Serializado: solo un comando a la vez en el socket.
  Future<String?> _sendCommand(String command) async {
    if (!isConnected) return null;

    await _acquireLock();
    try {
      if (!isConnected) return null;

      _buffer = '';
      try {
        _socket!.add(utf8.encode('$command\r'));
        await _socket!.flush();
      } catch (e) {
        _log.log(LogCategory.error, 'WiFi TX error: $command', '$e');
        return null;
      }
      _log.log(LogCategory.command, 'WiFi TX: $command');

      // Esperar hasta que llegue el prompt '>' o timeout
      final stopwatch = Stopwatch()..start();
      while (!_buffer.contains('>') && stopwatch.elapsed.inSeconds < 5) {
        if (!isConnected) return null;
        await Future.delayed(const Duration(milliseconds: 50));
      }

      final response = _buffer.trim().replaceAll('>', '');
      _buffer = '';
      final elapsed = stopwatch.elapsedMilliseconds;
      _log.log(
        LogCategory.command,
        'WiFi RX (${elapsed}ms): ${response.isEmpty ? "<empty>" : response}',
      );
      return response.isEmpty ? null : response;
    } finally {
      _releaseLock();
    }
  }

  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand('010C');
    if (isErrorResponse(response)) {
      _log.log(LogCategory.parse, 'RPM: raw=null, value=null (error response)');
      return null;
    }
    final raw = Obd2BaseService.parseTwoBytes(response, expectedHeader: '410C');
    final rpm = raw != null ? raw ~/ 4 : null;
    _log.log(LogCategory.parse, 'RPM: raw=$raw, value=$rpm');
    return rpm;
  }

  @override
  Future<int?> getSpeed() async {
    final response = await _sendCommand('010D');
    if (isErrorResponse(response)) {
      _log.log(LogCategory.parse, 'Speed: null km/h (error response)');
      return null;
    }
    final speed = Obd2BaseService.parseOneByte(
      response,
      expectedHeader: '410D',
    );
    _log.log(LogCategory.parse, 'Speed: $speed km/h');
    return speed;
  }

  @override
  Future<int?> getCoolantTemp() async {
    final response = await _sendCommand('0105');
    if (isErrorResponse(response)) {
      _log.log(LogCategory.parse, 'Coolant temp: null (error response)');
      return null;
    }
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4105');
    final temp = raw != null ? raw - 40 : null;
    _log.log(LogCategory.parse, 'Coolant temp: raw=$raw, value=$temp°C');
    return temp;
  }

  @override
  Future<int?> getEngineLoad() async {
    final response = await _sendCommand('0104');
    if (isErrorResponse(response)) {
      _log.log(LogCategory.parse, 'Engine load: null (error response)');
      return null;
    }
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4104');
    final load = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Engine load: raw=$raw, value=$load%');
    return load;
  }

  @override
  Future<int?> getIntakeManifoldPressure() async {
    final response = await _sendCommand('010B');
    if (isErrorResponse(response)) {
      _log.log(LogCategory.parse, 'Intake pressure: null (error response)');
      return null;
    }
    final pressure = Obd2BaseService.parseOneByte(
      response,
      expectedHeader: '410B',
    );
    _log.log(LogCategory.parse, 'Intake pressure: $pressure kPa');
    return pressure;
  }

  @override
  Future<int?> getFuelLevel() async {
    final response = await _sendCommand('012F');
    if (isErrorResponse(response)) {
      _log.log(LogCategory.parse, 'Fuel level: null (error response)');
      return null;
    }
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '412F');
    final fuel = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Fuel level: raw=$raw, value=$fuel%');
    return fuel;
  }

  @override
  Future<String?> getVIN() async {
    final response = await _sendCommand('0902');
    if (response == null || response.isEmpty || isErrorResponse(response)) {
      _log.log(LogCategory.vin, 'VIN: no data');
      return null;
    }
    try {
      final vin = parseVIN(response);
      _log.log(LogCategory.vin, 'VIN decoded: $vin', 'Raw: $response');
      return vin;
    } catch (e) {
      _log.log(LogCategory.error, 'VIN: parse error', '$e | Raw: $response');
    }
    return null;
  }

  /// Parses VIN from multi-line OBD2 response (Mode 09 PID 02).
  /// Handles both ISO 15765 (CAN) and ISO 14230 / J1850 formats.
  static String? parseVIN(String raw) {
    // Filtrar líneas de error/ruido antes de procesar
    final lines = raw
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where(
          (l) =>
              l.isNotEmpty &&
              !l.toUpperCase().startsWith('SEARCHING') &&
              !l.toUpperCase().startsWith('STOPPED') &&
              !l.toUpperCase().startsWith('NO DATA') &&
              !l.toUpperCase().startsWith('ERROR') &&
              l != '?',
        )
        .toList();

    final dataBytes = <int>[];
    bool foundVinHeader = false;

    for (final line in lines) {
      // Saltar líneas que son negative response
      final lineUpper = line.toUpperCase().replaceAll(RegExp(r'[^0-9A-F]'), '');
      if (RegExp(r'^7F[0-9A-F]{4}').hasMatch(lineUpper)) continue;

      final hex = line.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      if (hex.isEmpty) continue;

      final bytes = <int>[];
      for (var i = 0; i + 1 < hex.length; i += 2) {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }

      if (bytes.isEmpty) continue;

      // Standard CAN response: 49 02 XX [VIN data...]
      if (bytes.length >= 3 && bytes[0] == 0x49 && bytes[1] == 0x02) {
        dataBytes.addAll(bytes.skip(3));
        foundVinHeader = true;
      }
      // CAN multi-frame first frame: 10 XX 49 02 01 [VIN data...]
      else if (bytes.length >= 5 &&
          bytes[0] == 0x10 &&
          bytes[2] == 0x49 &&
          bytes[3] == 0x02) {
        dataBytes.addAll(bytes.skip(5));
        foundVinHeader = true;
      }
      // CAN consecutive frame: 2X [data...] (solo si ya encontramos header)
      else if (foundVinHeader &&
          bytes.isNotEmpty &&
          (bytes[0] & 0xF0) == 0x20) {
        dataBytes.addAll(bytes.skip(1));
      }
      // NO fallback — si no reconocemos el formato, no metemos basura
    }

    // Convertir bytes a caracteres VIN válidos
    final vinChars = dataBytes
        .where((b) => b >= 0x30 && b <= 0x5A) // '0'-'Z' en ASCII
        .map((b) => String.fromCharCode(b))
        .where((c) => RegExp(r'[A-HJ-NPR-Z0-9]').hasMatch(c))
        .toList();

    final vin = vinChars.join();
    if (vin.length >= 17) {
      return vin.substring(0, 17);
    }
    // Si tenemos algo pero no 17 chars, puede ser parcial — retornar solo si razonable
    return vin.length >= 11 ? vin : null;
  }

  @override
  Future<String?> getProtocol() async {
    final response = await _sendCommand('ATDPN');
    return response?.trim();
  }

  /// Detecta el número de ECUs respondiendo al PID 0100.
  /// Con headers activados, cada ECU responde con su propia dirección.
  Future<int> detectECUCount() async {
    // Activar headers temporalmente para ver direcciones de ECU
    await _sendCommand('ATH1');
    final response = await _sendCommand('0100');
    // Restaurar headers off
    await _sendCommand('ATH0');

    if (response == null || response.isEmpty || isErrorResponse(response)) {
      _log.log(LogCategory.connection, 'ECU detection: no response');
      return 0;
    }

    _log.log(LogCategory.connection, 'ECU detection raw: $response');

    // Cada ECU responde con una línea que contiene "41 00" precedida
    // por su dirección (ej: "7E8 41 00 ..." o "7E8 06 41 00 ...").
    // Contamos líneas únicas con respuesta positiva "4100".
    final lines = response
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where(
          (l) =>
              l.isNotEmpty &&
              !l.startsWith('SEARCHING') &&
              !l.startsWith('AT') &&
              !isErrorLine(l),
        )
        .toList();

    final ecuAddresses = <String>{};
    for (final line in lines) {
      final hex = line.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      // Buscar "4100" en la respuesta — indica respuesta positiva de una ECU
      if (hex.contains('4100')) {
        // Extraer dirección de ECU (primeros 3 hex chars en CAN, ej: 7E8)
        // Con headers on, el formato es: [addr][len]4100[data]
        // Dirección CAN típica: 7E8, 7E9, 7EA, etc.
        final idx4100 = hex.indexOf('4100');
        if (idx4100 >= 3) {
          ecuAddresses.add(hex.substring(0, 3));
        } else {
          // Si no hay dirección clara, contar como ECU genérica
          ecuAddresses.add('ECU_${ecuAddresses.length}');
        }
      }
    }

    final count = ecuAddresses.isEmpty
        ? (lines.isNotEmpty ? 1 : 0)
        : ecuAddresses.length;
    _log.log(
      LogCategory.connection,
      'ECU detection: $count ECU(s) found',
      'Addresses: ${ecuAddresses.join(", ")}',
    );
    return count;
  }

  @override
  Future<List<DtcCode>> getDTCs() async {
    final response = await _sendCommand('03');
    if (response == null || response.isEmpty || isErrorResponse(response)) {
      _log.log(LogCategory.dtc, 'DTCs: no active codes');
      return [];
    }
    final codes = parseDTCResponse(response);
    _log.log(
      LogCategory.dtc,
      'DTCs found: ${codes.length}',
      codes.map((c) => '${c.code} (${c.severity.name})').join(', '),
    );
    return codes;
  }

  /// Parses DTC response from Mode 03.
  static List<DtcCode> parseDTCResponse(String raw) {
    final codes = <DtcCode>[];
    final lines = raw
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where(
          (l) => l.isNotEmpty && !l.startsWith('SEARCHING') && !isErrorLine(l),
        )
        .toList();

    final dtcBytes = <int>[];
    int? dtcCount;

    for (final line in lines) {
      final hex = line.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      if (hex.isEmpty) continue;

      final bytes = <int>[];
      for (var i = 0; i + 1 < hex.length; i += 2) {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }

      if (bytes.isEmpty) continue;

      // CAN multi-frame first frame: 10 XX 43 [count] [data...]
      if (bytes.length >= 4 && bytes[0] == 0x10 && bytes[2] == 0x43) {
        dtcCount = bytes[3];
        dtcBytes.addAll(bytes.skip(4));
      }
      // Standard response: 43 [count] [DTC pairs...]
      else if (bytes.isNotEmpty && bytes[0] == 0x43) {
        if (bytes.length >= 2) {
          dtcCount = bytes[1];
          dtcBytes.addAll(bytes.skip(2));
        }
      }
      // CAN consecutive frame: 2X [data...]
      else if (bytes.isNotEmpty && (bytes[0] & 0xF0) == 0x20) {
        dtcBytes.addAll(bytes.skip(1));
      }
    }

    if (dtcCount != null && dtcCount == 0) return [];

    final maxDtcs = dtcCount ?? (dtcBytes.length ~/ 2);

    int parsed = 0;
    for (var i = 0; i + 1 < dtcBytes.length && parsed < maxDtcs; i += 2) {
      final high = dtcBytes[i];
      final low = dtcBytes[i + 1];
      if (high == 0 && low == 0) continue;

      final dtcHex =
          high.toRadixString(16).padLeft(2, '0') +
          low.toRadixString(16).padLeft(2, '0');
      final code = Obd2BaseService.decodeDTC(dtcHex);
      if (code != null) {
        codes.add(
          DtcCode(
            code: code,
            description: Obd2BaseService.getDTCDescription(code),
            severity: Obd2BaseService.getDTCSeverity(code),
          ),
        );
        parsed++;
      }
    }
    return codes;
  }

  @override
  Future<bool> clearDTCs() async {
    _log.log(LogCategory.dtc, 'Sending clear DTCs command');
    final response = await _sendCommand('04');
    final success = response != null && !response.contains('ERROR');
    _log.log(
      LogCategory.dtc,
      'Clear DTCs: ${success ? "OK" : "FAILED"}',
      'Response: $response',
    );
    return success;
  }

  @override
  void dispose() {
    disconnect();
  }

  // ── Filtrado de respuestas de error ELM327 ──────────────

  /// Detecta si una respuesta completa es un error del ELM327 o del ECU.
  /// Público para que otros servicios (BT) puedan reutilizarlo.
  static bool isErrorResponse(String? response) {
    if (response == null || response.isEmpty) return true;
    final upper = response.toUpperCase().trim();
    if (upper == 'STOPPED' || upper == '?' || upper == 'NO DATA') return true;
    if (upper.startsWith('ERROR')) return true;
    final cleaned = upper.replaceAll(RegExp(r'[^0-9A-F]'), '');
    if (!cleaned.contains('41') &&
        !cleaned.contains('43') &&
        !cleaned.contains('49')) {
      if (upper.contains('STOPPED') || upper.contains('7F')) return true;
    }
    return false;
  }

  /// Detecta si una línea individual es ruido/error.
  /// Público para que otros servicios (BT) puedan reutilizarlo.
  static bool isErrorLine(String line) {
    final upper = line.toUpperCase().trim();
    if (upper.isEmpty) return true;
    if (upper == 'STOPPED' || upper == '?' || upper == 'NO DATA') return true;
    if (upper.startsWith('ERROR')) return true;
    if (upper.startsWith('STOPPED') && !upper.contains('41')) return true;
    final cleaned = upper.replaceAll(RegExp(r'[^0-9A-F]'), '');
    if (RegExp(r'^7F[0-9A-F]{4}$').hasMatch(cleaned)) return true;
    return false;
  }
}
