import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/dtc_code.dart';
import 'app_logger.dart';
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

  static final _log = AppLogger.instance;

  Future<List<BluetoothDevice>> getPairedDevices() async {
    _log.log(LogCategory.connection, 'BT: searching paired devices');
    final devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    _log.log(
      LogCategory.connection,
      'BT: ${devices.length} devices found',
      devices.map((d) => '${d.name ?? "?"} (${d.address})').join(', '),
    );
    return devices;
  }

  Future<bool> isBluetoothEnabled() async {
    return await FlutterBluetoothSerial.instance.isEnabled ?? false;
  }

  Future<bool> enableBluetooth() async {
    return await FlutterBluetoothSerial.instance.requestEnable() ?? false;
  }

  Future<void> connect(BluetoothDevice device) async {
    _log.log(
      LogCategory.connection,
      'BT: connecting to ${device.name ?? "?"} (${device.address})',
    );
    _connection = await BluetoothConnection.toAddress(device.address);
    _connectedDevice = device;
    _log.log(LogCategory.connection, 'BT: connection established');

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
        _log.log(LogCategory.connection, 'BT: connection closed by adapter');
        disconnect();
      },
    );

    // Inicializar ELM327
    _log.log(LogCategory.connection, 'BT: initializing ELM327');
    await _sendCommand('ATZ'); // Reset
    await Future.delayed(const Duration(seconds: 1));
    await _sendCommand('ATE0'); // Echo off
    await _sendCommand('ATL0'); // Linefeeds off
    await _sendCommand('ATS0'); // Spaces off
    await _sendCommand('ATH0'); // Headers off
    await _sendCommand('ATSP0'); // Auto protocol
    _log.log(LogCategory.connection, 'BT: ELM327 initialized');
  }

  @override
  Future<void> disconnect() async {
    _log.log(LogCategory.connection, 'BT: disconnecting');
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
    _log.log(LogCategory.command, 'BT TX: $command');

    final response = await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        sub.cancel();
        _log.log(LogCategory.error, 'BT RX: timeout para $command');
        return '';
      },
    );
    _log.log(
      LogCategory.command,
      'BT RX: ${response.isEmpty ? "<empty>" : response}',
    );
    return response;
  }

  /// Lee RPM: PID 010C
  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand('010C');
    final raw = Obd2BaseService.parseTwoBytes(response, expectedHeader: '410C');
    final rpm = raw != null ? raw ~/ 4 : null;
    _log.log(LogCategory.parse, 'RPM: raw=$raw, value=$rpm');
    return rpm;
  }

  /// Lee velocidad: PID 010D
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

  /// Lee temperatura del motor: PID 0105
  @override
  Future<int?> getCoolantTemp() async {
    final response = await _sendCommand('0105');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4105');
    final temp = raw != null ? raw - 40 : null;
    _log.log(LogCategory.parse, 'Coolant temp: raw=$raw, value=$temp°C');
    return temp;
  }

  /// Lee carga del motor: PID 0104
  @override
  Future<int?> getEngineLoad() async {
    final response = await _sendCommand('0104');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4104');
    final load = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Engine load: raw=$raw, value=$load%');
    return load;
  }

  /// Lee presión del colector de admisión: PID 010B
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

  /// Lee nivel de combustible: PID 012F
  @override
  Future<int?> getFuelLevel() async {
    final response = await _sendCommand('012F');
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '412F');
    final fuel = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Fuel level: raw=$raw, value=$fuel%');
    return fuel;
  }

  /// Lee VIN: PID 0902
  @override
  Future<String?> getVIN() async {
    final response = await _sendCommand('0902');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      _log.log(LogCategory.vin, 'VIN: no data');
      return null;
    }
    try {
      final vin = WifiObd2Service.parseVIN(response);
      _log.log(LogCategory.vin, 'VIN decoded: $vin', 'Raw: $response');
      return vin;
    } catch (e) {
      _log.log(LogCategory.error, 'VIN: parse error', '$e | Raw: $response');
    }
    return null;
  }

  /// Lee protocolo OBD
  @override
  Future<String?> getProtocol() async {
    final response = await _sendCommand('ATDPN');
    _log.log(LogCategory.parse, 'Protocol: ${response?.trim()}');
    return response?.trim();
  }

  /// Lee códigos DTC
  @override
  Future<List<DtcCode>> getDTCs() async {
    final response = await _sendCommand('03');
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      _log.log(LogCategory.dtc, 'DTCs: no active codes');
      return [];
    }
    final codes = WifiObd2Service.parseDTCResponse(response);
    _log.log(
      LogCategory.dtc,
      'DTCs found: ${codes.length}',
      codes.map((c) => '${c.code} (${c.severity.name})').join(', '),
    );
    return codes;
  }

  /// Borra códigos DTC
  @override
  Future<bool> clearDTCs() async {
    _log.log(LogCategory.dtc, 'BT: sending clear DTCs command');
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
    _responseController.close();
  }
}
