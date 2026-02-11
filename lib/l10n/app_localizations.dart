import 'package:flutter/material.dart';

enum AppLanguage { es, en }

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get locale => language == AppLanguage.es ? 'es' : 'en';

  // ── App General ──
  String get appTitle => _t('OBD2 Scanner', 'OBD2 Scanner');
  String get appSubtitle => _t('Diagnóstico de Vehículo', 'Vehicle Diagnostics');

  // ── Connection ──
  String get connected => _t('Conectado', 'Connected');
  String get connecting => _t('Conectando...', 'Connecting...');
  String get disconnected => _t('Desconectado', 'Disconnected');
  String get connect => _t('Conectar', 'Connect');
  String get disconnect => _t('Desconectar', 'Disconnect');
  String get obd2Device => _t('Dispositivo OBD2', 'OBD2 Device');
  String get connectionHint =>
      _t('Asegúrate de que tu dispositivo OBD2 esté conectado al vehículo y encendido.',
         'Make sure your OBD2 device is connected to the vehicle and turned on.');
  String get searchingDevices => _t('Buscando dispositivos...', 'Searching devices...');
  String get connectDevice => _t('Conectar Dispositivo', 'Connect Device');
  String get connectViaWifi => _t('Conecta vía WiFi al adaptador OBD2', 'Connect via WiFi to OBD2 adapter');
  String get selectConnectionMethod => _t('Selecciona el método de conexión', 'Select connection method');
  String get useDemoData => _t('Usar datos de demostración', 'Use demo data');
  String get connectViaWifiBtn => _t('Conectar vía WiFi', 'Connect via WiFi');
  String get ipAddress => _t('Dirección IP', 'IP Address');
  String get port => _t('Puerto', 'Port');
  String get howToConnectWifi => _t('Cómo conectar vía WiFi', 'How to connect via WiFi');
  String get wifiStep1 => _t('Conecta el adaptador OBD2 al puerto del vehículo', 'Connect the OBD2 adapter to the vehicle port');
  String get wifiStep2 => _t('Ve a Ajustes > WiFi en tu dispositivo', 'Go to Settings > WiFi on your device');
  String get wifiStep3 => _t('Conéctate a la red del adaptador', 'Connect to the adapter network');
  String get wifiStep4 => _t('Regresa aquí y presiona Conectar', 'Come back here and press Connect');
  String get noDevicesFound => _t('No se encontraron dispositivos emparejados', 'No paired devices found');
  String get unknownDevice => _t('Dispositivo desconocido', 'Unknown device');
  String btError(String e) => _t('No se pudo conectar via Bluetooth: $e', 'Could not connect via Bluetooth: $e');
  String wifiError(String host, int port) =>
      _t('No se pudo conectar via WiFi a $host:$port. Verifica que tu dispositivo este conectado a la red WiFi del adaptador OBD2.',
         'Could not connect via WiFi to $host:$port. Verify your device is connected to the OBD2 adapter WiFi network.');
  String get notAvailable => _t('No disponible', 'Not available');

  // ── Vehicle Info ──
  String get vehicleInfo => _t('Información del Vehículo', 'Vehicle Information');
  String get obd2SystemData => _t('Datos del sistema OBD2', 'OBD2 system data');
  String get protocol => _t('Protocolo', 'Protocol');
  String get ecusDetected => _t('ECUs Detectadas', 'ECUs Detected');

  // ── Tabs ──
  String get diagnosticTab => _t('Diagnóstico', 'Diagnostics');
  String get liveTab => _t('En Vivo', 'Live');

  // ── Diagnostic Codes ──
  String get diagnosticCodes => _t('Códigos de Diagnóstico', 'Diagnostic Codes');
  String get clearing => _t('Borrando...', 'Clearing...');
  String get clearCodes => _t('Borrar códigos', 'Clear codes');
  String get noErrorCodes => _t('Sin códigos de error', 'No error codes');
  String get systemOk => _t('El sistema está funcionando correctamente', 'System is working correctly');
  String get severityCritical => _t('Crítico', 'Critical');
  String get severityWarning => _t('Advertencia', 'Warning');
  String get severityInfo => _t('Info', 'Info');

  // ── Live Parameters ──
  String get liveParameters => _t('Parámetros en Tiempo Real', 'Real-Time Parameters');
  String get live => _t('Live', 'Live');

  // ── Parameter Labels ──
  String get paramRpm => _t('RPM', 'RPM');
  String get paramSpeed => _t('Velocidad', 'Speed');
  String get paramEngineTemp => _t('Temp. Motor', 'Engine Temp.');
  String get paramEngineLoad => _t('Carga Motor', 'Engine Load');
  String get paramIntakePressure => _t('Presion Admision', 'Intake Pressure');
  String get paramFuelLevel => _t('Nivel Combustible', 'Fuel Level');

  // ── AI Recommendations ──
  String get aiAnalysis => _t('Análisis AI', 'AI Analysis');
  String get aiRecommendations => _t('Recomendaciones basadas en diagnóstico', 'Recommendations based on diagnostics');
  String get estimatedCost => _t('Costo estimado', 'Estimated cost');
  String get aiDisclaimer => _t('Análisis generado por IA. ', 'AI-generated analysis. ');
  String get aiDisclaimerDetail =>
      _t('Consulta con un mecánico certificado antes de realizar reparaciones.',
         'Consult a certified mechanic before making repairs.');
  String get priorityHigh => _t('Alta', 'High');
  String get priorityMedium => _t('Media', 'Medium');
  String get priorityLow => _t('Baja', 'Low');

  // ── Disconnected State ──
  String get connectObd2 => _t('Conecta tu dispositivo OBD2', 'Connect your OBD2 device');
  String get connectObd2Hint =>
      _t('Conecta el escáner al puerto de diagnóstico de tu vehículo y presiona conectar',
         'Connect the scanner to your vehicle diagnostic port and press connect');

  // ── Recommendations (provider) ──
  String get recIgnitionTitle => _t('Revisar Sistema de Encendido - Cilindro 1', 'Check Ignition System - Cylinder 1');
  String get recIgnitionDesc =>
      _t('El fallo de encendido puede deberse a bujias desgastadas, bobinas defectuosas o problemas en los inyectores.',
         'Misfire may be caused by worn spark plugs, faulty coils, or injector problems.');
  String get recCatalystTitle => _t('Inspeccion del Catalizador', 'Catalyst Inspection');
  String get recCatalystDesc =>
      _t('La eficiencia del catalizador esta por debajo del umbral. Puede requerir limpieza o reemplazo.',
         'Catalyst efficiency is below threshold. May require cleaning or replacement.');
  String get recFuelTitle => _t('Verificar Sistema de Combustible', 'Check Fuel System');
  String get recFuelDesc =>
      _t('El sistema esta funcionando muy pobre. Revisar filtro de aire, sensores MAF y posibles fugas de vacio.',
         'System is running too lean. Check air filter, MAF sensors, and possible vacuum leaks.');
  String get recTempTitle => _t('Temperatura del Motor Elevada', 'High Engine Temperature');
  String get recTempDesc =>
      _t('El motor esta operando a temperatura alta. Verificar nivel de refrigerante y funcionamiento del termostato.',
         'Engine is operating at high temperature. Check coolant level and thermostat operation.');
  String get recGoodTitle => _t('Vehiculo en Buen Estado', 'Vehicle in Good Condition');
  String get recGoodDesc =>
      _t('No se detectaron problemas criticos. Se recomienda mantenimiento preventivo regular.',
         'No critical problems detected. Regular preventive maintenance is recommended.');

  // Component names
  String get compSparkPlugs => _t('Bujias', 'Spark plugs');
  String get compIgnitionCoils => _t('Bobinas de encendido', 'Ignition coils');
  String get compInjectors => _t('Inyectores', 'Injectors');
  String get compHighTensionCables => _t('Cables de alta tension', 'High tension cables');
  String get compCatalyst => _t('Catalizador', 'Catalyst');
  String get compO2Sensors => _t('Sensores de oxigeno', 'Oxygen sensors');
  String get compExhaustSystem => _t('Sistema de escape', 'Exhaust system');
  String get compAirFilter => _t('Filtro de aire', 'Air filter');
  String get compMafSensor => _t('Sensor MAF', 'MAF sensor');
  String get compVacuumSystem => _t('Sistema de vacio', 'Vacuum system');
  String get compCoolingSystem => _t('Sistema de refrigeracion', 'Cooling system');
  String get compThermostat => _t('Termostato', 'Thermostat');
  String get compWaterPump => _t('Bomba de agua', 'Water pump');
  String get compRadiator => _t('Radiador', 'Radiator');
  String get compGeneralMaintenance => _t('Mantenimiento general', 'General maintenance');

  // ── Language ──
  String get languageLabel => _t('Idioma', 'Language');
  String get spanish => _t('Español', 'Spanish');
  String get english => _t('Inglés', 'English');

  String _t(String es, String en) => language == AppLanguage.es ? es : en;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final AppLanguage language;
  const AppLocalizationsDelegate(this.language);

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(language);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => old.language != language;
}
