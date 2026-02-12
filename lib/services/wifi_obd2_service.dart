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

  /// true si el protocolo detectado es CAN (ISO 15765-4).
  /// En CAN, múltiples ECUs pueden responder al mismo PID.
  /// Se usa para decidir si aplicar filtrado de ECU y sufijo de respuesta.
  bool _isCan = false;

  /// Dirección CAN de la ECU primaria del motor (típicamente 7E8).
  /// Se detecta automáticamente durante la inicialización.
  String? _primaryEcuAddress;

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
    await _sendCommand('ATE0'); // Echo off
    await _sendCommand('ATL0'); // Linefeeds off
    await _sendCommand('ATS0'); // Spaces off
    await _sendCommand('ATH0'); // Headers off
    await _sendCommand('ATSP0'); // Auto protocol detection

    // Forzar detección de protocolo enviando un PID básico
    await _sendCommand('0100');

    // Detectar protocolo negociado y configurar filtrado CAN
    await _detectAndConfigureProtocol();

    _log.log(LogCategory.connection, 'WiFi: ELM327 initialized (CAN=$_isCan)');
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
    _isCan = false;
    _primaryEcuAddress = null;
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

  // ── Detección de protocolo y filtrado CAN ───────────────

  /// Detecta el protocolo OBD2 negociado y, si es CAN, configura el ELM327
  /// para hablar solo con la ECU primaria del motor.
  ///
  /// Protocolos ELM327 (ATDPN):
  ///   1 = SAE J1850 PWM          (Ford)
  ///   2 = SAE J1850 VPW          (GM)
  ///   3 = ISO 9141-2             (Chrysler/EU/Asia pre-2004)
  ///   4 = ISO 14230-4 KWP slow   (EU/Asia 2003+)
  ///   5 = ISO 14230-4 KWP fast   (EU/Asia 2003+)
  ///   6 = ISO 15765-4 CAN 11/500 (estándar moderno)
  ///   7 = ISO 15765-4 CAN 29/500
  ///   8 = ISO 15765-4 CAN 11/250
  ///   9 = ISO 15765-4 CAN 29/250
  ///   A = SAE J1939 CAN 29/250
  ///   B = User1 CAN 11/125
  ///   C = User2 CAN 11/50
  ///
  /// En CAN (6-C), el tester envía broadcast a 7DF y TODAS las ECUs
  /// responden (7E8=motor, 7E9=transmisión, 7EA=ABS, etc.).
  /// Configuramos ATCRA para aceptar solo la ECU del motor.
  ///
  /// En protocolos legacy (1-5), típicamente solo hay una ECU
  /// respondiendo, así que no necesitamos filtrado.
  Future<void> _detectAndConfigureProtocol() async {
    final protocolRaw = await _sendCommand('ATDPN');
    if (protocolRaw == null || protocolRaw.isEmpty) {
      _log.log(LogCategory.connection, 'Protocol detection: no response');
      _isCan = false;
      return;
    }

    // ATDPN retorna algo como "A6" (auto-detected protocol 6) o "6"
    // El prefijo 'A' indica auto-detected. El dígito restante es el protocolo.
    var cleaned = protocolRaw.trim().toUpperCase();
    if (cleaned.startsWith('A')) cleaned = cleaned.substring(1);
    final protocolNum = int.tryParse(cleaned, radix: 16) ?? 0;

    _isCan = protocolNum >= 6; // 6-C son todos CAN
    _log.log(
      LogCategory.connection,
      'Protocol detected: $protocolRaw (num=$protocolNum, CAN=$_isCan)',
    );

    if (!_isCan) return;

    // En CAN: detectar la dirección de la ECU primaria del motor.
    // Activamos headers para ver las direcciones de respuesta.
    await _sendCommand('ATH1');
    final response = await _sendCommand('0100');
    await _sendCommand('ATH0');

    if (response == null || response.isEmpty) {
      _log.log(LogCategory.connection, 'CAN ECU detection: no response');
      return;
    }

    // Buscar la primera dirección de ECU que responde con 4100.
    // En CAN 11-bit, las respuestas OBD van de 7E8 a 7EF.
    // 7E8 es casi siempre la ECU del motor (powertrain).
    _primaryEcuAddress = findPrimaryEcuAddress(response);

    if (_primaryEcuAddress != null) {
      // ATCRA = Set CAN Receive Address
      // Le dice al ELM327 que solo acepte frames CAN de esta dirección.
      // Esto elimina en HARDWARE las respuestas de ECUs secundarias,
      // evitando STOPPED, 7F, y datos duplicados.
      final craResult = await _sendCommand('ATCRA$_primaryEcuAddress');
      if (craResult != null &&
          !craResult.contains('?') &&
          !craResult.toUpperCase().contains('ERROR')) {
        _log.log(
          LogCategory.connection,
          'CAN filter set: ATCRA$_primaryEcuAddress (only primary ECU)',
        );
      } else {
        // Adaptador no soporta ATCRA (clon barato). El filtrado por software
        // en sanitizeResponse() y _extractResponseData() sigue funcionando.
        _log.log(
          LogCategory.connection,
          'CAN filter ATCRA not supported by adapter, using software filtering',
        );
      }
    } else {
      _log.log(
        LogCategory.connection,
        'CAN ECU detection: could not identify primary ECU, no filter set',
      );
    }
  }

  /// Busca la dirección de la ECU primaria del motor en una respuesta
  /// con headers activados. Prioriza 7E8 (estándar para motor en CAN 11-bit)
  /// o 18DAF110 (estándar para motor en CAN 29-bit).
  /// Público para que el servicio BT pueda reutilizarlo.
  static String? findPrimaryEcuAddress(String response) {
    final lines = response
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !isErrorLine(l))
        .toList();

    final ecuAddresses = <String>{};
    for (final line in lines) {
      final hex = line.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '').toUpperCase();
      if (!hex.contains('4100')) continue;

      final idx = hex.indexOf('4100');
      if (idx == 3) {
        // CAN 11-bit: 3 hex chars de dirección (ej: 7E8 4100...)
        ecuAddresses.add(hex.substring(0, 3));
      } else if (idx == 8) {
        // CAN 29-bit: 8 hex chars de dirección (ej: 18DAF110 4100...)
        ecuAddresses.add(hex.substring(0, 8));
      }
    }

    if (ecuAddresses.isEmpty) return null;

    // Priorizar direcciones estándar del motor
    // CAN 11-bit: 7E8
    if (ecuAddresses.contains('7E8')) return '7E8';
    // CAN 29-bit: 18DAF110 (motor responde a tester F1)
    for (final addr in ecuAddresses) {
      if (addr.startsWith('18DAF1')) return addr;
    }
    // Fallback: la primera dirección encontrada
    return ecuAddresses.first;
  }

  /// Construye el comando OBD para polling.
  /// En CAN con múltiples ECUs, agrega '1' al final del comando
  /// para decirle al ELM327 que espere solo 1 respuesta y retorne
  /// inmediatamente. Esto es más rápido y evita respuestas tardías.
  ///
  /// Ejemplo: '010C' → '010C1' (en CAN), '010C' (en KWP/ISO)
  ///
  /// Solo se usa para PIDs de polling (Mode 01). Para Mode 03 (DTCs),
  /// Mode 04 (clear), Mode 09 (VIN) no se aplica porque pueden
  /// necesitar multi-frame o respuestas de múltiples ECUs.
  String _pidCommand(String pid) {
    if (_isCan && _primaryEcuAddress != null) {
      return '${pid}1';
    }
    return pid;
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
        try {
          await _socket!.flush();
        } catch (_) {
          // flush() puede fallar con "StreamSink is bound to a stream"
          // en condiciones de alta concurrencia. El dato ya fue enviado
          // por add(), flush solo espera confirmación.
        }
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

      // Drenar datos tardíos de ECUs secundarias que llegan después del '>'
      // En coches multi-ECU (BMW, etc.) la segunda ECU puede responder
      // después de que la primera ya envió el prompt.
      await Future.delayed(const Duration(milliseconds: 80));

      final response = _buffer.trim().replaceAll('>', '');
      // Limpiar buffer completamente incluyendo datos tardíos
      _buffer = '';
      final elapsed = stopwatch.elapsedMilliseconds;
      _log.log(
        LogCategory.command,
        'WiFi RX (${elapsed}ms): ${response.isEmpty ? "<empty>" : response}',
      );

      if (response.isEmpty) return null;

      // Sanitizar: eliminar líneas de error/ruido de ECUs que no soportan el PID
      final sanitized = sanitizeResponse(response);
      return sanitized.isEmpty ? null : sanitized;
    } finally {
      _releaseLock();
    }
  }

  /// Elimina líneas de ruido de la respuesta multi-ECU:
  /// - STOPPED (ECU interrumpida por otra respuesta)
  /// - 7Fxxxx (negative response de ECU que no soporta el PID)
  /// - Líneas vacías
  /// Retorna solo las líneas con datos válidos.
  /// Público para que el servicio BT pueda reutilizarlo.
  static String sanitizeResponse(String response) {
    final lines = response.split(RegExp(r'[\r\n]+')).map((l) => l.trim()).where(
      (l) {
        if (l.isEmpty) return false;
        final upper = l.toUpperCase();
        // Eliminar STOPPED
        if (upper == 'STOPPED') return false;
        // Eliminar negative responses (7F xx xx)
        final cleaned = upper.replaceAll(RegExp(r'[^0-9A-F]'), '');
        if (RegExp(r'^7F[0-9A-F]{4}$').hasMatch(cleaned)) return false;
        // Eliminar líneas que son solo "?" o "ERROR"
        if (upper == '?' || upper.startsWith('ERROR')) return false;
        return true;
      },
    ).toList();
    return lines.join('\n');
  }

  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand(_pidCommand('010C'));
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
    final response = await _sendCommand(_pidCommand('010D'));
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
    final response = await _sendCommand(_pidCommand('0105'));
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
    final response = await _sendCommand(_pidCommand('0104'));
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
    final response = await _sendCommand(_pidCommand('010B'));
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
    final response = await _sendCommand(_pidCommand('012F'));
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
  /// Handles both ISO 15765 (CAN) and ISO 14230 / J1850 formats,
  /// including ELM327 ISO-TP sequence-numbered frames (0:, 1:, ...).
  static String? parseVIN(String raw) {
    // Try ISO-TP sequence format first (0:, 1:, 2:...)
    final isoTpBytes = _parseIsoTpSequenceFrames(raw);
    if (isoTpBytes != null && isoTpBytes.isNotEmpty) {
      return _decodeVinFromBytes(isoTpBytes);
    }

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

  /// Decodes VIN from raw concatenated ISO-TP bytes.
  /// Expects bytes starting with 49 02 XX [VIN ASCII data...]
  static String? _decodeVinFromBytes(List<int> bytes) {
    // Find the 49 02 header (Mode 09 PID 02 response)
    int startIdx = -1;
    for (var i = 0; i + 1 < bytes.length; i++) {
      if (bytes[i] == 0x49 && bytes[i + 1] == 0x02) {
        startIdx = i + 3; // skip 49 02 XX (XX = number of data items)
        break;
      }
    }
    if (startIdx < 0 || startIdx >= bytes.length) return null;

    final vinChars = bytes
        .sublist(startIdx)
        .where((b) => b >= 0x30 && b <= 0x5A)
        .map((b) => String.fromCharCode(b))
        .where((c) => RegExp(r'[A-HJ-NPR-Z0-9]').hasMatch(c))
        .toList();

    final vin = vinChars.join();
    if (vin.length >= 17) return vin.substring(0, 17);
    return vin.length >= 11 ? vin : null;
  }

  @override
  Future<String?> getProtocol() async {
    final response = await _sendCommand('ATDPN');
    return response?.trim();
  }

  /// Detecta el número de ECUs respondiendo al PID 0100.
  /// En CAN, temporalmente desactiva el filtro ATCRA para ver todas las ECUs.
  /// En protocolos legacy, simplemente cuenta las respuestas.
  Future<int> detectECUCount() async {
    // Si estamos en CAN con filtro activo, necesitamos desactivarlo
    // temporalmente para ver TODAS las ECUs.
    // ATAR = Automatic Receive — restaura el filtrado automático del ELM327.
    if (_isCan && _primaryEcuAddress != null) {
      await _sendCommand('ATAR');
    }

    // Activar headers temporalmente para ver direcciones de ECU
    await _sendCommand('ATH1');
    final response = await _sendCommand('0100');
    // Restaurar headers off
    await _sendCommand('ATH0');

    // Restaurar filtro CAN si estaba activo
    if (_isCan && _primaryEcuAddress != null) {
      await _sendCommand('ATCRA$_primaryEcuAddress');
    }

    if (response == null || response.isEmpty || isErrorResponse(response)) {
      _log.log(LogCategory.connection, 'ECU detection: no response');
      return 0;
    }

    _log.log(LogCategory.connection, 'ECU detection raw: $response');

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
      if (hex.toUpperCase().contains('4100')) {
        final idx4100 = hex.toUpperCase().indexOf('4100');
        if (idx4100 >= 3) {
          ecuAddresses.add(hex.substring(0, 3));
        } else {
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

  /// Detects and reassembles ISO-TP sequence-numbered framing used by some
  /// ELM327 adapters. Returns the concatenated hex data bytes as a list.
  ///
  /// Input like:
  ///   00A
  ///   0:430411AB3008
  ///   1:0100242F000000
  ///
  /// Returns all hex bytes concatenated in order: [43,04,11,AB,30,08,01,00,24,2F,00,00,00]
  /// Returns null if the response is not in ISO-TP sequence format.
  static List<int>? _parseIsoTpSequenceFrames(String raw) {
    final lines = raw.split(RegExp(r'[\r\n]+'));
    // Detect if any line matches the "N:hexdata" pattern
    final hasSeqPrefix = lines.any((l) => RegExp(r'^\s*\d+\s*:').hasMatch(l));
    if (!hasSeqPrefix) return null;

    // Collect frames in sequence order
    final frames = <int, String>{};
    for (final line in lines) {
      final trimmed = line.trim();
      final seqMatch = RegExp(r'^(\d+)\s*:\s*(.*)$').firstMatch(trimmed);
      if (seqMatch != null) {
        final seq = int.parse(seqMatch.group(1)!);
        final hexData = seqMatch
            .group(2)!
            .replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
        frames[seq] = hexData;
      }
    }

    if (frames.isEmpty) return null;

    // Concatenate all frames in order
    final sortedKeys = frames.keys.toList()..sort();
    final allHex = sortedKeys.map((k) => frames[k]!).join();

    final bytes = <int>[];
    for (var i = 0; i + 1 < allHex.length; i += 2) {
      bytes.add(int.parse(allHex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  /// Parses DTC response from Mode 03.
  /// Handles multiple formats:
  /// - Standard single-frame: 43 [count] [DTC pairs...]
  /// - CAN multi-frame (10 XX 43 ...): ISO-TP first frame + 2X consecutive
  /// - ELM327 ISO-TP with sequence prefixes (0:, 1:, 2:...):
  ///     00A\n0:430411AB3008\n1:0100242F000000
  static List<DtcCode> parseDTCResponse(String raw) {
    // Try ISO-TP sequence format first (0:, 1:, 2:...)
    final isoTpBytes = _parseIsoTpSequenceFrames(raw);
    if (isoTpBytes != null && isoTpBytes.isNotEmpty) {
      return _decodeDtcBytes(isoTpBytes);
    }

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

    return _decodeDtcBytesWithCount(dtcBytes, dtcCount);
  }

  /// Decodes DTC codes from raw bytes that start with the Mode 03 header.
  /// Used for ISO-TP sequence-framed responses where all bytes are
  /// concatenated: [43, count, high, low, high, low, ...]
  static List<DtcCode> _decodeDtcBytes(List<int> bytes) {
    if (bytes.isEmpty) return [];
    // Expect first byte to be 0x43 (Mode 03 response)
    if (bytes[0] != 0x43) return [];
    final dtcCount = bytes.length >= 2 ? bytes[1] : 0;
    if (dtcCount == 0) return [];
    final dtcBytes = bytes.sublist(2);
    return _decodeDtcBytesWithCount(dtcBytes, dtcCount);
  }

  /// Shared helper: decode DTC pairs from raw byte list.
  static List<DtcCode> _decodeDtcBytesWithCount(
    List<int> dtcBytes,
    int? dtcCount,
  ) {
    final codes = <DtcCode>[];
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
  /// Después de sanitización, la respuesta solo contiene líneas de datos válidos.
  /// Público para que otros servicios (BT) puedan reutilizarlo.
  static bool isErrorResponse(String? response) {
    if (response == null || response.isEmpty) return true;
    final upper = response.toUpperCase().trim();
    if (upper == 'STOPPED' || upper == '?' || upper == 'NO DATA') return true;
    if (upper.startsWith('ERROR')) return true;
    // Verificar si hay al menos una línea con datos OBD válidos (41xx, 43xx, 49xx)
    final lines = upper.split(RegExp(r'[\r\n]+'));
    for (final line in lines) {
      final cleaned = line.trim().replaceAll(RegExp(r'[^0-9A-F]'), '');
      if (cleaned.contains('41') ||
          cleaned.contains('43') ||
          cleaned.contains('49')) {
        return false; // Hay datos válidos
      }
    }
    // No encontramos datos OBD válidos
    return true;
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
