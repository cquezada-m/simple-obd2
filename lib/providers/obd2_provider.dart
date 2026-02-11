import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../data/dtc_database.dart';
import '../models/dtc_code.dart';
import '../models/vehicle_parameter.dart';
import '../models/recommendation.dart';
import '../models/ai_diagnostic.dart';
import '../models/vehicle_info.dart';
import '../services/gemini_service.dart';
import '../services/secure_storage_service.dart';
import '../services/obd2_base_service.dart';
import '../services/obd2_service.dart';
import '../services/wifi_obd2_service.dart';
import '../services/app_logger.dart';
import '../theme/app_theme.dart';

enum ConnectionState { disconnected, connecting, connected }

enum ConnectionMode { bluetooth, wifi }

class Obd2Provider extends ChangeNotifier {
  final Obd2Service _btService = Obd2Service();
  final WifiObd2Service _wifiService = WifiObd2Service();
  Timer? _fastPollingTimer; // RPM, Speed – every 200ms
  Timer? _slowPollingTimer; // Temp, Load, Pressure, Fuel – every 5s

  static final _log = AppLogger.instance;

  ConnectionState connectionState = ConnectionState.disconnected;
  ConnectionMode? activeMode;
  List<BluetoothDevice> pairedDevices = [];
  List<DtcCode> dtcCodes = [];
  List<VehicleParameter> liveParams = [];
  String vin = '';
  String protocol = '';
  int ecuCount = 0;
  VehicleInfo vehicleInfo = const VehicleInfo();
  bool isClearing = false;
  bool useMockData = false;
  String? connectionError;

  // ── Gemini AI ────────────────────────────────────────────
  GeminiService? _geminiService;
  AiDiagnostic? aiDiagnostic;
  bool isLoadingAiDiagnostic = false;
  String? aiDiagnosticError;

  /// Configura Gemini guardando el API key en almacenamiento seguro.
  Future<void> configureGemini(
    String apiKey, {
    String model = 'gemini-2.0-flash',
  }) async {
    await SecureStorageService.saveGeminiApiKey(apiKey);
    _geminiService = GeminiService(apiKey: apiKey, model: model);
    notifyListeners();
  }

  /// Carga el API key desde almacenamiento seguro (llamar al iniciar la app).
  Future<void> loadGeminiApiKey({String model = 'gemini-2.0-flash'}) async {
    final apiKey = await SecureStorageService.getGeminiApiKey();
    if (apiKey != null && apiKey.isNotEmpty) {
      _geminiService = GeminiService(apiKey: apiKey, model: model);
      notifyListeners();
    }
  }

  /// Elimina el API key de Gemini del almacenamiento seguro.
  Future<void> removeGeminiApiKey() async {
    await SecureStorageService.deleteGeminiApiKey();
    _geminiService = null;
    aiDiagnostic = null;
    aiDiagnosticError = null;
    notifyListeners();
  }

  bool get isGeminiConfigured => _geminiService != null;

  /// Solicita un diagnóstico AI basado en el estado actual del vehículo.
  Future<void> requestAiDiagnostic() async {
    if (_geminiService == null) {
      aiDiagnosticError = 'Gemini no está configurado. Proporciona un API key.';
      notifyListeners();
      return;
    }
    if (!isConnected) {
      aiDiagnosticError = 'Conecta el vehículo primero.';
      notifyListeners();
      return;
    }

    isLoadingAiDiagnostic = true;
    aiDiagnosticError = null;
    notifyListeners();

    try {
      aiDiagnostic = await _geminiService!.getDiagnostic(
        parameters: liveParams,
        dtcCodes: dtcCodes,
        vin: vin,
        protocol: protocol,
        ecuCount: ecuCount,
      );
      _log.log(LogCategory.ai, 'Provider: AI diagnostic received');
    } on GeminiException catch (e) {
      aiDiagnosticError = e.message;
      _log.log(LogCategory.error, 'Provider: Gemini error', e.message);
    } catch (e) {
      aiDiagnosticError = 'Error al obtener diagnóstico AI: $e';
      _log.log(LogCategory.error, 'Provider: AI generic error', '$e');
    } finally {
      isLoadingAiDiagnostic = false;
      notifyListeners();
    }
  }

