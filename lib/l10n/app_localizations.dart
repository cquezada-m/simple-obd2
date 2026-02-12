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
  String get appSubtitle =>
      _t('Diagnóstico de Vehículo', 'Vehicle Diagnostics');

  // ── Connection ──
  String get connected => _t('Conectado', 'Connected');
  String get connecting => _t('Conectando...', 'Connecting...');
  String get disconnected => _t('Desconectado', 'Disconnected');
  String get connect => _t('Conectar', 'Connect');
  String get disconnect => _t('Desconectar', 'Disconnect');
  String get obd2Device => _t('Dispositivo OBD2', 'OBD2 Device');
  String get connectionHint => _t(
    'Asegúrate de que tu dispositivo OBD2 esté conectado al vehículo y encendido.',
    'Make sure your OBD2 device is connected to the vehicle and turned on.',
  );
  String get searchingDevices =>
      _t('Buscando dispositivos...', 'Searching devices...');
  String get connectDevice => _t('Conectar Dispositivo', 'Connect Device');
  String get connectViaWifi => _t(
    'Conecta vía WiFi al adaptador OBD2',
    'Connect via WiFi to OBD2 adapter',
  );
  String get selectConnectionMethod =>
      _t('Selecciona el método de conexión', 'Select connection method');
  String get useDemoData => _t('Usar datos de demostración', 'Use demo data');
  String get connectViaWifiBtn => _t('Conectar vía WiFi', 'Connect via WiFi');
  String get ipAddress => _t('Dirección IP', 'IP Address');
  String get port => _t('Puerto', 'Port');
  String get howToConnectWifi =>
      _t('Cómo conectar vía WiFi', 'How to connect via WiFi');
  String get wifiStep1 => _t(
    'Conecta el adaptador OBD2 al puerto del vehículo',
    'Connect the OBD2 adapter to the vehicle port',
  );
  String get wifiStep2 => _t(
    'Ve a Ajustes > WiFi en tu dispositivo',
    'Go to Settings > WiFi on your device',
  );
  String get wifiStep3 =>
      _t('Conéctate a la red del adaptador', 'Connect to the adapter network');
  String get wifiStep4 => _t(
    'Regresa aquí y presiona Conectar',
    'Come back here and press Connect',
  );
  String get noDevicesFound => _t(
    'No se encontraron dispositivos emparejados',
    'No paired devices found',
  );
  String get unknownDevice => _t('Dispositivo desconocido', 'Unknown device');
  String btError(String e) => _t(
    'No se pudo conectar via Bluetooth: $e',
    'Could not connect via Bluetooth: $e',
  );
  String wifiError(String host, int port) => _t(
    'No se pudo conectar via WiFi a $host:$port. Verifica que tu dispositivo este conectado a la red WiFi del adaptador OBD2.',
    'Could not connect via WiFi to $host:$port. Verify your device is connected to the OBD2 adapter WiFi network.',
  );
  String get notAvailable => _t('No disponible', 'Not available');

  // ── Vehicle Info ──
  String get vehicleInfo =>
      _t('Información del Vehículo', 'Vehicle Information');
  String get obd2SystemData => _t('Datos del sistema OBD2', 'OBD2 system data');
  String get protocol => _t('Protocolo', 'Protocol');
  String get ecusDetected => _t('ECUs Detectadas', 'ECUs Detected');
  String get manufacturer => _t('Fabricante', 'Manufacturer');
  String get modelYear => _t('Año', 'Year');
  String get region => _t('Región', 'Region');

  // ── Tabs ──
  String get diagnosticTab => _t('Diagnóstico', 'Diagnostics');
  String get liveTab => _t('En Vivo', 'Live');

  // ── Diagnostic Codes ──
  String get diagnosticCodes =>
      _t('Códigos de Diagnóstico', 'Diagnostic Codes');
  String get clearing => _t('Borrando...', 'Clearing...');
  String get clearCodes => _t('Borrar códigos', 'Clear codes');
  String get noErrorCodes => _t('Sin códigos de error', 'No error codes');
  String get systemOk => _t(
    'El sistema está funcionando correctamente',
    'System is working correctly',
  );
  String get severityCritical => _t('Crítico', 'Critical');
  String get severityWarning => _t('Advertencia', 'Warning');
  String get severityInfo => _t('Info', 'Info');

  // ── Live Parameters ──
  String get liveParameters =>
      _t('Parámetros en Tiempo Real', 'Real-Time Parameters');
  String get live => _t('Live', 'Live');
  String get gaugesTitle =>
      _t('Tacómetro y Velocímetro', 'Tachometer & Speedometer');

  // ── Parameter Labels ──
  String get paramRpm => _t('RPM', 'RPM');
  String get paramSpeed => _t('Velocidad', 'Speed');
  String get paramEngineTemp => _t('Temp. Motor', 'Engine Temp.');
  String get paramEngineLoad => _t('Carga Motor', 'Engine Load');
  String get paramIntakePressure => _t('Presion Admision', 'Intake Pressure');
  String get paramFuelLevel => _t('Nivel Combustible', 'Fuel Level');

  // ── AI Recommendations ──
  String get aiAnalysis => _t('Análisis AI', 'AI Analysis');
  String get aiRecommendations => _t(
    'Recomendaciones basadas en diagnóstico',
    'Recommendations based on diagnostics',
  );
  String get estimatedCost => _t('Costo estimado', 'Estimated cost');
  String get aiDisclaimer =>
      _t('Análisis generado por IA. ', 'AI-generated analysis. ');
  String get aiDisclaimerDetail => _t(
    'Consulta con un mecánico certificado antes de realizar reparaciones.',
    'Consult a certified mechanic before making repairs.',
  );
  String get priorityHigh => _t('Alta', 'High');
  String get priorityMedium => _t('Media', 'Medium');
  String get priorityLow => _t('Baja', 'Low');

  // ── Disconnected State ──
  String get connectObd2 =>
      _t('Conecta tu dispositivo OBD2', 'Connect your OBD2 device');
  String get connectObd2Hint => _t(
    'Conecta el escáner al puerto de diagnóstico de tu vehículo y presiona conectar',
    'Connect the scanner to your vehicle diagnostic port and press connect',
  );

  // ── Recommendations (provider) ──
  String get recIgnitionTitle => _t(
    'Revisar Sistema de Encendido - Cilindro 1',
    'Check Ignition System - Cylinder 1',
  );
  String get recIgnitionDesc => _t(
    'El fallo de encendido puede deberse a bujias desgastadas, bobinas defectuosas o problemas en los inyectores.',
    'Misfire may be caused by worn spark plugs, faulty coils, or injector problems.',
  );
  String get recCatalystTitle =>
      _t('Inspeccion del Catalizador', 'Catalyst Inspection');
  String get recCatalystDesc => _t(
    'La eficiencia del catalizador esta por debajo del umbral. Puede requerir limpieza o reemplazo.',
    'Catalyst efficiency is below threshold. May require cleaning or replacement.',
  );
  String get recFuelTitle =>
      _t('Verificar Sistema de Combustible', 'Check Fuel System');
  String get recFuelDesc => _t(
    'El sistema esta funcionando muy pobre. Revisar filtro de aire, sensores MAF y posibles fugas de vacio.',
    'System is running too lean. Check air filter, MAF sensors, and possible vacuum leaks.',
  );
  String get recTempTitle =>
      _t('Temperatura del Motor Elevada', 'High Engine Temperature');
  String get recTempDesc => _t(
    'El motor esta operando a temperatura alta. Verificar nivel de refrigerante y funcionamiento del termostato.',
    'Engine is operating at high temperature. Check coolant level and thermostat operation.',
  );
  String get recGoodTitle =>
      _t('Vehiculo en Buen Estado', 'Vehicle in Good Condition');
  String get recGoodDesc => _t(
    'No se detectaron problemas criticos. Se recomienda mantenimiento preventivo regular.',
    'No critical problems detected. Regular preventive maintenance is recommended.',
  );

  // Component names
  String get compSparkPlugs => _t('Bujias', 'Spark plugs');
  String get compIgnitionCoils => _t('Bobinas de encendido', 'Ignition coils');
  String get compInjectors => _t('Inyectores', 'Injectors');
  String get compHighTensionCables =>
      _t('Cables de alta tension', 'High tension cables');
  String get compCatalyst => _t('Catalizador', 'Catalyst');
  String get compO2Sensors => _t('Sensores de oxigeno', 'Oxygen sensors');
  String get compExhaustSystem => _t('Sistema de escape', 'Exhaust system');
  String get compAirFilter => _t('Filtro de aire', 'Air filter');
  String get compMafSensor => _t('Sensor MAF', 'MAF sensor');
  String get compVacuumSystem => _t('Sistema de vacio', 'Vacuum system');
  String get compCoolingSystem =>
      _t('Sistema de refrigeracion', 'Cooling system');
  String get compThermostat => _t('Termostato', 'Thermostat');
  String get compWaterPump => _t('Bomba de agua', 'Water pump');
  String get compRadiator => _t('Radiador', 'Radiator');
  String get compGeneralMaintenance =>
      _t('Mantenimiento general', 'General maintenance');

  // ── Language ──
  String get languageLabel => _t('Idioma', 'Language');

  // ── Logs ──
  String get logsTitle => _t('Registro de Actividad', 'Activity Log');
  String get logsEmpty => _t('Sin registros aún', 'No logs yet');
  String get logsClear => _t('Limpiar', 'Clear');
  String get logsCopied =>
      _t('Logs copiados al portapapeles', 'Logs copied to clipboard');
  String get logsExport => _t('Copiar todo', 'Copy all');
  String get logsFilterAll => _t('Todos', 'All');
  String get logsFilterConnection => _t('Conexión', 'Connection');
  String get logsFilterCommand => _t('Comandos', 'Commands');
  String get logsFilterParse => _t('Parseo', 'Parsing');
  String get logsFilterDtc => _t('DTC', 'DTC');
  String get logsFilterAi => _t('AI', 'AI');
  String get logsFilterError => _t('Errores', 'Errors');
  String get spanish => _t('Español', 'Spanish');
  String get english => _t('Inglés', 'English');

  // ── Privacy Policy ──
  String get privacyPolicyTitle =>
      _t('Política de Privacidad', 'Privacy Policy');
  String get privacyLastUpdated =>
      _t('Última actualización: Febrero 2026', 'Last updated: February 2026');
  String get privacyPolicyLink =>
      _t('Política de Privacidad', 'Privacy Policy');

  List<Map<String, String>> get privacySections => [
    {
      'title': _t('Información que recopilamos', 'Information We Collect'),
      'body': _t(
        'OBD2 Scanner accede a datos de diagnóstico del vehículo (RPM, velocidad, temperatura, códigos de falla) directamente desde el adaptador OBD2 conectado. Estos datos se procesan localmente en tu dispositivo y NO se envían a servidores externos ni se almacenan fuera de la aplicación.',
        'OBD2 Scanner accesses vehicle diagnostic data (RPM, speed, temperature, fault codes) directly from the connected OBD2 adapter. This data is processed locally on your device and is NOT sent to external servers or stored outside the application.',
      ),
    },
    {
      'title': _t('Permisos del dispositivo', 'Device Permissions'),
      'body': _t(
        'Bluetooth: Necesario para comunicarse con adaptadores OBD2 ELM327 vía Bluetooth.\n'
            'WiFi/Red Local: Necesario para conectarse a adaptadores OBD2 WiFi.\n'
            'Ubicación: Requerido por el sistema operativo para escanear dispositivos Bluetooth cercanos. Tu ubicación NO se almacena ni se comparte.',
        'Bluetooth: Required to communicate with OBD2 ELM327 adapters via Bluetooth.\n'
            'WiFi/Local Network: Required to connect to WiFi OBD2 adapters.\n'
            'Location: Required by the operating system to scan for nearby Bluetooth devices. Your location is NOT stored or shared.',
      ),
    },
    {
      'title': _t('Almacenamiento de datos', 'Data Storage'),
      'body': _t(
        'Todos los datos de diagnóstico se mantienen exclusivamente en la memoria de la aplicación durante la sesión activa. Al cerrar la aplicación o desconectar el adaptador, los datos se eliminan automáticamente. No utilizamos bases de datos, almacenamiento en la nube ni servicios de análisis.',
        'All diagnostic data is kept exclusively in the application memory during the active session. When closing the app or disconnecting the adapter, data is automatically deleted. We do not use databases, cloud storage, or analytics services.',
      ),
    },
    {
      'title': _t('Servicios de terceros', 'Third-Party Services'),
      'body': _t(
        'La aplicación puede utilizar Google Fonts para la tipografía, lo cual requiere una conexión a internet.\n\n'
            'Función de Diagnóstico AI (opcional): Si activas el diagnóstico con inteligencia artificial, los datos del vehículo (parámetros del motor, códigos de falla y VIN) se envían a la API de Google Gemini para generar un análisis. Esta función es completamente opcional y solo se activa cuando el usuario la solicita explícitamente. Google puede procesar estos datos según su política de privacidad.',
        'The application may use Google Fonts for typography, which requires an internet connection.\n\n'
            'AI Diagnostic Feature (optional): If you activate the AI diagnostic, vehicle data (engine parameters, fault codes, and VIN) is sent to the Google Gemini API to generate an analysis. This feature is completely optional and only activates when the user explicitly requests it. Google may process this data according to their privacy policy.',
      ),
    },
    {
      'title': _t('Contacto', 'Contact'),
      'body': _t(
        'Si tienes preguntas sobre esta política de privacidad, puedes contactarnos a través de la página de la aplicación en la tienda de aplicaciones.',
        'If you have questions about this privacy policy, you can contact us through the application page on the app store.',
      ),
    },
  ];

  // ── Permissions ──
  String get permissionsRequired =>
      _t('Permisos Necesarios', 'Permissions Required');
  String get permissionsBluetoothTitle => _t('Bluetooth', 'Bluetooth');
  String get permissionsBluetoothDesc => _t(
    'Para conectarse al adaptador OBD2 ELM327',
    'To connect to the OBD2 ELM327 adapter',
  );
  String get permissionsLocationTitle => _t('Ubicación', 'Location');
  String get permissionsLocationDesc => _t(
    'Requerido por el sistema para detectar dispositivos Bluetooth. No almacenamos tu ubicación.',
    'Required by the system to detect Bluetooth devices. We do not store your location.',
  );
  String get permissionsGrantAll =>
      _t('Conceder Permisos', 'Grant Permissions');
  String get permissionsDeniedMsg => _t(
    'Algunos permisos fueron denegados. Puedes habilitarlos en Ajustes del dispositivo.',
    'Some permissions were denied. You can enable them in device Settings.',
  );
  String get permissionsOpenSettings => _t('Abrir Ajustes', 'Open Settings');

  // ── Clear Codes Confirmation ──
  String get clearCodesConfirmTitle =>
      _t('¿Borrar códigos de falla?', 'Clear fault codes?');
  String get clearCodesConfirmMsg => _t(
    'Esta acción borrará todos los códigos de diagnóstico (DTC) del vehículo. Los códigos volverán a aparecer si el problema persiste.',
    'This will clear all diagnostic trouble codes (DTC) from the vehicle. Codes will reappear if the problem persists.',
  );
  String get cancel => _t('Cancelar', 'Cancel');
  String get confirm => _t('Confirmar', 'Confirm');

  // ── Draggy ──
  String get draggyTitle => _t('Draggy', 'Draggy');
  String get draggySelectTest =>
      _t('Selecciona el tipo de prueba', 'Select test type');
  String get draggyStart => _t('Iniciar', 'Start');
  String get draggyReady =>
      _t('Listo — Acelera cuando quieras', 'Ready — Accelerate when ready');
  String get draggyMustStop =>
      _t('Detén el vehículo para iniciar', 'Stop the vehicle to start');
  String get draggyResults => _t('Resultados', 'Results');
  String get draggyTrapSpeed => _t('Vel. trampa', 'Trap speed');
  String get draggyMaxRpm => _t('RPM máx', 'Max RPM');
  String get draggyTempStart => _t('Temp. inicio', 'Start temp');
  String get draggyTempEnd => _t('Temp. fin', 'End temp');
  String get draggyChart =>
      _t('Velocidad y RPM vs Tiempo', 'Speed & RPM vs Time');

  // ── Sensor Explorer ──
  String get sensorExplorerTitle =>
      _t('Explorador de Sensores', 'Sensor Explorer');
  String get sensorSearch => _t('Buscar sensor...', 'Search sensor...');
  String get sensorAvailable => _t('sensores disponibles', 'sensors available');
  String get sensorCatEngine => _t('Motor', 'Engine');
  String get sensorCatFuel => _t('Combustible', 'Fuel');
  String get sensorCatAir => _t('Aire', 'Air');
  String get sensorCatEmissions => _t('Emisiones', 'Emissions');
  String get sensorCatElectrical => _t('Eléctrico', 'Electrical');
  String get sensorCatDiagnostic => _t('Diagnóstico', 'Diagnostic');
  String get sensorMin => _t('Mín', 'Min');
  String get sensorMax => _t('Máx', 'Max');
  String get sensorAvg => _t('Prom', 'Avg');
  String get sensorNoData => _t('Sin datos aún', 'No data yet');
  String get sensorHistory => _t('Historial', 'History');
  String get sensorInfo => _t('Información del sensor', 'Sensor information');
  String get sensorUnit => _t('Unidad', 'Unit');
  String get sensorCategory => _t('Categoría', 'Category');
  String get sensorNormalMax => _t('Máx. normal', 'Normal max');
  String get sensorWarningMax => _t('Máx. advertencia', 'Warning max');

  // ── Mileage Check ──
  String get mileageCheckTitle =>
      _t('Verificación de Kilometraje', 'Mileage Verification');
  String get mileageCheckDesc => _t(
    'Compara el kilometraje almacenado en múltiples módulos del vehículo para detectar posibles manipulaciones.',
    'Compare mileage stored in multiple vehicle modules to detect possible tampering.',
  );
  String get mileageCheckBasic => _t('Básica', 'Basic');
  String get mileageCheckFull => _t('Completa', 'Full');
  String get mileageDisclaimer => _t(
    'Resultado indicativo. Consulte un profesional para verificación legal.',
    'Indicative result. Consult a professional for legal verification.',
  );

  // ── Chat AI ──
  String get chatAiTitle => _t('Chat AI', 'AI Chat');
  String get chatAiHint => _t(
    'Pregunta lo que quieras sobre tu vehículo',
    'Ask anything about your vehicle',
  );
  String get chatAiPlaceholder =>
      _t('Escribe tu pregunta...', 'Type your question...');

  // ── Emissions ──
  String get emissionsTitle =>
      _t('Pre-verificación Emisiones', 'Emissions Pre-check');
  String get emissionsPasses => _t('APROBADO', 'PASS');
  String get emissionsFails => _t('NO APROBADO', 'FAIL');
  String get emissionsPassDesc => _t(
    'No se detectaron códigos de falla activos. Tu vehículo debería pasar la verificación de emisiones.',
    'No active fault codes detected. Your vehicle should pass the emissions check.',
  );
  String get emissionsFailDesc => _t(
    'Se detectaron códigos de falla activos que podrían impedir la verificación de emisiones.',
    'Active fault codes detected that could prevent passing the emissions check.',
  );
  String get emissionsBlockingCodes =>
      _t('Códigos que impiden verificación', 'Codes blocking verification');
  String get emissionsDisclaimer => _t(
    'Resultado indicativo basado en DTCs activos. El resultado real puede variar según la normativa local.',
    'Indicative result based on active DTCs. Actual result may vary based on local regulations.',
  );

  // ── Drive Session ──
  String get driveSessionTitle => _t('Modo Viaje', 'Drive Mode');
  String get driveSessionStart => _t('Iniciar grabación', 'Start recording');
  String get driveSessionStop => _t('Detener', 'Stop');
  String get driveSessionDuration => _t('Duración', 'Duration');
  String get driveSessionAvgSpeed => _t('Vel. promedio', 'Avg speed');
  String get driveSessionMaxSpeed => _t('Vel. máxima', 'Max speed');
  String get driveSessionEvents => _t('Eventos', 'Events');
  String get driveSessionHardAccel =>
      _t('Aceleración brusca', 'Hard acceleration');
  String get driveSessionHardBrake => _t('Frenado brusco', 'Hard braking');
  String get driveSessionHighRpm => _t('RPM alto', 'High RPM');
  String get driveSessionRecording => _t('Grabando...', 'Recording...');

  // ── Home Feature Cards ──
  String get featuresTitle => _t('Herramientas', 'Tools');
  String get featureExportPdf => _t('Exportar PDF', 'Export PDF');
  String get featureExportPdfDesc =>
      _t('Genera un reporte diagnóstico', 'Generate a diagnostic report');
  String get pdfExported => _t('Reporte PDF generado', 'PDF report generated');
  String get pdfError => _t('Error al generar PDF', 'Error generating PDF');

  // ── Demo Mode ──
  String get chatAiDemoReply => _t(
    'Modo demostración: Esta es una respuesta simulada. Configura tu API key de Gemini para obtener diagnósticos reales con inteligencia artificial.',
    'Demo mode: This is a simulated response. Configure your Gemini API key to get real AI-powered diagnostics.',
  );
  String get draggyDemoRunning =>
      _t('Simulando prueba de demo...', 'Simulating demo test...');

  // ── UX Feedback ──
  String get disconnectConfirmTitle =>
      _t('¿Desconectar dispositivo?', 'Disconnect device?');
  String get disconnectConfirmMsg => _t(
    'Se detendrá la lectura de datos en tiempo real del vehículo.',
    'Real-time vehicle data reading will stop.',
  );
  String get connectedSuccess =>
      _t('Conectado al dispositivo OBD2', 'Connected to OBD2 device');
  String get codesCleared =>
      _t('Códigos borrados correctamente', 'Codes cleared successfully');
  String get chatAiTyping => _t('Analizando...', 'Analyzing...');

  // ── UX Hints ──
  String get swipeHint => _t('Desliza', 'Swipe');
  String get alertThreshold => _t('límite', 'limit');

  String _t(String es, String en) => language == AppLanguage.es ? es : en;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final AppLanguage language;
  const AppLocalizationsDelegate(this.language);

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(language);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => old.language != language;
}
