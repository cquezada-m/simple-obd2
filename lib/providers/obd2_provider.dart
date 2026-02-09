import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/dtc_code.dart';
import '../models/vehicle_parameter.dart';
import '../models/recommendation.dart';
import '../services/obd2_service.dart';
import '../theme/app_theme.dart';

enum ConnectionState { disconnected, connecting, connected }

class Obd2Provider extends ChangeNotifier {
  final Obd2Service _service = Obd2Service();
  Timer? _pollingTimer;

  ConnectionState connectionState = ConnectionState.disconnected;
  List<BluetoothDevice> pairedDevices = [];
  List<DtcCode> dtcCodes = [];
  List<VehicleParameter> liveParams = [];
  String vin = '';
  String protocol = '';
  int ecuCount = 0;
  bool isClearing = false;
  bool useMockData = false;

  bool get isConnected => connectionState == ConnectionState.connected;
  bool get isConnecting => connectionState == ConnectionState.connecting;

  Obd2Provider() {
    _initDefaultParams();
  }

  void _initDefaultParams() {
    liveParams = [
      VehicleParameter(
        label: 'RPM', value: '0', unit: 'rpm',
        icon: Icons.speed, percentage: 0,
        color: AppTheme.purple, bgColor: AppTheme.purpleLight,
      ),
      VehicleParameter(
        label: 'Velocidad', value: '0', unit: 'km/h',
        icon: Icons.trending_up, percentage: 0,
        color: AppTheme.primary, bgColor: AppTheme.primaryLight,
      ),
      VehicleParameter(
        label: 'Temp. Motor', value: '0', unit: '°C',
        icon: Icons.thermostat, percentage: 0,
        color: AppTheme.error, bgColor: AppTheme.errorLight,
      ),
      VehicleParameter(
        label: 'Carga Motor', value: '0', unit: '%',
        icon: Icons.bolt, percentage: 0,
        color: AppTheme.yellow, bgColor: AppTheme.yellowLight,
      ),
      VehicleParameter(
        label: 'Presión Admisión', value: '0', unit: 'kPa',
        icon: Icons.air, percentage: 0,
        color: AppTheme.cyan, bgColor: AppTheme.cyanLight,
      ),
      VehicleParameter(
        label: 'Nivel Combustible', value: '0', unit: '%',
        icon: Icons.local_gas_station, percentage: 0,
        color: AppTheme.success, bgColor: AppTheme.successLight,
      ),
    ];
  }

  Future<void> scanDevices() async {
    final enabled = await _service.isBluetoothEnabled();
    if (!enabled) {
      await _service.enableBluetooth();
    }
    pairedDevices = await _service.getPairedDevices();
    notifyListeners();
  }

  Future<void> connect(BluetoothDevice device) async {
    connectionState = ConnectionState.connecting;
    notifyListeners();

    try {
      await _service.connect(device);
      connectionState = ConnectionState.connected;

      // Leer info del vehículo
      vin = await _service.getVIN() ?? 'No disponible';
      protocol = await _service.getProtocol() ?? 'Auto';
      ecuCount = 1; // Se actualiza con la respuesta real

      // Leer DTCs
      dtcCodes = await _service.getDTCs();

      // Iniciar polling de parámetros en vivo
      _startPolling();
    } catch (e) {
      connectionState = ConnectionState.disconnected;
    }
    notifyListeners();
  }

  Future<void> connectMock() async {
    connectionState = ConnectionState.connecting;
    useMockData = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    connectionState = ConnectionState.connected;
    vin = '1HGBH41JXMN109186';
    protocol = 'ISO 15765-4 (CAN 11/500)';
    ecuCount = 7;
    dtcCodes = const [
      DtcCode(code: 'P0301', description: 'Fallo de encendido en cilindro 1', severity: DtcSeverity.critical),
      DtcCode(code: 'P0420', description: 'Catalizador sistema bajo eficiencia', severity: DtcSeverity.warning),
      DtcCode(code: 'P0171', description: 'Sistema demasiado pobre (Banco 1)', severity: DtcSeverity.warning),
    ];

    liveParams = [
      VehicleParameter(label: 'RPM', value: '850', unit: 'rpm', icon: Icons.speed, percentage: 14, color: AppTheme.purple, bgColor: AppTheme.purpleLight),
      VehicleParameter(label: 'Velocidad', value: '0', unit: 'km/h', icon: Icons.trending_up, percentage: 0, color: AppTheme.primary, bgColor: AppTheme.primaryLight),
      VehicleParameter(label: 'Temp. Motor', value: '92', unit: '°C', icon: Icons.thermostat, percentage: 73, color: AppTheme.error, bgColor: AppTheme.errorLight),
      VehicleParameter(label: 'Carga Motor', value: '18', unit: '%', icon: Icons.bolt, percentage: 18, color: AppTheme.yellow, bgColor: AppTheme.yellowLight),
      VehicleParameter(label: 'Presión Admisión', value: '29', unit: 'kPa', icon: Icons.air, percentage: 29, color: AppTheme.cyan, bgColor: AppTheme.cyanLight),
      VehicleParameter(label: 'Nivel Combustible', value: '68', unit: '%', icon: Icons.local_gas_station, percentage: 68, color: AppTheme.success, bgColor: AppTheme.successLight),
    ];

    _startMockPolling();
    notifyListeners();
  }

