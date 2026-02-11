import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/dtc_code.dart';
import 'obd2_base_service.dart';
import 'wifi_obd2_service.dart';

class Obd2Service implements Obd2BaseService {
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  final _responseController = StreamController<String>.broadcast();
  String _buffer = '';

  Stream<String> get responseStream => _responseController.stream;
  @override
  bool get isConnected => _connection != null && _connection!.isConnected;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  Future<List<BluetoothDevice>> getPairedDevices() async {
    return await FlutterBluetoothSerial.instance.getBondedDevices();
  }

  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluetoothSerial.instance.isEnabled ?? false;
  }

  Future<bool> enableBluetooth() async {
    return await FlutterBluetoothSerial.instance.requestEnable() ?? false;
  }

  Future<void> connect(BluetoothDevice device) async {
    _connection = await BluetoothConnection.toAddress(device.address);
    _connectedDevice = device;

    _connection!.input?.listen(
      (data) {
        _buffer += ascii.decode(data);
        if (_buffer.contains('>')) {
          final response = _buffer.trim().replaceAll('>', '');
          _responseController.add(response);
          _buffer = '';
        }
      },
      onDone: () {
        disconnect();
      },
    );

    // Inicializar ELM327
    await _sendCommand('ATZ'); // Reset
    await Future.delayed(const Duration(seconds: 1));
    await _sendCommand('ATE0'); // Echo off
    await _sendCommand('ATL0'); // Linefeeds off
    await _sendCommand('ATS0'); // Spaces off
    await _sendCommand('ATH0'); // Headers off
    await _sendCommand('ATSP0'); // Auto protocol
  }

  @override
  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _connectedDevice = null;
  }

  Future<String?> _sendCommand(String command) async {
    if (!isConnected) return null;

    final completer = Completer<String>();
    late StreamSubscription sub;

    sub = _responseController.stream.listen((response) {
      sub.cancel();
      completer.complete(response);
    });

    _connection!.output.add(Uint8List.fromList('$command\r'.codeUnits));
    await _connection!.output.allSent;

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        sub.cancel();
        return '';
      },
    );
  }

  /// Lee RPM: PID 010C
  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand('010C');
    final raw = Obd2BaseService.parseTwoBytes(response, expectedHeader: '410C');
    return raw != null ? raw ~/ 4 : null;
  }

  /// Lee velocidad: PID 010D
  @override
  Future<int?> getSpeed() async {
    final response = await _sendCommand('010D');
    return Obd2BaseService.parseOneByte(response, expectedHeader: '410D');
  }

  /// Lee temperatura del motor: PID 0105
  @override
  Future<int?> getCoolantTemp() async {
    final response = await _sendCommand('0105');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4105');
    return raw != null ? raw - 40 : null;
  }

  /// Lee carga del motor: PID 0104
  @override
  Future<int?> getEngineLoad() async {
    final response = await _sendCommand('0104');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4104');
    return raw != null ? (raw * 100) ~/ 255 : null;
  }

  /// Lee presión del colector de admisión: PID 010B
  @override
  Future<int?> getIntakeManifoldPressure() async {
    final response = await _sendCommand('010B');
    return Obd2BaseService.parseOneByte(response, expectedHeader: '410B');
  }

  /// Lee nivel de combustible: PID 012F
  @override
  Future<int?> getFuelLevel() async {
    final response = await _sendCommand('012F');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '412F');
    return raw != null ? (raw * 100) ~/ 255 : null;
  }

  /// Lee VIN: PID 0902
  @override
  Future<String?> getVIN() async {
    final response = await _sendCommand('0902');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }
    try {
      return WifiObd2Service.parseVIN(response);
    } catch (_) {}
    return null;
  }

  /// Lee protocolo OBD
  @override
  Future<String?> getProtocol() async {
    final response = await _sendCommand('ATDPN');
    return response?.trim();
  }

  /// Lee códigos DTC
  @override
  Future<List<DtcCode>> getDTCs() async {
    final response = await _sendCommand('03');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return [];
    }
    return WifiObd2Service.parseDTCResponse(response);
  }

  /// Borra códigos DTC
  @override
  Future<bool> clearDTCs() async {
    final response = await _sendCommand('04');
    return response != null && !response.contains('ERROR');
  }

  @override
  void dispose() {
    disconnect();
    _responseController.close();
  }
}
