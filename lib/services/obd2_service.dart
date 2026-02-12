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
  StreamSubscription<Uint8List>? _inputSubscription;
  String _buffer = '';

  Stream<String> get responseStream => _responseController.stream;
  @override
  bool get isConnected => _connection != null && _connection!.isConnected;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  /// true si el protocolo detectado es CAN (ISO 15765-4).
  bool _isCan = false;

  /// Dirección CAN de la ECU primaria del motor.
  String? _primaryEcuAddress;

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

    // Cancel any previous subscription to avoid orphaned listeners on reconnect
    await _inputSubscription?.cancel();
    _inputSubscription = _connection!.input?.listen(
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

    // Forzar detección de protocolo
    await _sendCommand('0100');

    // Detectar protocolo y configurar filtrado CAN
    await _detectAndConfigureProtocol();

    _log.log(LogCategory.connection, 'BT: ELM327 initialized (CAN=$_isCan)');
  }

  /// Detecta protocolo y configura filtrado CAN (misma lógica que WiFi).
  Future<void> _detectAndConfigureProtocol() async {
    final protocolRaw = await _sendCommand('ATDPN');
    if (protocolRaw == null || protocolRaw.isEmpty) {
      _isCan = false;
      return;
    }

    var cleaned = protocolRaw.trim().toUpperCase();
    if (cleaned.startsWith('A')) cleaned = cleaned.substring(1);
    final protocolNum = int.tryParse(cleaned, radix: 16) ?? 0;
    _isCan = protocolNum >= 6;
    _log.log(
      LogCategory.connection,
      'BT Protocol: $protocolRaw (num=$protocolNum, CAN=$_isCan)',
    );

    if (!_isCan) return;

    await _sendCommand('ATH1');
    final response = await _sendCommand('0100');
    await _sendCommand('ATH0');

    if (response == null || response.isEmpty) return;

    _primaryEcuAddress = WifiObd2Service.findPrimaryEcuAddress(response);

    if (_primaryEcuAddress != null) {
      final craResult = await _sendCommand('ATCRA$_primaryEcuAddress');
      if (craResult != null &&
          !craResult.contains('?') &&
          !craResult.toUpperCase().contains('ERROR')) {
        _log.log(
          LogCategory.connection,
          'BT CAN filter: ATCRA$_primaryEcuAddress',
        );
      } else {
        _log.log(
          LogCategory.connection,
          'BT CAN filter ATCRA not supported, using software filtering',
        );
      }
    }
  }

  /// Construye comando PID con sufijo '1' en CAN para single-response.
  String _pidCommand(String pid) {
    if (_isCan && _primaryEcuAddress != null) {
      return '${pid}1';
    }
    return pid;
  }

  @override
  Future<void> disconnect() async {
    _log.log(LogCategory.connection, 'BT: disconnecting');
    _isCan = false;
    _primaryEcuAddress = null;
    await _inputSubscription?.cancel();
    _inputSubscription = null;
    try {
      await _connection?.close();
    } catch (_) {}
    _connection = null;
    _connectedDevice = null;
  }

  Future<String?> _sendCommand(String command) async {
    if (!isConnected) return null;

    // Limpiar buffer de datos residuales de comandos anteriores
    _buffer = '';

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
    if (response.isEmpty) return null;

    // Sanitizar: eliminar líneas de error/ruido de ECUs secundarias
    final sanitized = WifiObd2Service.sanitizeResponse(response);
    return sanitized.isEmpty ? null : sanitized;
  }

  /// Lee RPM: PID 010C
  @override
  Future<int?> getRPM() async {
    final response = await _sendCommand(_pidCommand('010C'));
    if (WifiObd2Service.isErrorResponse(response)) return null;
    final raw = Obd2BaseService.parseTwoBytes(response, expectedHeader: '410C');
    final rpm = raw != null ? raw ~/ 4 : null;
    _log.log(LogCategory.parse, 'RPM: raw=$raw, value=$rpm');
    return rpm;
  }

  /// Lee velocidad: PID 010D
  @override
  Future<int?> getSpeed() async {
    final response = await _sendCommand(_pidCommand('010D'));
    if (WifiObd2Service.isErrorResponse(response)) return null;
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
    final response = await _sendCommand(_pidCommand('0105'));
    if (WifiObd2Service.isErrorResponse(response)) return null;
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4105');
    final temp = raw != null ? raw - 40 : null;
    _log.log(LogCategory.parse, 'Coolant temp: raw=$raw, value=$temp°C');
    return temp;
  }

  /// Lee carga del motor: PID 0104
  @override
  Future<int?> getEngineLoad() async {
    final response = await _sendCommand(_pidCommand('0104'));
    if (WifiObd2Service.isErrorResponse(response)) return null;
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '4104');
    final load = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Engine load: raw=$raw, value=$load%');
    return load;
  }

  /// Lee presión del colector de admisión: PID 010B
  @override
  Future<int?> getIntakeManifoldPressure() async {
    final response = await _sendCommand(_pidCommand('010B'));
    if (WifiObd2Service.isErrorResponse(response)) return null;
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
    final response = await _sendCommand(_pidCommand('012F'));
    if (WifiObd2Service.isErrorResponse(response)) return null;
    final raw = Obd2BaseService.parseOneByte(response, expectedHeader: '412F');
    final fuel = raw != null ? (raw * 100) ~/ 255 : null;
    _log.log(LogCategory.parse, 'Fuel level: raw=$raw, value=$fuel%');
    return fuel;
  }

  /// Lee VIN: PID 0902
  @override
  Future<String?> getVIN() async {
    final response = await _sendCommand('0902');
    if (response == null ||
        response.isEmpty ||
        WifiObd2Service.isErrorResponse(response)) {
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

  /// Detecta el número de ECUs respondiendo al PID 0100.
  Future<int> detectECUCount() async {
    // Desactivar filtro CAN temporalmente para ver todas las ECUs.
    // ATAR = Automatic Receive — restaura el filtrado automático del ELM327.
    if (_isCan && _primaryEcuAddress != null) {
      await _sendCommand('ATAR');
    }

    await _sendCommand('ATH1');
    final response = await _sendCommand('0100');
    await _sendCommand('ATH0');

    // Restaurar filtro CAN
    if (_isCan && _primaryEcuAddress != null) {
      await _sendCommand('ATCRA$_primaryEcuAddress');
    }

    if (response == null ||
        response.isEmpty ||
        WifiObd2Service.isErrorResponse(response)) {
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
              !WifiObd2Service.isErrorLine(l),
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

  /// Lee códigos DTC
  @override
  Future<List<DtcCode>> getDTCs() async {
    final response = await _sendCommand('03');
    if (response == null ||
        response.isEmpty ||
        WifiObd2Service.isErrorResponse(response)) {
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
  Future<String?> sendRawCommand(String command) => _sendCommand(command);

  @override
  Future<List<int>?> queryPid(String pid) async {
    final response = await _sendCommand(_pidCommand(pid));
    if (WifiObd2Service.isErrorResponse(response)) return null;
    final pidHex = pid.length >= 4 ? pid.substring(2) : pid;
    final header = '41$pidHex'.toUpperCase();
    final data = Obd2BaseService.extractResponseBytes(response, header);
    return data;
  }

  @override
  void dispose() {
    _inputSubscription?.cancel();
    _inputSubscription = null;
    disconnect();
    _responseController.close();
  }
}