  void disconnect() {
    _pollingTimer?.cancel();
    if (!useMockData) {
      _service.disconnect();
    }
    connectionState = ConnectionState.disconnected;
    useMockData = false;
    dtcCodes = [];
    vin = '';
    protocol = '';
    ecuCount = 0;
    _initDefaultParams();
    notifyListeners();
  }

  Future<void> clearCodes() async {
    isClearing = true;
    notifyListeners();

    if (useMockData) {
      await Future.delayed(const Duration(seconds: 2));
    } else {
      await _service.clearDTCs();
    }

    dtcCodes = [];
    isClearing = false;
    notifyListeners();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!isConnected || useMockData) return;

      final rpm = await _service.getRPM();
      final speed = await _service.getSpeed();
      final temp = await _service.getCoolantTemp();
      final load = await _service.getEngineLoad();
      final pressure = await _service.getIntakeManifoldPressure();
      final fuel = await _service.getFuelLevel();

      liveParams = [
        liveParams[0].copyWith(value: '${rpm ?? 0}', percentage: ((rpm ?? 0) / 6000 * 100).clamp(0, 100)),
        liveParams[1].copyWith(value: '${speed ?? 0}', percentage: ((speed ?? 0) / 240 * 100).clamp(0, 100)),
        liveParams[2].copyWith(value: '${temp ?? 0}', percentage: ((temp ?? 0) / 125 * 100).clamp(0, 100)),
        liveParams[3].copyWith(value: '${load ?? 0}', percentage: (load ?? 0).toDouble().clamp(0, 100)),
        liveParams[4].copyWith(value: '${pressure ?? 0}', percentage: ((pressure ?? 0) / 100 * 100).clamp(0, 100)),
        liveParams[5].copyWith(value: '${fuel ?? 0}', percentage: (fuel ?? 0).toDouble().clamp(0, 100)),
      ];
      notifyListeners();
    });
  }

  void _startMockPolling() {
    final rng = Random();
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!isConnected) return;

      final rpm = 800 + rng.nextInt(200);
      final temp = 88 + rng.nextInt(8);
      final load = 15 + rng.nextInt(10);
      final pressure = 25 + rng.nextInt(10);

      liveParams = [
        liveParams[0].copyWith(value: '$rpm', percentage: (rpm / 6000 * 100)),
        liveParams[1].copyWith(value: '0', percentage: 0),
        liveParams[2].copyWith(value: '$temp', percentage: (temp / 125 * 100)),
        liveParams[3].copyWith(value: '$load', percentage: load.toDouble()),
        liveParams[4].copyWith(value: '$pressure', percentage: pressure.toDouble()),
        liveParams[5].copyWith(value: liveParams[5].value, percentage: liveParams[5].percentage),
      ];
      notifyListeners();
    });
  }

  List<Recommendation> getRecommendations() {
    final recs = <Recommendation>[];

    for (final code in dtcCodes) {
      switch (code.code) {
        case 'P0301':
          recs.add(const Recommendation(
            title: 'Revisar Sistema de Encendido - Cilindro 1',
            description: 'El fallo de encendido puede deberse a bujías desgastadas, bobinas defectuosas o problemas en los inyectores.',
            priority: RecommendationPriority.high,
            components: ['Bujías', 'Bobinas de encendido', 'Inyectores', 'Cables de alta tensión'],
            estimatedCost: '\$50 - \$300',
          ));
          break;
        case 'P0420':
          recs.add(const Recommendation(
            title: 'Inspección del Catalizador',
            description: 'La eficiencia del catalizador está por debajo del umbral. Puede requerir limpieza o reemplazo.',
            priority: RecommendationPriority.medium,
            components: ['Catalizador', 'Sensores de oxígeno', 'Sistema de escape'],
            estimatedCost: '\$200 - \$1,500',
          ));
          break;
        case 'P0171':
          recs.add(const Recommendation(
            title: 'Verificar Sistema de Combustible',
            description: 'El sistema está funcionando muy pobre. Revisar filtro de aire, sensores MAF y posibles fugas de vacío.',
            priority: RecommendationPriority.medium,
            components: ['Filtro de aire', 'Sensor MAF', 'Sistema de vacío', 'Inyectores'],
            estimatedCost: '\$100 - \$400',
          ));
          break;
      }
    }

    // Analizar parámetros
    final temp = liveParams.firstWhere((p) => p.label == 'Temp. Motor');
    if (int.tryParse(temp.value) != null && int.parse(temp.value) > 100) {
      recs.add(const Recommendation(
        title: 'Temperatura del Motor Elevada',
        description: 'El motor está operando a temperatura alta. Verificar nivel de refrigerante y funcionamiento del termostato.',
        priority: RecommendationPriority.high,
        components: ['Sistema de refrigeración', 'Termostato', 'Bomba de agua', 'Radiador'],
        estimatedCost: '\$80 - \$500',
      ));
    }

    if (recs.isEmpty) {
      recs.add(const Recommendation(
        title: 'Vehículo en Buen Estado',
        description: 'No se detectaron problemas críticos. Se recomienda mantenimiento preventivo regular.',
        priority: RecommendationPriority.low,
        components: ['Mantenimiento general'],
        estimatedCost: '\$50 - \$150',
      ));
    }

    return recs;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _service.dispose();
    super.dispose();
  }
}
