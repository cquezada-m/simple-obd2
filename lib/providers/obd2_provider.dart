import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/dtc_code.dart';
import '../models/vehicle_parameter.dart';
import '../models/recommendation.dart';
import '../services/obd2_base_service.dart';
import '../services/obd2_service.dart';
import '../services/wifi_obd2_service.dart';
import '../theme/app_theme.dart';

enum ConnectionState { disconnected, connecting, connected }

enum ConnectionMode { bluetooth, wifi }

class Obd2Provider extends ChangeNotifier {
  final Obd2Service _btService = Obd2Service();
  final WifiObd2Service _wifiService = WifiObd2Service();
  Timer? _pollingTimer;

  ConnectionState connectionState = ConnectionState.disconnected;
  ConnectionMode? activeMode;
  List<BluetoothDevice> pairedDevices = [];
  List<DtcCode> dtcCodes = [];
  List<VehicleParameter> liveParams = [];
  String vin = '';
  String protocol = '';
  int ecuCount = 0;
  bool isClearing = false;
  bool useMockData = false;
  String? connectionError;

  // Configuración WiFi editable
  String wifiHost = WifiObd2Service.defaultHost;
  int wifiPort = WifiObd2Service.defaultPort;

  bool get isConnected => connectionState == ConnectionState.connected;
  bool get isConnecting => connectionState == ConnectionState.connecting;
  bool get isIOS => Platform.isIOS;

  /// Servicio activo según el modo de conexión
  Obd2BaseService? get _activeService => switch (activeMode) {
    ConnectionMode.bluetooth => _btService,
    ConnectionMode.wifi => _wifiService,
    null => null,
  };

  Obd2Provider() {
    _initDefaultParams();
  }

  void _initDefaultParams() {
    liveParams = [
      VehicleParameter(
        label: 'RPM',
        value: '0',
        unit: 'rpm',
        icon: Icons.speed,
        percentage: 0,
        color: AppTheme.purple,
        bgColor: AppTheme.purpleLight,
      ),
      VehicleParameter(
        label: 'Velocidad',
        value: '0',
        unit: 'km/h',
        icon: Icons.trending_up,
        percentage: 0,
        color: AppTheme.primary,
        bgColor: AppTheme.primaryLight,
      ),
      VehicleParameter(
        label: 'Temp. Motor',
        value: '0',
        unit: '°C',
        icon: Icons.thermostat,
        percentage: 0,
        color: AppTheme.error,
        bgColor: AppTheme.errorLight,
      ),
      VehicleParameter(
        label: 'Carga Motor',
        value: '0',
        unit: '%',
        icon: Icons.bolt,
        percentage: 0,
        color: AppTheme.yellow,
        bgColor: AppTheme.yellowLight,
      ),
      VehicleParameter(
        label: 'Presion Admision',
        value: '0',
        unit: 'kPa',
        icon: Icons.air,
        percentage: 0,
        color: AppTheme.cyan,
        bgColor: AppTheme.cyanLight,
      ),
      VehicleParameter(
        label: 'Nivel Combustible',
        value: '0',
        unit: '%',
        icon: Icons.local_gas_station,
        percentage: 0,
        color: AppTheme.success,
        bgColor: AppTheme.successLight,
      ),
    ];
  }

  // ── Bluetooth (Android) ──────────────────────────────────

  Future<void> scanDevices() async {
    try {
      final enabled = await _btService.isBluetoothEnabled();
      if (!enabled) {
        await _btService.enableBluetooth();
      }
      pairedDevices = await _btService.getPairedDevices();
    } catch (e) {
      pairedDevices = [];
    }
    notifyListeners();
  }

  Future<void> connectBluetooth(BluetoothDevice device) async {
    connectionState = ConnectionState.connecting;
    activeMode = ConnectionMode.bluetooth;
    connectionError = null;
    notifyListeners();

    try {
      await _btService.connect(device);
      await _onConnected();
    } catch (e) {
      connectionState = ConnectionState.disconnected;
      connectionError = 'No se pudo conectar via Bluetooth: $e';
      activeMode = null;
    }
    notifyListeners();
  }

  // ── WiFi (iOS / universal) ───────────────────────────────