  // Configuración WiFi editable
  String wifiHost = WifiObd2Service.defaultHost;
  int wifiPort = WifiObd2Service.defaultPort;

  bool get isConnected => connectionState == ConnectionState.connected;
  bool get isConnecting => connectionState == ConnectionState.connecting;
  bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// Servicio activo según el modo de conexión
  Obd2BaseService? get _activeService => switch (activeMode) {
    ConnectionMode.bluetooth => _btService,
    ConnectionMode.wifi => _wifiService,
    null => null,
  };

  /// Llamado cuando el servicio WiFi detecta una desconexión inesperada.
  void _onServiceDisconnected() {
    _log.log(
      LogCategory.connection,
      'Provider: service disconnected unexpectedly',
    );
    _cancelPolling();
    connectionState = ConnectionState.disconnected;
    connectionError = 'Conexión perdida con el adaptador OBD2.';
    activeMode = null;
    notifyListeners();
  }

  Obd2Provider() {
    _initDefaultParams();
  }

  void _initDefaultParams() {
    liveParams = [
      VehicleParameter(
        label: 'rpm',
        value: '0',
        unit: 'rpm',
        icon: Icons.speed,
        percentage: 0,
        color: AppTheme.purple,
        bgColor: AppTheme.purpleLight,
      ),
      VehicleParameter(
        label: 'speed',
        value: '0',
        unit: 'km/h',
        icon: Icons.trending_up,
        percentage: 0,
        color: AppTheme.primary,
        bgColor: AppTheme.primaryLight,
      ),
      VehicleParameter(
        label: 'engine_temp',
        value: '0',
        unit: '°C',
        icon: Icons.thermostat,
        percentage: 0,
        color: AppTheme.error,
        bgColor: AppTheme.errorLight,
      ),
      VehicleParameter(
        label: 'engine_load',
        value: '0',
        unit: '%',
        icon: Icons.bolt,
        percentage: 0,
        color: AppTheme.yellow,
        bgColor: AppTheme.yellowLight,
      ),
      VehicleParameter(
        label: 'intake_pressure',
        value: '0',
        unit: 'kPa',
        icon: Icons.air,
        percentage: 0,
        color: AppTheme.cyan,
        bgColor: AppTheme.cyanLight,
      ),
      VehicleParameter(
        label: 'fuel_level',
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
        final didEnable = await _btService.enableBluetooth();
        if (!didEnable) {
          pairedDevices = [];
          notifyListeners();
          return;
        }
      }
      pairedDevices = await _btService.getPairedDevices();
    } catch (e) {
      pairedDevices = [];
      debugPrint('Error scanning devices: $e');
    }
    notifyListeners();
  }

  Future<void> connectBluetooth(BluetoothDevice device) async {
    _log.log(
      LogCategory.connection,
      'Provider: starting BT connection to ${device.name}',
    );
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
      _log.log(LogCategory.error, 'Provider: BT connection failed', '$e');
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
    _log.log(
      LogCategory.connection,
      'Provider: starting WiFi connection to $targetHost:$targetPort',
    );

    try {
      _wifiService.onDisconnected = _onServiceDisconnected;
      await _wifiService.connect(host: targetHost, port: targetPort);
      await _onConnected();
    } catch (e) {
      connectionState = ConnectionState.disconnected;
      connectionError =
          'No se pudo conectar via WiFi a $targetHost:$targetPort. '
          'Verifica que tu dispositivo este conectado a la red WiFi del adaptador OBD2.';
      activeMode = null;
      _log.log(LogCategory.error, 'Provider: WiFi connection failed', '$e');
    }
    notifyListeners();
  }

  // ── Post-conexión compartido ─────────────────────────────

