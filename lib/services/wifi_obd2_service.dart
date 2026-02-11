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

  /// IP y puerto por defecto de adaptadores ELM327 WiFi
  static const String defaultHost = '192.168.0.10';
  static const int defaultPort = 35000;

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
        disconnect();
      },
      onDone: () {
        _log.log(LogCategory.connection, 'WiFi: socket closed by adapter');
        disconnect();
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

  @override
  Future<void> disconnect() async {
    _log.log(LogCategory.connection, 'WiFi: disconnecting');
    _connected = false;
    await _socket?.close();
    _socket?.destroy();
    _socket = null;
  }

  /// Envía un comando AT/OBD y espera la respuesta (delimitada por '>')
  Future<String?> _sendCommand(String command) async {
    if (!isConnected) return null;

    _buffer = '';
    _socket!.add(utf8.encode('$command\r'));
    await _socket!.flush();
    _log.log(LogCategory.command, 'WiFi TX: $command');

    // Esperar hasta que llegue el prompt '>' o timeout
    final stopwatch = Stopwatch()..start();
    while (!_buffer.contains('>') && stopwatch.elapsed.inSeconds < 5) {
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
  }

  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand('010C');
    final raw = Obd2BaseService.parseTwoBytes(response, expectedHeader: '410C');
    final rpm = raw != null ? raw ~/ 4 : null;
    _log.log(LogCategory.parse, 'RPM: raw=$raw, value=$rpm');
    return rpm;
  }

  @override
  Future<int?> getSpeed() async {
    final response = await _sendCommand('010D');
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
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4105');
    final temp = raw != null ? raw - 40 : null;
    _log.log(LogCategory.parse, 'Coolant temp: raw=$raw, value=$temp°C');
    return temp;
  }

  @override
  Future<int?> getEngineLoad() async {
    final response = await _sendCommand('0104');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4104');
    final load = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Engine load: raw=$raw, value=$load%');
    return load;
  }

  @override
  Future<int?> getIntakeManifoldPressure() async {
    final response = await _sendCommand('010B');
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
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '412F');
    final fuel = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Fuel level: raw=$raw, value=$fuel%');
    return fuel;
  }

  @override
  Future<String?> getVIN() async {
    final response = await _sendCommand('0902');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
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
    // Split into lines and process each
    final lines = raw
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !l.startsWith('SEARCHING'))
        .toList();

    final dataBytes = <int>[];

    for (final line in lines) {
      final hex = line.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      if (hex.isEmpty) continue;

      // Convert to byte list
      final bytes = <int>[];
      for (var i = 0; i + 1 < hex.length; i += 2) {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }

      if (bytes.isEmpty) continue;

      // CAN format: first line starts with 49 02 01, continuation with 49 02 0x
      // or multi-frame: 10 14 49 02 01 ... then 21 ... 22 ...
      if (bytes.length >= 3 && bytes[0] == 0x49 && bytes[1] == 0x02) {
        // Standard CAN response: skip 49 02 XX (3 bytes header)
        dataBytes.addAll(bytes.skip(3));
      } else if (bytes.length >= 5 &&
          bytes[0] == 0x10 &&
          bytes[2] == 0x49 &&
          bytes[3] == 0x02) {
        // CAN multi-frame first frame: 10 XX 49 02 01 [data...]
        dataBytes.addAll(bytes.skip(5));
      } else if (bytes.isNotEmpty && (bytes[0] & 0xF0) == 0x20) {
        // CAN consecutive frame: 2X [data...]
        dataBytes.addAll(bytes.skip(1));
      } else {
        // Fallback: try to extract printable ASCII
        dataBytes.addAll(bytes);
      }
    }

    // Filter to valid VIN characters (alphanumeric, no I/O/Q)
    final vinChars = dataBytes
        .where((b) => b >= 0x20 && b <= 0x7E)
        .map((b) => String.fromCharCode(b))
        .where((c) => RegExp(r'[A-HJ-NPR-Z0-9]').hasMatch(c))
        .toList();

    final vin = vinChars.join();

    // A valid VIN is exactly 17 characters
    if (vin.length >= 17) {
      return vin.substring(0, 17);
    }
    return vin.isNotEmpty ? vin : null;
  }

  @override
  Future<String?> getProtocol() async {
    final response = await _sendCommand('ATDPN');
    return response?.trim();
  }

  @override
  Future<List<DtcCode>> getDTCs() async {
    final response = await _sendCommand('03');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
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
  /// Response header is 43 followed by a count byte, then pairs of DTC bytes.
  /// Format: 43 [count] [DTC1_high] [DTC1_low] [DTC2_high] [DTC2_low] ...
  static List<DtcCode> parseDTCResponse(String raw) {
    final codes = <DtcCode>[];
    final lines = raw
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !l.startsWith('SEARCHING'))
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
      // Ignore any other lines (echoes, protocol noise, etc.)
    }

    // If the ECU reported 0 DTCs, return empty
    if (dtcCount != null && dtcCount == 0) return [];

    // Determine how many DTCs to parse
    final maxDtcs = dtcCount ?? (dtcBytes.length ~/ 2);

    // Each DTC is 2 bytes
    int parsed = 0;
    for (var i = 0; i + 1 < dtcBytes.length && parsed < maxDtcs; i += 2) {
      final high = dtcBytes[i];
      final low = dtcBytes[i + 1];
      if (high == 0 && low == 0) continue; // padding

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
}