  Future<void> connectWifi({String? host, int? port}) async {
    connectionState = ConnectionState.connecting;
    activeMode = ConnectionMode.wifi;
    connectionError = null;
    notifyListeners();

    final targetHost = host ?? wifiHost;
    final targetPort = port ?? wifiPort;

    try {
      await _wifiService.connect(host: targetHost, port: targetPort);
      await _onConnected();
    } catch (e) {
      connectionState = ConnectionState.disconnected;
      connectionError =
          'No se pudo conectar via WiFi a $targetHost:$targetPort. '
          'Verifica que tu dispositivo este conectado a la red WiFi del adaptador OBD2.';
      activeMode = null;
    }
    notifyListeners();
  }

  // ── Post-conexión compartido ─────────────────────────────

  Future<void> _onConnected() async {
    connectionState = ConnectionState.connected;

    final service = _activeService!;
    vin = await service.getVIN() ?? 'No disponible';
    protocol = await service.getProtocol() ?? 'Auto';
    ecuCount = 1;
    dtcCodes = await service.getDTCs();

    _startPolling();
  }

  // ── Mock ─────────────────────────────────────────────────

  Future<void> connectMock() async {
    connectionState = ConnectionState.connecting;
    useMockData = true;
    connectionError = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    connectionState = ConnectionState.connected;
    vin = '1HGBH41JXMN109186';
    protocol = 'ISO 15765-4 (CAN 11/500)';
    ecuCount = 7;
    dtcCodes = const [
      DtcCode(
        code: 'P0301',
        description: 'Fallo de encendido en cilindro 1',
        severity: DtcSeverity.critical,
      ),
      DtcCode(
        code: 'P0420',
        description: 'Catalizador sistema bajo eficiencia',
        severity: DtcSeverity.warning,
      ),
      DtcCode(
        code: 'P0171',
        description: 'Sistema demasiado pobre (Banco 1)',
        severity: DtcSeverity.warning,
      ),
    ];
    liveParams = [
      VehicleParameter(
        label: 'RPM',
        value: '850',
        unit: 'rpm',
        icon: Icons.speed,
        percentage: 14,
        color: AppTheme.purple,
        bgColor: AppTheme.purpleLight,
      ),
      VehicleParameter(
        label: 'Velocidad',
        value: '0',
        unit: 'km/h',
        icon: Icons.trending_up,
        percentage: 0,
        color: AppTheme.primary,
        bgColor: AppTheme.primaryLight,
      ),
      VehicleParameter(
        label: 'Temp. Motor',
        value: '92',
        unit: '°C',
        icon: Icons.thermostat,
        percentage: 73,
        color: AppTheme.error,
        bgColor: AppTheme.errorLight,
      ),
      VehicleParameter(
        label: 'Carga Motor',
        value: '18',
        unit: '%',
        icon: Icons.bolt,
        percentage: 18,
        color: AppTheme.yellow,
        bgColor: AppTheme.yellowLight,
      ),
      VehicleParameter(
        label: 'Presion Admision',
        value: '29',
        unit: 'kPa',
        icon: Icons.air,
        percentage: 29,
        color: AppTheme.cyan,
        bgColor: AppTheme.cyanLight,
      ),
      VehicleParameter(
        label: 'Nivel Combustible',
        value: '68',
        unit: '%',
        icon: Icons.local_gas_station,
        percentage: 68,
        color: AppTheme.success,
        bgColor: AppTheme.successLight,
      ),
    ];
    _startMockPolling();
    notifyListeners();
  }

  // ── Desconexión ──────────────────────────────────────────

  void disconnect() {
    _pollingTimer?.cancel();
    if (!useMockData) {
      _activeService?.disconnect();
    }
    connectionState = ConnectionState.disconnected;
    activeMode = null;
    useMockData = false;
    connectionError = null;
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
      await _activeService?.clearDTCs();
    }