  Future<void> _onConnected() async {
    connectionState = ConnectionState.connected;
    _log.log(
      LogCategory.connection,
      'Provider: connected, reading initial data',
    );

    final service = _activeService!;
    try {
      vin = await service.getVIN() ?? 'No disponible';
      protocol = await service.getProtocol() ?? 'Auto';

      // Detectar ECUs reales
      if (service is WifiObd2Service) {
        ecuCount = await service.detectECUCount();
      } else if (service is Obd2Service) {
        ecuCount = await service.detectECUCount();
      } else {
        ecuCount = 1;
      }
      if (ecuCount == 0) ecuCount = 1; // mínimo 1 si estamos conectados

      vehicleInfo = VehicleInfo.fromVIN(vin);
      dtcCodes = await service.getDTCs();
      _log.log(
        LogCategory.connection,
        'Provider: initial data read',
        'VIN: $vin, Protocolo: $protocol, ECUs: $ecuCount, DTCs: ${dtcCodes.length}, Manufacturer: ${vehicleInfo.manufacturer}',
      );
    } catch (e) {
      _log.log(LogCategory.error, 'Provider: error reading initial data', '$e');
      debugPrint('Error reading initial vehicle data: $e');
      vin = 'No disponible';
      protocol = 'Auto';
      ecuCount = 1;
      dtcCodes = [];
    }

    _startPolling();
  }

  // ── Mock ─────────────────────────────────────────────────

  Future<void> connectMock() async {
    _log.log(LogCategory.connection, 'Provider: starting MOCK mode');
    connectionState = ConnectionState.connecting;
    useMockData = true;
    connectionError = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    connectionState = ConnectionState.connected;
    vin = '1HGBH41JXMN109186';
    protocol = 'ISO 15765-4 (CAN 11/500)';
    ecuCount = 7;
    dtcCodes = [
      DtcCode(
        code: 'P0301',
        description: DtcDatabase.getDescriptionEs('P0301') ?? 'P0301',
        severity: DtcSeverity.critical,
      ),
      DtcCode(
        code: 'P0420',
        description: DtcDatabase.getDescriptionEs('P0420') ?? 'P0420',
        severity: DtcSeverity.warning,
      ),
      DtcCode(
        code: 'P0171',
        description: DtcDatabase.getDescriptionEs('P0171') ?? 'P0171',
        severity: DtcSeverity.warning,
      ),
    ];
    liveParams = [
      VehicleParameter(
        label: 'rpm',
        value: '850',
        unit: 'rpm',
        icon: Icons.speed,
        percentage: 14,
        color: AppTheme.purple,
        bgColor: AppTheme.purpleLight,
      ),
      VehicleParameter(
        label: 'speed',
        value: '0',
        unit: 'km/h',
        icon: Icons.trending_up,
        percentage: 0,
        color: AppTheme.primary,
        bgColor: AppTheme.primaryLight,
      ),
      VehicleParameter(
        label: 'engine_temp',
        value: '92',
        unit: '°C',
        icon: Icons.thermostat,
        percentage: 73,
        color: AppTheme.error,
        bgColor: AppTheme.errorLight,
      ),
      VehicleParameter(
        label: 'engine_load',
        value: '18',
        unit: '%',
        icon: Icons.bolt,
        percentage: 18,
        color: AppTheme.yellow,
        bgColor: AppTheme.yellowLight,
      ),
      VehicleParameter(
        label: 'intake_pressure',
        value: '29',
        unit: 'kPa',
        icon: Icons.air,
        percentage: 29,
        color: AppTheme.cyan,
        bgColor: AppTheme.cyanLight,
      ),
      VehicleParameter(
        label: 'fuel_level',
        value: '68',
        unit: '%',
        icon: Icons.local_gas_station,
        percentage: 68,
        color: AppTheme.success,
        bgColor: AppTheme.successLight,
      ),
    ];
    vehicleInfo = VehicleInfo.fromVIN(vin);
    _startMockPolling();
    _log.log(
      LogCategory.connection,
      'Provider: MOCK mode active',
      'VIN: $vin, DTCs: ${dtcCodes.length}, Manufacturer: ${vehicleInfo.manufacturer}',
    );
    notifyListeners();
  }

  // ── Desconexión ──────────────────────────────────────────

