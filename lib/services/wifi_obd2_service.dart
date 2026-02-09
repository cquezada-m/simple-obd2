import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../models/dtc_code.dart';
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

  /// Conecta al adaptador OBD2 WiFi via TCP socket
  Future<void> connect({
    String host = defaultHost,
    int port = defaultPort,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _socket = await Socket.connect(host, port, timeout: timeout);
    _connected = true;

    _socket!.listen(
      (data) {
        _buffer += utf8.decode(data, allowMalformed: true);
      },
      onError: (_) => disconnect(),
      onDone: () => disconnect(),
    );

    // Inicializar ELM327
    await _sendCommand('ATZ');
    await Future.delayed(const Duration(seconds: 1));
    await _sendCommand('ATE0');
    await _sendCommand('ATL0');
    await _sendCommand('ATS0');
    await _sendCommand('ATH0');
    await _sendCommand('ATSP0');
  }

  @override
  Future<void> disconnect() async {
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

    // Esperar hasta que llegue el prompt '>' o timeout
    final stopwatch = Stopwatch()..start();
    while (!_buffer.contains('>') && stopwatch.elapsed.inSeconds < 5) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final response = _buffer.trim().replaceAll('>', '');
    _buffer = '';
    return response.isEmpty ? null : response;
  }

  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand('010C');
    final raw = Obd2BaseService.parseTwoBytes(response);
    return raw != null ? raw ~/ 4 : null;
  }

  @override
  Future<int?> getSpeed() async {
    final response = await _sendCommand('010D');
    return Obd2BaseService.parseOneByte(response);
  }

  @override
  Future<int?> getCoolantTemp() async {
    final response = await _sendCommand('0105');
    final raw = Obd2BaseService.parseOneByte(response);
    return raw != null ? raw - 40 : null;
  }

  @override
  Future<int?> getEngineLoad() async {
    final response = await _sendCommand('0104');
    final raw = Obd2BaseService.parseOneByte(response);
    return raw != null ? (raw * 100) ~/ 255 : null;
  }

  @override
  Future<int?> getIntakeManifoldPressure() async {
    final response = await _sendCommand('010B');
    return Obd2BaseService.parseOneByte(response);
  }

  @override
  Future<int?> getFuelLevel() async {
    final response = await _sendCommand('012F');
    final raw = Obd2BaseService.parseOneByte(response);
    return raw != null ? (raw * 100) ~/ 255 : null;
  }

  @override
  Future<String?> getVIN() async {
    final response = await _sendCommand('0902');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }
    try {
      final cleaned = response.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      final bytes = <int>[];
      for (var i = 0; i < cleaned.length - 1; i += 2) {
        bytes.add(int.parse(cleaned.substring(i, i + 2), radix: 16));
      }
      return String.fromCharCodes(bytes.where((b) => b >= 32 && b <= 126));
    } catch (_) {}
    return null;
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
      return [];
    }

    final codes = <DtcCode>[];
    final cleaned = response.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');

    for (var i = 0; i < cleaned.length - 3; i += 4) {
      final dtcHex = cleaned.substring(i, i + 4);
      final code = Obd2BaseService.decodeDTC(dtcHex);
      if (code != null && code.isNotEmpty) {
        codes.add(
          DtcCode(
            code: code,
            description: Obd2BaseService.getDTCDescription(code),
            severity: Obd2BaseService.getDTCSeverity(code),
          ),
        );
      }
    }
    return codes;
  }

  @override
  Future<bool> clearDTCs() async {
    final response = await _sendCommand('04');
    return response != null && !response.contains('ERROR');
  }

  @override
  void dispose() {
    disconnect();
  }
}