    dtcCodes = [];
    isClearing = false;
    notifyListeners();
  }

  // ── Polling ────────────────────────────────────────────────

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!isConnected || useMockData) return;
      final service = _activeService;
      if (service == null) return;

      final rpm = await service.getRPM();
      final speed = await service.getSpeed();
      final temp = await service.getCoolantTemp();
      final load = await service.getEngineLoad();
      final pressure = await service.getIntakeManifoldPressure();
      final fuel = await service.getFuelLevel();

      liveParams = [
        liveParams[0].copyWith(
          value: '${rpm ?? 0}',
          percentage: ((rpm ?? 0) / 6000 * 100).clamp(0, 100),
        ),
        liveParams[1].copyWith(
          value: '${speed ?? 0}',
          percentage: ((speed ?? 0) / 240 * 100).clamp(0, 100),
        ),
        liveParams[2].copyWith(
          value: '${temp ?? 0}',
          percentage: ((temp ?? 0) / 125 * 100).clamp(0, 100),
        ),
        liveParams[3].copyWith(
          value: '${load ?? 0}',
          percentage: (load ?? 0).toDouble().clamp(0, 100),
        ),
        liveParams[4].copyWith(
          value: '${pressure ?? 0}',
          percentage: ((pressure ?? 0) / 100 * 100).clamp(0, 100),
        ),
        liveParams[5].copyWith(
          value: '${fuel ?? 0}',
          percentage: (fuel ?? 0).toDouble().clamp(0, 100),
        ),
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
        liveParams[4].copyWith(
          value: '$pressure',
          percentage: pressure.toDouble(),
        ),
        liveParams[5].copyWith(
          value: liveParams[5].value,
          percentage: liveParams[5].percentage,
        ),
      ];
      notifyListeners();
    });
  }

  // ── Recomendaciones AI ─────────────────────────────────────

  List<Recommendation> getRecommendations() {
    final recs = <Recommendation>[];

    for (final code in dtcCodes) {
      switch (code.code) {
        case 'P0301':
          recs.add(
            const Recommendation(
              title: 'Revisar Sistema de Encendido - Cilindro 1',
              description:
                  'El fallo de encendido puede deberse a bujias desgastadas, bobinas defectuosas o problemas en los inyectores.',
              priority: RecommendationPriority.high,
              components: [
                'Bujias',
                'Bobinas de encendido',
                'Inyectores',
                'Cables de alta tension',
              ],
              estimatedCost: '\$50 - \$300',
            ),
          );
        case 'P0420':
          recs.add(
            const Recommendation(
              title: 'Inspeccion del Catalizador',
              description:
                  'La eficiencia del catalizador esta por debajo del umbral. Puede requerir limpieza o reemplazo.',
              priority: RecommendationPriority.medium,
              components: [
                'Catalizador',
                'Sensores de oxigeno',
                'Sistema de escape',
              ],
              estimatedCost: '\$200 - \$1,500',
            ),
          );
        case 'P0171':
          recs.add(
            const Recommendation(
              title: 'Verificar Sistema de Combustible',
              description:
                  'El sistema esta funcionando muy pobre. Revisar filtro de aire, sensores MAF y posibles fugas de vacio.',
              priority: RecommendationPriority.medium,
              components: [
                'Filtro de aire',
                'Sensor MAF',
                'Sistema de vacio',
                'Inyectores',
              ],
              estimatedCost: '\$100 - \$400',
            ),
          );
      }
    }

    final temp = liveParams.firstWhere((p) => p.label == 'Temp. Motor');
    if (int.tryParse(temp.value) != null && int.parse(temp.value) > 100) {
      recs.add(
        const Recommendation(
          title: 'Temperatura del Motor Elevada',
          description:
              'El motor esta operando a temperatura alta. Verificar nivel de refrigerante y funcionamiento del termostato.',
          priority: RecommendationPriority.high,
          components: [
            'Sistema de refrigeracion',
            'Termostato',
            'Bomba de agua',
            'Radiador',
          ],
          estimatedCost: '\$80 - \$500',
        ),
      );
    }

    if (recs.isEmpty) {
      recs.add(
        const Recommendation(
          title: 'Vehiculo en Buen Estado',
          description:
              'No se detectaron problemas criticos. Se recomienda mantenimiento preventivo regular.',
          priority: RecommendationPriority.low,
          components: ['Mantenimiento general'],
          estimatedCost: '\$50 - \$150',
        ),
      );
    }

    return recs;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _btService.dispose();
    _wifiService.dispose();
    super.dispose();
  }
}