  void disconnect() {
    _log.log(
      LogCategory.connection,
      'Provider: disconnecting (mode: ${activeMode?.name ?? "mock"})',
    );
    _cancelPolling();
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
    vehicleInfo = const VehicleInfo();
    aiDiagnostic = null;
    aiDiagnosticError = null;
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

  // ── Polling (single sequential loop to avoid socket contention) ──

  void _cancelPolling() {
    _fastPollingTimer?.cancel();
    _slowPollingTimer?.cancel();
    _fastPollingTimer = null;
    _slowPollingTimer = null;
  }

  /// Contador de ciclos para intercalar parámetros lentos.
  int _pollCycle = 0;

  void _startPolling() {
    _cancelPolling();
    final service = _activeService;
    if (service == null) return;
    _pollCycle = 0;
    _log.log(
      LogCategory.parameter,
      'Polling: starting (sequential, 500ms cycle)',
    );

    // Un solo timer secuencial. Cada ciclo lee RPM+Speed.
    // Cada 10 ciclos (~5s) también lee temp, load, pressure, fuel.
    _fastPollingTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!isConnected || useMockData) return;
      _pollOneCycle(service);
    });

    // Lectura inicial de parámetros lentos
    _pollOneCycle(service, forceSlowRead: true);
  }

  bool _isPolling = false;

  Future<void> _pollOneCycle(
    Obd2BaseService service, {
    bool forceSlowRead = false,
  }) async {
    // Evitar que se acumulen ciclos si el anterior no terminó
    if (_isPolling) return;
    _isPolling = true;

    try {
      if (!isConnected || useMockData) return;

      // Leer RPM y Speed (siempre)
      final rpm = await service.getRPM();
      if (!isConnected) return;
      final speed = await service.getSpeed();
      if (!isConnected) return;

      // Actualizar solo si obtuvimos dato real (null = mantener último valor)
      liveParams = [
        rpm != null
            ? liveParams[0].copyWith(
                value: '$rpm',
                percentage: (rpm / 6000 * 100).clamp(0, 100),
              )
            : liveParams[0],
        speed != null
            ? liveParams[1].copyWith(
                value: '$speed',
                percentage: (speed / 240 * 100).clamp(0, 100),
              )
            : liveParams[1],
        liveParams[2],
        liveParams[3],
        liveParams[4],
        liveParams[5],
      ];
      notifyListeners();

      // Cada 10 ciclos (~5s) leer parámetros lentos
      _pollCycle++;
      if (forceSlowRead || _pollCycle >= 10) {
        _pollCycle = 0;
        await _pollSlowParams(service);
      }
    } catch (e) {
      _log.log(LogCategory.error, 'Polling error', '$e');
      debugPrint('Polling error: $e');
    } finally {
      _isPolling = false;
    }
  }

  Future<void> _pollSlowParams(Obd2BaseService service) async {
    if (!isConnected || useMockData) return;

    final temp = await service.getCoolantTemp();
    if (!isConnected) return;
    final load = await service.getEngineLoad();
    if (!isConnected) return;
    final pressure = await service.getIntakeManifoldPressure();
    if (!isConnected) return;
    final fuel = await service.getFuelLevel();
    if (!isConnected) return;

    // Solo actualizar si obtuvimos dato real
    liveParams = [
      liveParams[0],
      liveParams[1],
      temp != null
          ? liveParams[2].copyWith(
              value: '$temp',
              percentage: (temp / 125 * 100).clamp(0, 100),
            )
          : liveParams[2],
      load != null
          ? liveParams[3].copyWith(
              value: '$load',
              percentage: load.toDouble().clamp(0, 100),
            )
          : liveParams[3],
      pressure != null
          ? liveParams[4].copyWith(
              value: '$pressure',
              percentage: (pressure / 100 * 100).clamp(0, 100),
            )
          : liveParams[4],
      fuel != null
          ? liveParams[5].copyWith(
              value: '$fuel',
              percentage: fuel.toDouble().clamp(0, 100),
            )
          : liveParams[5],
    ];
    notifyListeners();
  }

  void _startMockPolling() {
    _cancelPolling();
    final rng = Random();

    // Fast tier mock: RPM every 200ms
    _fastPollingTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!isConnected) return;
      final rpm = 800 + rng.nextInt(200);
      liveParams = [
        liveParams[0].copyWith(value: '$rpm', percentage: (rpm / 6000 * 100)),
        liveParams[1].copyWith(value: '0', percentage: 0),
        liveParams[2],
        liveParams[3],
        liveParams[4],
        liveParams[5],
      ];
      notifyListeners();
    });

    // Slow tier mock: Temp, Load, Pressure every 5s
    _slowPollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isConnected) return;
      final temp = 88 + rng.nextInt(8);
      final load = 15 + rng.nextInt(10);
      final pressure = 25 + rng.nextInt(10);
      liveParams = [
        liveParams[0],
        liveParams[1],
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

  List<Recommendation> getRecommendations({String locale = 'es'}) {
    final recs = <Recommendation>[];
    final isEs = locale == 'es';

    for (final code in dtcCodes) {
      switch (code.code) {
        case 'P0301':
          recs.add(
            Recommendation(
              title: isEs
                  ? 'Revisar Sistema de Encendido - Cilindro 1'
                  : 'Check Ignition System - Cylinder 1',
              description: isEs
                  ? 'El fallo de encendido puede deberse a bujias desgastadas, bobinas defectuosas o problemas en los inyectores.'
                  : 'Misfire may be caused by worn spark plugs, faulty coils, or injector problems.',
              priority: RecommendationPriority.high,
              components: isEs
                  ? const [
                      'Bujias',
                      'Bobinas de encendido',
                      'Inyectores',
                      'Cables de alta tension',
                    ]
                  : const [
                      'Spark plugs',
                      'Ignition coils',
                      'Injectors',
                      'High tension cables',
                    ],
              estimatedCost: '\$50 - \$300',
            ),
          );
        case 'P0420':
          recs.add(
            Recommendation(
              title: isEs
                  ? 'Inspeccion del Catalizador'
                  : 'Catalyst Inspection',
              description: isEs
                  ? 'La eficiencia del catalizador esta por debajo del umbral. Puede requerir limpieza o reemplazo.'
                  : 'Catalyst efficiency is below threshold. May require cleaning or replacement.',
              priority: RecommendationPriority.medium,
              components: isEs
                  ? const [
                      'Catalizador',
                      'Sensores de oxigeno',
                      'Sistema de escape',
                    ]
                  : const ['Catalyst', 'Oxygen sensors', 'Exhaust system'],
              estimatedCost: '\$200 - \$1,500',
            ),
          );
        case 'P0171':
          recs.add(
            Recommendation(
              title: isEs
                  ? 'Verificar Sistema de Combustible'
                  : 'Check Fuel System',
              description: isEs
                  ? 'El sistema esta funcionando muy pobre. Revisar filtro de aire, sensores MAF y posibles fugas de vacio.'
                  : 'System is running too lean. Check air filter, MAF sensors, and possible vacuum leaks.',
              priority: RecommendationPriority.medium,
              components: isEs
                  ? const [
                      'Filtro de aire',
                      'Sensor MAF',
                      'Sistema de vacio',
                      'Inyectores',
                    ]
                  : const [
                      'Air filter',
                      'MAF sensor',
                      'Vacuum system',
                      'Injectors',
                    ],
              estimatedCost: '\$100 - \$400',
            ),
          );
      }
    }

    final temp = liveParams.firstWhere((p) => p.label == 'engine_temp');
    if (int.tryParse(temp.value) != null && int.parse(temp.value) > 100) {
      recs.add(
        Recommendation(
          title: isEs
              ? 'Temperatura del Motor Elevada'
              : 'High Engine Temperature',
          description: isEs
              ? 'El motor esta operando a temperatura alta. Verificar nivel de refrigerante y funcionamiento del termostato.'
              : 'Engine is operating at high temperature. Check coolant level and thermostat operation.',
          priority: RecommendationPriority.high,
          components: isEs
              ? const [
                  'Sistema de refrigeracion',
                  'Termostato',
                  'Bomba de agua',
                  'Radiador',
                ]
              : const [
                  'Cooling system',
                  'Thermostat',
                  'Water pump',
                  'Radiator',
                ],
          estimatedCost: '\$80 - \$500',
        ),
      );
    }

    if (recs.isEmpty) {
      recs.add(
        Recommendation(
          title: isEs ? 'Vehiculo en Buen Estado' : 'Vehicle in Good Condition',
          description: isEs
              ? 'No se detectaron problemas criticos. Se recomienda mantenimiento preventivo regular.'
              : 'No critical problems detected. Regular preventive maintenance is recommended.',
          priority: RecommendationPriority.low,
          components: isEs
              ? const ['Mantenimiento general']
              : const ['General maintenance'],
          estimatedCost: '\$50 - \$150',
        ),
      );
    }

    return recs;
  }

  @override
  void dispose() {
    _cancelPolling();
    _btService.dispose();
    _wifiService.dispose();
    super.dispose();
  }
}
