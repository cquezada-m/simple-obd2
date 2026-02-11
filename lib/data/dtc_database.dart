/// DTC code database with Spanish and English descriptions.
/// Source: autoxuga.net/cursos/averiasp.php (content rephrased for compliance).
class DtcDatabase {
  DtcDatabase._();

  static String? getDescriptionEs(String code) =>
      _codes[code.toUpperCase()]?.$1;
  static String? getDescriptionEn(String code) =>
      _codes[code.toUpperCase()]?.$2;

  static String? getDescription(String code, String locale) {
    final entry = _codes[code.toUpperCase()];
    if (entry == null) return null;
    return locale == 'es' ? entry.$1 : entry.$2;
  }

  static const Map<String, (String, String)> _codes = {
    'P0000': ('No se encuentra ninguna averia', 'No fault found'),
    'P0001': (
      'Control regulador volumen combustible - circuito abierto',
      'Fuel volume regulator control - open circuit',
    ),
    'P0002': (
      'Control regulador volumen combustible - rango/funcionamiento circuito',
      'Fuel volume regulator control - circuit range/performance',
    ),
    'P0003': (
      'Control regulador volumen combustible - señal baja',
      'Fuel volume regulator control - low signal',
    ),
    'P0004': (
      'Control regulador volumen combustible - señal alta',
      'Fuel volume regulator control - high signal',
    ),
    'P0005': (
      'Valvula corte combustible - circuito abierto',
      'Fuel shutoff valve - open circuit',
    ),
    'P0006': (
      'Valvula corte combustible - señal baja',
      'Fuel shutoff valve - low signal',
    ),
    'P0007': (
      'Valvula corte combustible - señal alta',
      'Fuel shutoff valve - high signal',
    ),
    'P0008': (
      'Sistema posicion motor (bloque 1) - rendimiento',
      'Engine position system (bank 1) - performance',
    ),
    'P0009': (
      'Sistema posicion motor (bloque 2) - rendimiento',
      'Engine position system (bank 2) - performance',
    ),
    'P0010': (
      'Actuador posicion arbol levas (bloque 1) - circuito defectuoso',
      'Camshaft position actuator (bank 1) - faulty circuit',
    ),
    'P0011': (
      'Posicion arbol levas (bloque 1) - encendido avanzado, rendimiento',
      'Camshaft position (bank 1) - timing over-advanced, performance',
    ),
    'P0012': (
      'Posicion arbol levas (bloque 1) - encendido atrasado',
      'Camshaft position (bank 1) - timing over-retarded',
    ),
    'P0013': (
      'Actuador posicion arbol levas (bloque 1) - circuito defectuoso',
      'Camshaft position actuator (bank 1) - faulty circuit',
    ),
    'P0014': (
      'Actuador posicion arbol levas (bloque 1) - encendido avanzado, rendimiento',
      'Camshaft position actuator (bank 1) - timing over-advanced, performance',
    ),
    'P0015': (
      'Actuador posicion arbol levas (bloque 1) - encendido atrasado',
      'Camshaft position actuator (bank 1) - timing over-retarded',
    ),
    'P0016': (
      'Posicion cigüeñal-arbol levas (bloque 1 sensor A) - correlacion',
      'Crankshaft-camshaft position (bank 1 sensor A) - correlation',
    ),
    'P0017': (
      'Posicion cigüeñal-arbol levas (bloque 1 sensor B) - correlacion',
      'Crankshaft-camshaft position (bank 1 sensor B) - correlation',
    ),
    'P0018': (
      'Posicion cigüeñal-arbol levas (bloque 2 sensor A) - correlacion',
      'Crankshaft-camshaft position (bank 2 sensor A) - correlation',
    ),
    'P0019': (
      'Posicion cigüeñal-arbol levas (bloque 2 sensor B) - correlacion',
      'Crankshaft-camshaft position (bank 2 sensor B) - correlation',
    ),
    'P0020': (
      'Actuador posicion arbol levas (bloque 2) - circuito defectuoso',
      'Camshaft position actuator (bank 2) - faulty circuit',
    ),
    'P0021': (
      'Posicion arbol levas (bloque 2) - encendido avanzado, rendimiento',
      'Camshaft position (bank 2) - timing over-advanced, performance',
    ),
    'P0022': (
      'Posicion arbol levas (bloque 2) - encendido atrasado',
      'Camshaft position (bank 2) - timing over-retarded',
    ),
    'P0023': (
      'Actuador posicion arbol levas (bloque 2) - circuito defectuoso',
      'Camshaft position actuator (bank 2) - faulty circuit',
    ),
    'P0024': (
      'Actuador posicion arbol levas (bloque 2) - encendido avanzado, rendimiento',
      'Camshaft position actuator (bank 2) - timing over-advanced, performance',
    ),
    'P0025': (
      'Actuador posicion arbol levas (bloque 2) - encendido atrasado',
      'Camshaft position actuator (bank 2) - timing over-retarded',
    ),
    'P0026': (
      'Circuito solenoide control valvula admision (bloque 1) - rango',
      'Intake valve control solenoid circuit (bank 1) - range',
    ),
    'P0027': (
      'Circuito solenoide control valvula escape (bloque 1) - rango',
      'Exhaust valve control solenoid circuit (bank 1) - range',
    ),
    'P0028': (
      'Circuito solenoide control valvula admision (bloque 2) - rango',
      'Intake valve control solenoid circuit (bank 2) - range',
    ),
    'P0029': (
      'Circuito solenoide control valvula escape (bloque 2) - rango',
      'Exhaust valve control solenoid circuit (bank 2) - range',
    ),
    'P0030': (
      'Sensor calentado oxigeno (Sensor 1 bloque 1) - circuito defectuoso',
      'Heated oxygen sensor (Sensor 1 bank 1) - faulty circuit',
    ),
    'P0031': (
      'Sensor calentado oxigeno (Sensor 1 bloque 1) - señal baja',
      'Heated oxygen sensor (Sensor 1 bank 1) - low signal',
    ),
    'P0032': (
      'Sensor calentado oxigeno (Sensor 1 bloque 1) - señal alta',
      'Heated oxygen sensor (Sensor 1 bank 1) - high signal',
    ),
    'P0033': (
      'Valvula descarga turbocompresor - circuito defectuoso',
      'Turbocharger wastegate valve - faulty circuit',
    ),
    'P0034': (
      'Valvula descarga turbocompresor - señal baja',
      'Turbocharger wastegate valve - low signal',
    ),
    'P0035': (
      'Valvula descarga turbocompresor - señal alta',
      'Turbocharger wastegate valve - high signal',
    ),
    'P0036': (
      'Sensor calentado oxigeno (Sensor 2 bloque 1) - circuito defectuoso',
      'Heated oxygen sensor (Sensor 2 bank 1) - faulty circuit',
    ),
    'P0037': (
      'Sensor calentado oxigeno (Sensor 2 bloque 1) - señal baja',
      'Heated oxygen sensor (Sensor 2 bank 1) - low signal',
    ),
    'P0038': (
      'Sensor calentado oxigeno (Sensor 2 bloque 1) - señal alta',
      'Heated oxygen sensor (Sensor 2 bank 1) - high signal',
    ),
    'P0039': (
      'Valvula derivacion turbocompresor - rango',
      'Turbocharger bypass valve - range',
    ),
    'P0040': (
      'Señales sensor oxigeno cambiadas (bloque 1 sensor 1 y bloque 2 sensor 1)',
      'O2 sensor signals swapped (bank 1 sensor 1 and bank 2 sensor 1)',
    ),
    'P0041': (
      'Señales sensor oxigeno cambiadas (bloque 1 sensor 2 y bloque 2 sensor 2)',
      'O2 sensor signals swapped (bank 1 sensor 2 and bank 2 sensor 2)',
    ),
    'P0042': (
      'Sensor calentado oxigeno (Sensor 3 bloque 1) - circuito defectuoso',
      'Heated oxygen sensor (Sensor 3 bank 1) - faulty circuit',
    ),
    'P0043': (
      'Sensor calentado oxigeno (Sensor 3 bloque 1) - señal baja',
      'Heated oxygen sensor (Sensor 3 bank 1) - low signal',
    ),
    'P0044': (
      'Sensor calentado oxigeno (Sensor 3 bloque 1) - señal alta',
      'Heated oxygen sensor (Sensor 3 bank 1) - high signal',
    ),
    'P0045': (
      'Solenoide sobrealimentacion turbocompresor - circuito abierto',
      'Turbocharger boost solenoid - open circuit',
    ),
    'P0046': (
      'Solenoide sobrealimentacion turbocompresor - rango, rendimiento',
      'Turbocharger boost solenoid - range, performance',
    ),
    'P0047': (
      'Solenoide sobrealimentacion turbocompresor - señal baja',
      'Turbocharger boost solenoid - low signal',
    ),
    'P0048': (
      'Solenoide sobrealimentacion turbocompresor - señal alta',
      'Turbocharger boost solenoid - high signal',
    ),
    'P0049': (
      'Turbina turbocompresor - sobrevelocidad',
      'Turbocharger turbine - overspeed',
    ),
    'P0050': (
      'Sensor calentado oxigeno (Sensor 1 bloque 2) - circuito defectuoso',
      'Heated oxygen sensor (Sensor 1 bank 2) - faulty circuit',
    ),
    'P0051': (
      'Sensor calentado oxigeno (Sensor 1 bloque 2) - señal baja',
      'Heated oxygen sensor (Sensor 1 bank 2) - low signal',
    ),
    'P0052': (
      'Sensor calentado oxigeno (Sensor 1 bloque 2) - señal alta',
      'Heated oxygen sensor (Sensor 1 bank 2) - high signal',
    ),
    'P0053': (
      'Sensor calentado oxigeno (Sensor 1 bloque 1) - resistencia',
      'Heated oxygen sensor (Sensor 1 bank 1) - resistance',
    ),
    'P0054': (
      'Sensor calentado oxigeno (Sensor 2 bloque 1) - resistencia',
      'Heated oxygen sensor (Sensor 2 bank 1) - resistance',
    ),
    'P0055': (
      'Sensor calentado oxigeno (Sensor 3 bloque 1) - resistencia',
      'Heated oxygen sensor (Sensor 3 bank 1) - resistance',
    ),
    'P0056': (
      'Sensor calentado oxigeno (Sensor 2 bloque 2) - circuito defectuoso',
      'Heated oxygen sensor (Sensor 2 bank 2) - faulty circuit',
    ),
    'P0057': (
      'Sensor calentado oxigeno (Sensor 2 bloque 2) - señal baja',
      'Heated oxygen sensor (Sensor 2 bank 2) - low signal',
    ),
    'P0058': (
      'Sensor calentado oxigeno (Sensor 2 bloque 2) - señal alta',
      'Heated oxygen sensor (Sensor 2 bank 2) - high signal',
    ),
    'P0059': (
      'Sensor calentado oxigeno (Sensor 1 bloque 2) - resistencia',
      'Heated oxygen sensor (Sensor 1 bank 2) - resistance',
    ),
    'P0060': (
      'Sensor calentado oxigeno (Sensor 2 bloque 2) - resistencia',
      'Heated oxygen sensor (Sensor 2 bank 2) - resistance',
    ),
    'P0061': (
      'Sensor calentado oxigeno (Sensor 3 bloque 2) - resistencia',
      'Heated oxygen sensor (Sensor 3 bank 2) - resistance',
    ),
    'P0062': (
      'Sensor calentado oxigeno (Sensor 3 bloque 2) - circuito defectuoso',
      'Heated oxygen sensor (Sensor 3 bank 2) - faulty circuit',
    ),
    'P0063': (
      'Sensor calentado oxigeno (Sensor 3 bloque 2) - señal baja',
      'Heated oxygen sensor (Sensor 3 bank 2) - low signal',
    ),
    'P0064': (
      'Sensor calentado oxigeno (Sensor 3 bloque 2) - señal alta',
      'Heated oxygen sensor (Sensor 3 bank 2) - high signal',
    ),
    'P0065': (
      'Inyector asistido por aire - rango, funcionamiento',
      'Air-assisted injector - range, performance',
    ),
    'P0066': (
      'Inyector asistido por aire - circuito defectuoso, señal baja',
      'Air-assisted injector - faulty circuit, low signal',
    ),
    'P0067': (
      'Inyector asistido por aire - señal alta',
      'Air-assisted injector - high signal',
    ),
    'P0068': (
      'Correlacion sensor MAP/sensor MAF/Posicion mariposa',
      'MAP sensor/MAF sensor/Throttle position correlation',
    ),
    'P0069': (
      'Correlacion sensor presion absoluta colector/sensor presion barometrica',
      'Manifold absolute pressure/barometric pressure sensor correlation',
    ),
    'P0070': (
      'Sensor temperatura aire ambiente - circuito defectuoso',
      'Ambient air temperature sensor - faulty circuit',
    ),
    'P0071': (
      'Sensor temperatura aire ambiente - rango, funcionamiento',
      'Ambient air temperature sensor - range, performance',
    ),
    'P0072': (
      'Sensor temperatura aire ambiente - señal baja',
      'Ambient air temperature sensor - low signal',
    ),
    'P0073': (
      'Sensor temperatura aire ambiente - señal alta',
      'Ambient air temperature sensor - high signal',
    ),
    'P0074': (
      'Sensor temperatura aire ambiente - interrupcion intermitente',
      'Ambient air temperature sensor - intermittent',
    ),
    'P0075': (
      'Solenoide control valvula admision (bloque 1) - circuito defectuoso',
      'Intake valve control solenoid (bank 1) - faulty circuit',
    ),
    'P0076': (
      'Solenoide control valvula admision (bloque 1) - señal baja',
      'Intake valve control solenoid (bank 1) - low signal',
    ),
    'P0077': (
      'Solenoide control valvula admision (bloque 1) - señal alta',
      'Intake valve control solenoid (bank 1) - high signal',
    ),
    'P0078': (
      'Solenoide control valvula escape (bloque 1) - circuito defectuoso',
      'Exhaust valve control solenoid (bank 1) - faulty circuit',
    ),
    'P0079': (
      'Solenoide control valvula escape (bloque 1) - señal baja',
      'Exhaust valve control solenoid (bank 1) - low signal',
    ),
    'P0080': (
      'Solenoide control valvula escape (bloque 1) - señal alta',
      'Exhaust valve control solenoid (bank 1) - high signal',
    ),
    'P0081': (
      'Solenoide control valvula admision (bloque 2) - circuito defectuoso',
      'Intake valve control solenoid (bank 2) - faulty circuit',
    ),
    'P0082': (
      'Solenoide control valvula admision (bloque 2) - señal baja',
      'Intake valve control solenoid (bank 2) - low signal',
    ),
    'P0083': (
      'Solenoide control valvula admision (bloque 2) - señal alta',
      'Intake valve control solenoid (bank 2) - high signal',
    ),
    'P0084': (
      'Solenoide control valvula escape (bloque 2) - circuito defectuoso',
      'Exhaust valve control solenoid (bank 2) - faulty circuit',
    ),
    'P0085': (
      'Solenoide control valvula escape (bloque 2) - señal baja',
      'Exhaust valve control solenoid (bank 2) - low signal',
    ),
    'P0086': (
      'Solenoide control valvula escape (bloque 2) - señal alta',
      'Exhaust valve control solenoid (bank 2) - high signal',
    ),
    'P0087': (
      'Rampa combustible/Presion sistema demasiado baja',
      'Fuel rail/System pressure too low',
    ),
    'P0088': (
      'Rampa combustible/Presion sistema demasiado alta',
      'Fuel rail/System pressure too high',
    ),
    'P0089': (
      'Regulador presion combustible 1 - funcionamiento',
      'Fuel pressure regulator 1 - performance',
    ),
    'P0090': (
      'Solenoide dosificador combustible 1 - circuito abierto',
      'Fuel metering solenoid 1 - open circuit',
    ),
    'P0091': (
      'Solenoide dosificador combustible 1 - cortocircuito a masa',
      'Fuel metering solenoid 1 - short to ground',
    ),
    'P0092': (
      'Solenoide dosificador combustible 1 - cortocircuito a positivo',
      'Fuel metering solenoid 1 - short to positive',
    ),
    'P0093': (
      'Fuga en sistema combustible - fuga grande',
      'Fuel system leak - large leak',
    ),
    'P0094': (
      'Fuga en sistema combustible - fuga pequeña',
      'Fuel system leak - small leak',
    ),
    'P0095': (
      'Sensor temperatura aire admision 2 - circuito defectuoso',
      'Intake air temperature sensor 2 - faulty circuit',
    ),
    'P0096': (
      'Sensor temperatura aire admision 2 - rango, funcionamiento',
      'Intake air temperature sensor 2 - range, performance',
    ),
    'P0097': (
      'Sensor temperatura aire admision 2 - señal baja',
      'Intake air temperature sensor 2 - low signal',
    ),
    'P0098': (
      'Sensor temperatura aire admision 2 - señal alta',
      'Intake air temperature sensor 2 - high signal',
    ),
    'P0099': (
      'Sensor temperatura aire admision 2 - circuito intermitente',
      'Intake air temperature sensor 2 - intermittent circuit',
    ),
    'P0100': (
      'Sensor masa/volumen aire - circuito defectuoso',
      'Mass/volume air sensor - faulty circuit',
    ),
    'P0101': (
      'Sensor masa/volumen aire - rango, funcionamiento',
      'Mass/volume air sensor - range/performance',
    ),
    'P0102': (
      'Sensor masa/volumen aire - señal entrada baja',
      'Mass/volume air sensor - low input',
    ),
    'P0103': (
      'Sensor masa/volumen aire - señal entrada alta',
      'Mass/volume air sensor - high input',
    ),
    'P0104': (
      'Sensor masa/volumen aire - interrupción intermitente',
      'Mass/volume air sensor - intermittent',
    ),
    'P0105': (
      'Sensor presión absoluta colector/presión barométrica - circuito defectuoso',
      'MAP/barometric pressure sensor - faulty circuit',
    ),
    'P0106': (
      'Sensor presión absoluta colector/presión barométrica - rango, funcionamiento',
      'MAP/barometric pressure sensor - range/performance',
    ),
    'P0107': (
      'Sensor presión absoluta colector/presión barométrica - señal entrada baja',
      'MAP/barometric pressure sensor - low input',
    ),
    'P0108': (
      'Sensor presión absoluta colector/presión barométrica - señal entrada alta',
      'MAP/barometric pressure sensor - high input',
    ),
    'P0109': (
      'Sensor presión absoluta colector/presión barométrica - interrupción intermitente',
      'MAP/barometric pressure sensor - intermittent',
    ),
    'P0110': (
      'Sensor temperatura aire admisión - circuito defectuoso',
      'Intake air temperature sensor - faulty circuit',
    ),
    'P0111': (
      'Sensor temperatura aire admisión - rango, funcionamiento',
      'Intake air temperature sensor - range/performance',
    ),
    'P0112': (
      'Sensor temperatura aire admisión - señal entrada baja',
      'Intake air temperature sensor - low input',
    ),
    'P0113': (
      'Sensor temperatura aire admisión - señal entrada alta',
      'Intake air temperature sensor - high input',
    ),
    'P0114': (
      'Sensor temperatura aire admisión - interrupción intermitente',
      'Intake air temperature sensor - intermittent',
    ),
    'P0115': (
      'Sensor temperatura refrigerante motor - circuito defectuoso',
      'Engine coolant temperature sensor - faulty circuit',
    ),
    'P0116': (
      'Sensor temperatura refrigerante motor - rango, funcionamiento',
      'Engine coolant temperature sensor - range/performance',
    ),
    'P0117': (
      'Sensor temperatura refrigerante motor - señal entrada baja',
      'Engine coolant temperature sensor - low input',
    ),
    'P0118': (
      'Sensor temperatura refrigerante motor - señal entrada alta',
      'Engine coolant temperature sensor - high input',
    ),
    'P0119': (
      'Sensor temperatura refrigerante motor - interrupción intermitente',
      'Engine coolant temperature sensor - intermittent',
    ),
    'P0120': (
      'Sensor posición pedal acelerador/mariposa A - circuito defectuoso',
      'Throttle/pedal position sensor A - faulty circuit',
    ),
    'P0121': (
      'Sensor posición pedal acelerador/mariposa A - rango, funcionamiento',
      'Throttle/pedal position sensor A - range/performance',
    ),
    'P0122': (
      'Sensor posición pedal acelerador/mariposa A - señal entrada baja',
      'Throttle/pedal position sensor A - low input',
    ),
    'P0123': (
      'Sensor posición pedal acelerador/mariposa A - señal entrada alta',
      'Throttle/pedal position sensor A - high input',
    ),
    'P0124': (
      'Sensor posición pedal acelerador/mariposa A - interrupción intermitente',
      'Throttle/pedal position sensor A - intermittent',
    ),
    'P0125': (
      'Temperatura refrigerante insuficiente para control combustible bucle cerrado',
      'Insufficient coolant temperature for closed loop fuel control',
    ),
    'P0126': (
      'Temperatura refrigerante insuficiente para funcionamiento estable',
      'Insufficient coolant temperature for stable operation',
    ),
    'P0127': (
      'Temperatura aire admisión demasiado alta',
      'Intake air temperature too high',
    ),
    'P0128': (
      'Termostato refrigerante - temperatura por debajo del valor regulado',
      'Coolant thermostat - temperature below regulating value',
    ),
    'P0129': (
      'Presión barométrica demasiado baja',
      'Barometric pressure too low',
    ),
    'P0130': (
      'Sensor oxígeno (Sensor 1 bloque 1) - circuito defectuoso',
      'O2 sensor (Sensor 1 bank 1) - faulty circuit',
    ),
    'P0131': (
      'Sensor oxígeno (Sensor 1 bloque 1) - baja tensión',
      'O2 sensor (Sensor 1 bank 1) - low voltage',
    ),
    'P0132': (
      'Sensor oxígeno (Sensor 1 bloque 1) - alta tensión',
      'O2 sensor (Sensor 1 bank 1) - high voltage',
    ),
    'P0133': (
      'Sensor oxígeno (Sensor 1 bloque 1) - respuesta lenta',
      'O2 sensor (Sensor 1 bank 1) - slow response',
    ),
    'P0134': (
      'Sensor oxígeno (Sensor 1 bloque 1) - actividad no detectada',
      'O2 sensor (Sensor 1 bank 1) - no activity detected',
    ),
    'P0135': (
      'Sensor calentado oxígeno (Sensor 1 bloque 1) - circuito defectuoso',
      'Heated O2 sensor (Sensor 1 bank 1) - faulty circuit',
    ),
    'P0136': (
      'Sensor oxígeno (Sensor 2 bloque 1) - circuito defectuoso',
      'O2 sensor (Sensor 2 bank 1) - faulty circuit',
    ),
    'P0137': (
      'Sensor oxígeno (Sensor 2 bloque 1) - baja tensión',
      'O2 sensor (Sensor 2 bank 1) - low voltage',
    ),
    'P0138': (
      'Sensor oxígeno (Sensor 2 bloque 1) - alta tensión',
      'O2 sensor (Sensor 2 bank 1) - high voltage',
    ),
    'P0139': (
      'Sensor oxígeno (Sensor 2 bloque 1) - respuesta lenta',
      'O2 sensor (Sensor 2 bank 1) - slow response',
    ),
    'P0140': (
      'Sensor oxígeno (Sensor 2 bloque 1) - actividad no detectada',
      'O2 sensor (Sensor 2 bank 1) - no activity detected',
    ),
    'P0141': (
      'Sensor calentado oxígeno (Sensor 2 bloque 1) - circuito defectuoso',
      'Heated O2 sensor (Sensor 2 bank 1) - faulty circuit',
    ),
    'P0142': (
      'Sensor oxígeno (Sensor 3 bloque 1) - circuito defectuoso',
      'O2 sensor (Sensor 3 bank 1) - faulty circuit',
    ),
    'P0143': (
      'Sensor oxígeno (Sensor 3 bloque 1) - baja tensión',
      'O2 sensor (Sensor 3 bank 1) - low voltage',
    ),
    'P0144': (
      'Sensor oxígeno (Sensor 3 bloque 1) - alta tensión',
      'O2 sensor (Sensor 3 bank 1) - high voltage',
    ),
    'P0145': (
      'Sensor oxígeno (Sensor 3 bloque 1) - respuesta lenta',
      'O2 sensor (Sensor 3 bank 1) - slow response',
    ),
    'P0146': (
      'Sensor oxígeno (Sensor 3 bloque 1) - actividad no detectada',
      'O2 sensor (Sensor 3 bank 1) - no activity detected',
    ),
    'P0147': (
      'Sensor calentado oxígeno (Sensor 3 bloque 1) - circuito defectuoso',
      'Heated O2 sensor (Sensor 3 bank 1) - faulty circuit',
    ),
    'P0148': ('Error alimentación combustible', 'Fuel supply error'),
    'P0149': ('Error reglaje combustible', 'Fuel timing error'),
    'P0150': (
      'Sensor oxígeno (Sensor 1 bloque 2) - circuito defectuoso',
      'O2 sensor (Sensor 1 bank 2) - faulty circuit',
    ),
    'P0151': (
      'Sensor oxígeno (Sensor 1 bloque 2) - baja tensión',
      'O2 sensor (Sensor 1 bank 2) - low voltage',
    ),
    'P0152': (
      'Sensor oxígeno (Sensor 1 bloque 2) - alta tensión',
      'O2 sensor (Sensor 1 bank 2) - high voltage',
    ),
    'P0153': (
      'Sensor oxígeno (Sensor 1 bloque 2) - respuesta lenta',
      'O2 sensor (Sensor 1 bank 2) - slow response',
    ),
    'P0154': (
      'Sensor oxígeno (Sensor 1 bloque 2) - actividad no detectada',
      'O2 sensor (Sensor 1 bank 2) - no activity detected',
    ),
    'P0155': (
      'Sensor calentado oxígeno (Sensor 1 bloque 2) - circuito defectuoso',
      'Heated O2 sensor (Sensor 1 bank 2) - faulty circuit',
    ),
    'P0156': (
      'Sensor oxígeno (Sensor 2 bloque 2) - circuito defectuoso',
      'O2 sensor (Sensor 2 bank 2) - faulty circuit',
    ),
    'P0157': (
      'Sensor oxígeno (Sensor 2 bloque 2) - baja tensión',
      'O2 sensor (Sensor 2 bank 2) - low voltage',
    ),
    'P0158': (
      'Sensor oxígeno (Sensor 2 bloque 2) - alta tensión',
      'O2 sensor (Sensor 2 bank 2) - high voltage',
    ),
    'P0159': (
      'Sensor oxígeno (Sensor 2 bloque 2) - respuesta lenta',
      'O2 sensor (Sensor 2 bank 2) - slow response',
    ),
    'P0160': (
      'Sensor oxígeno (Sensor 2 bloque 2) - actividad no detectada',
      'O2 sensor (Sensor 2 bank 2) - no activity detected',
    ),
    'P0161': (
      'Sensor calentado oxígeno (Sensor 2 bloque 2) - circuito defectuoso',
      'Heated O2 sensor (Sensor 2 bank 2) - faulty circuit',
    ),
    'P0162': (
      'Sensor oxígeno (Sensor 3 bloque 2) - circuito defectuoso',
      'O2 sensor (Sensor 3 bank 2) - faulty circuit',
    ),
    'P0163': (
      'Sensor oxígeno (Sensor 3 bloque 2) - baja tensión',
      'O2 sensor (Sensor 3 bank 2) - low voltage',
    ),
    'P0164': (
      'Sensor oxígeno (Sensor 3 bloque 2) - alta tensión',
      'O2 sensor (Sensor 3 bank 2) - high voltage',
    ),
    'P0165': (
      'Sensor oxígeno (Sensor 3 bloque 2) - respuesta lenta',
      'O2 sensor (Sensor 3 bank 2) - slow response',
    ),
    'P0166': (
      'Sensor oxígeno (Sensor 3 bloque 2) - actividad no detectada',
      'O2 sensor (Sensor 3 bank 2) - no activity detected',
    ),
    'P0167': (
      'Sensor calentado oxígeno (Sensor 3 bloque 2) - circuito defectuoso',
      'Heated O2 sensor (Sensor 3 bank 2) - faulty circuit',
    ),
    'P0168': (
      'Temperatura combustible demasiado alta',
      'Fuel temperature too high',
    ),
    'P0169': (
      'Composición combustible incorrecta',
      'Incorrect fuel composition',
    ),
    'P0170': (
      'Regulación inyección (bloque 1) - circuito defectuoso',
      'Fuel trim (bank 1) - faulty circuit',
    ),
    'P0171': (
      'Regulación inyección (bloque 1) - demasiado pobre',
      'Fuel trim (bank 1) - system too lean',
    ),
    'P0172': (
      'Regulación inyección (bloque 1) - demasiado rico',
      'Fuel trim (bank 1) - system too rich',
    ),
    'P0173': (
      'Regulación inyección (bloque 2) - circuito defectuoso',
      'Fuel trim (bank 2) - faulty circuit',
    ),
    'P0174': (
      'Regulación inyección (bloque 2) - demasiado pobre',
      'Fuel trim (bank 2) - system too lean',
    ),
    'P0175': (
      'Regulación inyección (bloque 2) - demasiado rico',
      'Fuel trim (bank 2) - system too rich',
    ),
    'P0176': (
      'Sensor composición combustible - circuito defectuoso',
      'Fuel composition sensor - faulty circuit',
    ),
    'P0177': (
      'Sensor composición combustible - rango, funcionamiento',
      'Fuel composition sensor - range/performance',
    ),
    'P0178': (
      'Sensor composición combustible - señal baja',
      'Fuel composition sensor - low signal',
    ),
    'P0179': (
      'Sensor composición combustible - señal alta',
      'Fuel composition sensor - high signal',
    ),
    'P0180': (
      'Sensor temperatura combustible A - circuito defectuoso',
      'Fuel temperature sensor A - faulty circuit',
    ),
    'P0181': (
      'Sensor temperatura combustible A - rango, funcionamiento',
      'Fuel temperature sensor A - range/performance',
    ),
    'P0182': (
      'Sensor temperatura combustible A - señal baja',
      'Fuel temperature sensor A - low signal',
    ),
    'P0183': (
      'Sensor temperatura combustible A - señal alta',
      'Fuel temperature sensor A - high signal',
    ),
    'P0184': (
      'Sensor temperatura combustible A - interrupción intermitente',
      'Fuel temperature sensor A - intermittent',
    ),
    'P0185': (
      'Sensor temperatura combustible B - circuito defectuoso',
      'Fuel temperature sensor B - faulty circuit',
    ),
    'P0186': (
      'Sensor temperatura combustible B - rango, funcionamiento',
      'Fuel temperature sensor B - range/performance',
    ),
    'P0187': (
      'Sensor temperatura combustible B - señal baja',
      'Fuel temperature sensor B - low signal',
    ),
    'P0188': (
      'Sensor temperatura combustible B - señal alta',
      'Fuel temperature sensor B - high signal',
    ),
    'P0189': (
      'Sensor temperatura combustible B - interrupción intermitente',
      'Fuel temperature sensor B - intermittent',
    ),
    'P0190': (
      'Sensor presión rampa combustible - circuito defectuoso',
      'Fuel rail pressure sensor - faulty circuit',
    ),
    'P0191': (
      'Sensor presión rampa combustible - rango, funcionamiento',
      'Fuel rail pressure sensor - range/performance',
    ),
    'P0192': (
      'Sensor presión rampa combustible - señal baja',
      'Fuel rail pressure sensor - low signal',
    ),
    'P0193': (
      'Sensor presión rampa combustible - señal alta',
      'Fuel rail pressure sensor - high signal',
    ),
    'P0194': (
      'Sensor presión rampa combustible - interrupción intermitente',
      'Fuel rail pressure sensor - intermittent',
    ),
    'P0195': (
      'Sensor temperatura aceite motor - circuito defectuoso',
      'Engine oil temperature sensor - faulty circuit',
    ),
    'P0196': (
      'Sensor temperatura aceite motor - rango, funcionamiento',
      'Engine oil temperature sensor - range/performance',
    ),
    'P0197': (
      'Sensor temperatura aceite motor - señal baja',
      'Engine oil temperature sensor - low signal',
    ),
    'P0198': (
      'Sensor temperatura aceite motor - señal alta',
      'Engine oil temperature sensor - high signal',
    ),
    'P0199': (
      'Sensor temperatura aceite motor - interrupción intermitente',
      'Engine oil temperature sensor - intermittent',
    ),
    'P0200': ('Inyector - circuito defectuoso', 'Injector - faulty circuit'),
    'P0201': (
      'Inyector cilindro 1 - circuito defectuoso',
      'Injector cylinder 1 - faulty circuit',
    ),
    'P0202': (
      'Inyector cilindro 2 - circuito defectuoso',
      'Injector cylinder 2 - faulty circuit',
    ),
    'P0203': (
      'Inyector cilindro 3 - circuito defectuoso',
      'Injector cylinder 3 - faulty circuit',
    ),
    'P0204': (
      'Inyector cilindro 4 - circuito defectuoso',
      'Injector cylinder 4 - faulty circuit',
    ),
    'P0205': (
      'Inyector cilindro 5 - circuito defectuoso',
      'Injector cylinder 5 - faulty circuit',
    ),
    'P0206': (
      'Inyector cilindro 6 - circuito defectuoso',
      'Injector cylinder 6 - faulty circuit',
    ),
    'P0207': (
      'Inyector cilindro 7 - circuito defectuoso',
      'Injector cylinder 7 - faulty circuit',
    ),
    'P0208': (
      'Inyector cilindro 8 - circuito defectuoso',
      'Injector cylinder 8 - faulty circuit',
    ),
    'P0209': (
      'Inyector cilindro 9 - circuito defectuoso',
      'Injector cylinder 9 - faulty circuit',
    ),
    'P0210': (
      'Inyector cilindro 10 - circuito defectuoso',
      'Injector cylinder 10 - faulty circuit',
    ),
    'P0211': (
      'Inyector cilindro 11 - circuito defectuoso',
      'Injector cylinder 11 - faulty circuit',
    ),
    'P0212': (
      'Inyector cilindro 12 - circuito defectuoso',
      'Injector cylinder 12 - faulty circuit',
    ),
    'P0213': (
      'Inyector arranque en frío 1 - circuito defectuoso',
      'Cold start injector 1 - faulty circuit',
    ),
    'P0214': (
      'Inyector arranque en frío 2 - circuito defectuoso',
      'Cold start injector 2 - faulty circuit',
    ),
    'P0215': (
      'Solenoide corte combustible - circuito defectuoso',
      'Fuel shutoff solenoid - faulty circuit',
    ),
    'P0216': (
      'Control reglaje inyección - circuito defectuoso',
      'Injection timing control - faulty circuit',
    ),
    'P0217': ('Sobrecalentamiento motor', 'Engine overheating'),
    'P0218': ('Sobrecalentamiento transmisión', 'Transmission overheating'),
    'P0219': ('Sobrerégimen motor', 'Engine overspeed'),
    'P0220': (
      'Sensor posición mariposa/pedal acelerador B - circuito defectuoso',
      'Throttle/pedal position sensor B - faulty circuit',
    ),
    'P0221': (
      'Sensor posición mariposa/pedal acelerador B - rango, funcionamiento',
      'Throttle/pedal position sensor B - range/performance',
    ),
    'P0222': (
      'Sensor posición mariposa/pedal acelerador B - señal baja',
      'Throttle/pedal position sensor B - low input',
    ),
    'P0223': (
      'Sensor posición mariposa/pedal acelerador B - señal alta',
      'Throttle/pedal position sensor B - high input',
    ),
    'P0224': (
      'Sensor posición mariposa/pedal acelerador B - interrupción intermitente',
      'Throttle/pedal position sensor B - intermittent',
    ),
    'P0225': (
      'Sensor posición mariposa/pedal acelerador C - circuito defectuoso',
      'Throttle/pedal position sensor C - faulty circuit',
    ),
    'P0226': (
      'Sensor posición mariposa/pedal acelerador C - rango, funcionamiento',
      'Throttle/pedal position sensor C - range/performance',
    ),
    'P0227': (
      'Sensor posición mariposa/pedal acelerador C - señal baja',
      'Throttle/pedal position sensor C - low input',
    ),
    'P0228': (
      'Sensor posición mariposa/pedal acelerador C - señal alta',
      'Throttle/pedal position sensor C - high input',
    ),
    'P0229': (
      'Sensor posición mariposa/pedal acelerador C - interrupción intermitente',
      'Throttle/pedal position sensor C - intermittent',
    ),
    'P0230': (
      'Circuito primario bomba combustible - circuito defectuoso',
      'Fuel pump primary circuit - faulty circuit',
    ),
    'P0231': (
      'Circuito secundario bomba combustible - señal baja',
      'Fuel pump secondary circuit - low signal',
    ),
    'P0232': (
      'Circuito secundario bomba combustible - señal alta',
      'Fuel pump secondary circuit - high signal',
    ),
    'P0233': (
      'Circuito secundario bomba combustible - interrupción intermitente',
      'Fuel pump secondary circuit - intermittent',
    ),
    'P0234': (
      'Sobrealimentación motor - límite excedido',
      'Engine boost - limit exceeded',
    ),
    'P0235': (
      'Control sobrealimentación turbocompresor A - circuito defectuoso',
      'Turbocharger boost control A - faulty circuit',
    ),
    'P0236': (
      'Control sobrealimentación turbocompresor A - rango, funcionamiento',
      'Turbocharger boost control A - range/performance',
    ),
    'P0237': (
      'Control sobrealimentación turbocompresor A - señal baja',
      'Turbocharger boost control A - low signal',
    ),
    'P0238': (
      'Control sobrealimentación turbocompresor A - señal alta',
      'Turbocharger boost control A - high signal',
    ),
    'P0239': (
      'Control sobrealimentación turbocompresor B - circuito defectuoso',
      'Turbocharger boost control B - faulty circuit',
    ),
    'P0240': (
      'Control sobrealimentación turbocompresor B - rango, funcionamiento',
      'Turbocharger boost control B - range/performance',
    ),
    'P0241': (
      'Control sobrealimentación turbocompresor B - señal baja',
      'Turbocharger boost control B - low signal',
    ),
    'P0242': (
      'Control sobrealimentación turbocompresor B - señal alta',
      'Turbocharger boost control B - high signal',
    ),
    'P0243': (
      'Solenoide válvula descarga turbocompresor A - circuito defectuoso',
      'Turbocharger wastegate solenoid A - faulty circuit',
    ),
    'P0244': (
      'Solenoide válvula descarga turbocompresor A - rango, funcionamiento',
      'Turbocharger wastegate solenoid A - range/performance',
    ),
    'P0245': (
      'Solenoide válvula descarga turbocompresor A - señal baja',
      'Turbocharger wastegate solenoid A - low signal',
    ),
    'P0246': (
      'Solenoide válvula descarga turbocompresor A - señal alta',
      'Turbocharger wastegate solenoid A - high signal',
    ),
    'P0247': (
      'Solenoide válvula descarga turbocompresor B - circuito defectuoso',
      'Turbocharger wastegate solenoid B - faulty circuit',
    ),
    'P0248': (
      'Solenoide válvula descarga turbocompresor B - rango, funcionamiento',
      'Turbocharger wastegate solenoid B - range/performance',
    ),
    'P0249': (
      'Solenoide válvula descarga turbocompresor B - señal baja',
      'Turbocharger wastegate solenoid B - low signal',
    ),
    'P0250': (
      'Solenoide válvula descarga turbocompresor B - señal alta',
      'Turbocharger wastegate solenoid B - high signal',
    ),
    'P0251': (
      'Bomba inyección A rotor/leva - circuito defectuoso',
      'Injection pump A rotor/cam - faulty circuit',
    ),
    'P0252': (
      'Bomba inyección A rotor/leva - rango, funcionamiento',
      'Injection pump A rotor/cam - range/performance',
    ),
    'P0253': (
      'Bomba inyección A rotor/leva - señal baja',
      'Injection pump A rotor/cam - low signal',
    ),
    'P0254': (
      'Bomba inyección A rotor/leva - señal alta',
      'Injection pump A rotor/cam - high signal',
    ),
    'P0255': (
      'Bomba inyección A rotor/leva - interrupción intermitente',
      'Injection pump A rotor/cam - intermittent',
    ),
    'P0256': (
      'Bomba inyección B rotor/leva - circuito defectuoso',
      'Injection pump B rotor/cam - faulty circuit',
    ),
    'P0257': (
      'Bomba inyección B rotor/leva - rango, funcionamiento',
      'Injection pump B rotor/cam - range/performance',
    ),
    'P0258': (
      'Bomba inyección B rotor/leva - señal baja',
      'Injection pump B rotor/cam - low signal',
    ),
    'P0259': (
      'Bomba inyección B rotor/leva - señal alta',
      'Injection pump B rotor/cam - high signal',
    ),
    'P0260': (
      'Bomba inyección B rotor/leva - interrupción intermitente',
      'Injection pump B rotor/cam - intermittent',
    ),
    'P0261': (
      'Inyector cilindro 1 - señal baja',
      'Injector cylinder 1 - low signal',
    ),
    'P0262': (
      'Inyector cilindro 1 - señal alta',
      'Injector cylinder 1 - high signal',
    ),
    'P0263': (
      'Inyector cilindro 1 - contribución/equilibrio',
      'Injector cylinder 1 - contribution/balance',
    ),
    'P0264': (
      'Inyector cilindro 2 - señal baja',
      'Injector cylinder 2 - low signal',
    ),
    'P0265': (
      'Inyector cilindro 2 - señal alta',
      'Injector cylinder 2 - high signal',
    ),
    'P0266': (
      'Inyector cilindro 2 - contribución/equilibrio',
      'Injector cylinder 2 - contribution/balance',
    ),
    'P0267': (
      'Inyector cilindro 3 - señal baja',
      'Injector cylinder 3 - low signal',
    ),
    'P0268': (
      'Inyector cilindro 3 - señal alta',
      'Injector cylinder 3 - high signal',
    ),
    'P0269': (
      'Inyector cilindro 3 - contribución/equilibrio',
      'Injector cylinder 3 - contribution/balance',
    ),
    'P0270': (
      'Inyector cilindro 4 - señal baja',
      'Injector cylinder 4 - low signal',
    ),
    'P0271': (
      'Inyector cilindro 4 - señal alta',
      'Injector cylinder 4 - high signal',
    ),
    'P0272': (
      'Inyector cilindro 4 - contribución/equilibrio',
      'Injector cylinder 4 - contribution/balance',
    ),
    'P0273': (
      'Inyector cilindro 5 - señal baja',
      'Injector cylinder 5 - low signal',
    ),
    'P0274': (
      'Inyector cilindro 5 - señal alta',
      'Injector cylinder 5 - high signal',
    ),
    'P0275': (
      'Inyector cilindro 5 - contribución/equilibrio',
      'Injector cylinder 5 - contribution/balance',
    ),
    'P0276': (
      'Inyector cilindro 6 - señal baja',
      'Injector cylinder 6 - low signal',
    ),
    'P0277': (
      'Inyector cilindro 6 - señal alta',
      'Injector cylinder 6 - high signal',
    ),
    'P0278': (
      'Inyector cilindro 6 - contribución/equilibrio',
      'Injector cylinder 6 - contribution/balance',
    ),
    'P0279': (
      'Inyector cilindro 7 - señal baja',
      'Injector cylinder 7 - low signal',
    ),
    'P0280': (
      'Inyector cilindro 7 - señal alta',
      'Injector cylinder 7 - high signal',
    ),
    'P0281': (
      'Inyector cilindro 7 - contribución/equilibrio',
      'Injector cylinder 7 - contribution/balance',
    ),
    'P0282': (
      'Inyector cilindro 8 - señal baja',
      'Injector cylinder 8 - low signal',
    ),
    'P0283': (
      'Inyector cilindro 8 - señal alta',
      'Injector cylinder 8 - high signal',
    ),
    'P0284': (
      'Inyector cilindro 8 - contribución/equilibrio',
      'Injector cylinder 8 - contribution/balance',
    ),
    'P0285': (
      'Inyector cilindro 9 - señal baja',
      'Injector cylinder 9 - low signal',
    ),
    'P0286': (
      'Inyector cilindro 9 - señal alta',
      'Injector cylinder 9 - high signal',
    ),
    'P0287': (
      'Inyector cilindro 9 - contribución/equilibrio',
      'Injector cylinder 9 - contribution/balance',
    ),
    'P0288': (
      'Inyector cilindro 10 - señal baja',
      'Injector cylinder 10 - low signal',
    ),
    'P0289': (
      'Inyector cilindro 10 - señal alta',
      'Injector cylinder 10 - high signal',
    ),
    'P0290': (
      'Inyector cilindro 10 - contribución/equilibrio',
      'Injector cylinder 10 - contribution/balance',
    ),
    'P0291': (
      'Inyector cilindro 11 - señal baja',
      'Injector cylinder 11 - low signal',
    ),
    'P0292': (
      'Inyector cilindro 11 - señal alta',
      'Injector cylinder 11 - high signal',
    ),
    'P0293': (
      'Inyector cilindro 11 - contribución/equilibrio',
      'Injector cylinder 11 - contribution/balance',
    ),
    'P0294': (
      'Inyector cilindro 12 - señal baja',
      'Injector cylinder 12 - low signal',
    ),
    'P0295': (
      'Inyector cilindro 12 - señal alta',
      'Injector cylinder 12 - high signal',
    ),
    'P0296': (
      'Inyector cilindro 12 - contribución/equilibrio',
      'Injector cylinder 12 - contribution/balance',
    ),
    'P0297': ('Sobrevelocidad del vehículo', 'Vehicle overspeed'),
    'P0298': (
      'Temperatura aceite motor demasiado alta',
      'Engine oil temperature too high',
    ),
    'P0299': (
      'Turbocompresor/supercargador - presión baja',
      'Turbocharger/supercharger - low boost',
    ),
    'P0300': (
      'Uno o varios cilindros - falsa explosión detectada',
      'Multiple cylinders - misfire detected',
    ),
    'P0301': (
      'Cilindro 1 - falsa explosión detectada',
      'Cylinder 1 - misfire detected',
    ),
    'P0302': (
      'Cilindro 2 - falsa explosión detectada',
      'Cylinder 2 - misfire detected',
    ),
    'P0303': (
      'Cilindro 3 - falsa explosión detectada',
      'Cylinder 3 - misfire detected',
    ),
    'P0304': (
      'Cilindro 4 - falsa explosión detectada',
      'Cylinder 4 - misfire detected',
    ),
    'P0305': (
      'Cilindro 5 - falsa explosión detectada',
      'Cylinder 5 - misfire detected',
    ),
    'P0306': (
      'Cilindro 6 - falsa explosión detectada',
      'Cylinder 6 - misfire detected',
    ),
    'P0307': (
      'Cilindro 7 - falsa explosión detectada',
      'Cylinder 7 - misfire detected',
    ),
    'P0308': (
      'Cilindro 8 - falsa explosión detectada',
      'Cylinder 8 - misfire detected',
    ),
    'P0309': (
      'Cilindro 9 - falsa explosión detectada',
      'Cylinder 9 - misfire detected',
    ),
    'P0310': (
      'Cilindro 10 - falsa explosión detectada',
      'Cylinder 10 - misfire detected',
    ),
    'P0311': (
      'Cilindro 11 - falsa explosión detectada',
      'Cylinder 11 - misfire detected',
    ),
    'P0312': (
      'Cilindro 12 - falsa explosión detectada',
      'Cylinder 12 - misfire detected',
    ),
    'P0313': (
      'Falsa explosión detectada - nivel bajo combustible',
      'Misfire detected - low fuel level',
    ),
    'P0314': (
      'Falsa explosión cilindro individual - no especificado',
      'Single cylinder misfire - not specified',
    ),
    'P0315': (
      'Sistema posición cigüeñal - variación no aprendida',
      'Crankshaft position system - variation not learned',
    ),
    'P0316': (
      'Falsa explosión detectada al arrancar - primeros 1000 ciclos',
      'Misfire detected on startup - first 1000 cycles',
    ),
    'P0317': (
      'Sensor rugosidad carretera no calibrado',
      'Rough road sensor not calibrated',
    ),
    'P0318': (
      'Sensor rugosidad carretera A - circuito defectuoso',
      'Rough road sensor A - faulty circuit',
    ),
    'P0319': (
      'Sensor rugosidad carretera B - circuito defectuoso',
      'Rough road sensor B - faulty circuit',
    ),
    'P0320': (
      'Sensor velocidad motor/posición cigüeñal - circuito defectuoso',
      'Engine speed/crankshaft position sensor - faulty circuit',
    ),
    'P0321': (
      'Sensor velocidad motor/posición cigüeñal - rango, funcionamiento',
      'Engine speed/crankshaft position sensor - range/performance',
    ),
    'P0322': (
      'Sensor velocidad motor/posición cigüeñal - sin señal',
      'Engine speed/crankshaft position sensor - no signal',
    ),
    'P0323': (
      'Sensor velocidad motor/posición cigüeñal - interrupción intermitente',
      'Engine speed/crankshaft position sensor - intermittent',
    ),
    'P0324': ('Error sistema control detonación', 'Knock control system error'),
    'P0325': (
      'Sensor detonación 1 (bloque 1) - circuito defectuoso',
      'Knock sensor 1 (bank 1) - faulty circuit',
    ),
    'P0326': (
      'Sensor detonación 1 (bloque 1) - rango, funcionamiento',
      'Knock sensor 1 (bank 1) - range/performance',
    ),
    'P0327': (
      'Sensor detonación 1 (bloque 1) - señal baja',
      'Knock sensor 1 (bank 1) - low signal',
    ),
    'P0328': (
      'Sensor detonación 1 (bloque 1) - señal alta',
      'Knock sensor 1 (bank 1) - high signal',
    ),
    'P0329': (
      'Sensor detonación 1 (bloque 1) - interrupción intermitente',
      'Knock sensor 1 (bank 1) - intermittent',
    ),
    'P0330': (
      'Sensor detonación 2 (bloque 2) - circuito defectuoso',
      'Knock sensor 2 (bank 2) - faulty circuit',
    ),
    'P0331': (
      'Sensor detonación 2 (bloque 2) - rango, funcionamiento',
      'Knock sensor 2 (bank 2) - range/performance',
    ),
    'P0332': (
      'Sensor detonación 2 (bloque 2) - señal baja',
      'Knock sensor 2 (bank 2) - low signal',
    ),
    'P0333': (
      'Sensor detonación 2 (bloque 2) - señal alta',
      'Knock sensor 2 (bank 2) - high signal',
    ),
    'P0334': (
      'Sensor detonación 2 (bloque 2) - interrupción intermitente',
      'Knock sensor 2 (bank 2) - intermittent',
    ),
    'P0335': (
      'Sensor posición cigüeñal A - circuito defectuoso',
      'Crankshaft position sensor A - faulty circuit',
    ),
    'P0336': (
      'Sensor posición cigüeñal A - rango, funcionamiento',
      'Crankshaft position sensor A - range/performance',
    ),
    'P0337': (
      'Sensor posición cigüeñal A - señal baja',
      'Crankshaft position sensor A - low signal',
    ),
    'P0338': (
      'Sensor posición cigüeñal A - señal alta',
      'Crankshaft position sensor A - high signal',
    ),
    'P0339': (
      'Sensor posición cigüeñal A - interrupción intermitente',
      'Crankshaft position sensor A - intermittent',
    ),
    'P0340': (
      'Sensor posición árbol de levas A (bloque 1) - circuito defectuoso',
      'Camshaft position sensor A (bank 1) - faulty circuit',
    ),
    'P0341': (
      'Sensor posición árbol de levas A (bloque 1) - rango, funcionamiento',
      'Camshaft position sensor A (bank 1) - range/performance',
    ),
    'P0342': (
      'Sensor posición árbol de levas A (bloque 1) - señal baja',
      'Camshaft position sensor A (bank 1) - low signal',
    ),
    'P0343': (
      'Sensor posición árbol de levas A (bloque 1) - señal alta',
      'Camshaft position sensor A (bank 1) - high signal',
    ),
    'P0344': (
      'Sensor posición árbol de levas A (bloque 1) - interrupción intermitente',
      'Camshaft position sensor A (bank 1) - intermittent',
    ),
    'P0345': (
      'Sensor posición árbol de levas A (bloque 2) - circuito defectuoso',
      'Camshaft position sensor A (bank 2) - faulty circuit',
    ),
    'P0346': (
      'Sensor posición árbol de levas A (bloque 2) - rango, funcionamiento',
      'Camshaft position sensor A (bank 2) - range/performance',
    ),
    'P0347': (
      'Sensor posición árbol de levas A (bloque 2) - señal baja',
      'Camshaft position sensor A (bank 2) - low signal',
    ),
    'P0348': (
      'Sensor posición árbol de levas A (bloque 2) - señal alta',
      'Camshaft position sensor A (bank 2) - high signal',
    ),
    'P0349': (
      'Sensor posición árbol de levas A (bloque 2) - interrupción intermitente',
      'Camshaft position sensor A (bank 2) - intermittent',
    ),
    'P0350': (
      'Bobina encendido A - circuito defectuoso',
      'Ignition coil A - faulty circuit',
    ),
    'P0351': (
      'Bobina encendido A - circuito primario/secundario defectuoso',
      'Ignition coil A - primary/secondary circuit fault',
    ),
    'P0352': (
      'Bobina encendido B - circuito primario/secundario defectuoso',
      'Ignition coil B - primary/secondary circuit fault',
    ),
    'P0353': (
      'Bobina encendido C - circuito primario/secundario defectuoso',
      'Ignition coil C - primary/secondary circuit fault',
    ),
    'P0354': (
      'Bobina encendido D - circuito primario/secundario defectuoso',
      'Ignition coil D - primary/secondary circuit fault',
    ),
    'P0355': (
      'Bobina encendido E - circuito primario/secundario defectuoso',
      'Ignition coil E - primary/secondary circuit fault',
    ),
    'P0356': (
      'Bobina encendido F - circuito primario/secundario defectuoso',
      'Ignition coil F - primary/secondary circuit fault',
    ),
    'P0357': (
      'Bobina encendido G - circuito primario/secundario defectuoso',
      'Ignition coil G - primary/secondary circuit fault',
    ),
    'P0358': (
      'Bobina encendido H - circuito primario/secundario defectuoso',
      'Ignition coil H - primary/secondary circuit fault',
    ),
    'P0359': (
      'Bobina encendido I - circuito primario/secundario defectuoso',
      'Ignition coil I - primary/secondary circuit fault',
    ),
    'P0360': (
      'Bobina encendido J - circuito primario/secundario defectuoso',
      'Ignition coil J - primary/secondary circuit fault',
    ),
    'P0361': (
      'Bobina encendido K - circuito primario/secundario defectuoso',
      'Ignition coil K - primary/secondary circuit fault',
    ),
    'P0362': (
      'Bobina encendido L - circuito primario/secundario defectuoso',
      'Ignition coil L - primary/secondary circuit fault',
    ),
    'P0363': (
      'Falsa explosión detectada - cancelación alimentación combustible',
      'Misfire detected - fuel cutoff',
    ),
    'P0364': ('Reservado', 'Reserved'),
    'P0365': (
      'Sensor posición árbol de levas B (bloque 1) - circuito defectuoso',
      'Camshaft position sensor B (bank 1) - faulty circuit',
    ),
    'P0366': (
      'Sensor posición árbol de levas B (bloque 1) - rango, funcionamiento',
      'Camshaft position sensor B (bank 1) - range/performance',
    ),
    'P0367': (
      'Sensor posición árbol de levas B (bloque 1) - señal baja',
      'Camshaft position sensor B (bank 1) - low signal',
    ),
    'P0368': (
      'Sensor posición árbol de levas B (bloque 1) - señal alta',
      'Camshaft position sensor B (bank 1) - high signal',
    ),
    'P0369': (
      'Sensor posición árbol de levas B (bloque 1) - interrupción intermitente',
      'Camshaft position sensor B (bank 1) - intermittent',
    ),
    'P0370': (
      'Señal referencia alta resolución temporización A - circuito defectuoso',
      'Timing reference high resolution signal A - faulty circuit',
    ),
    'P0371': (
      'Señal referencia alta resolución temporización A - demasiados pulsos',
      'Timing reference high resolution signal A - too many pulses',
    ),
    'P0372': (
      'Señal referencia alta resolución temporización A - pocos pulsos',
      'Timing reference high resolution signal A - too few pulses',
    ),
    'P0373': (
      'Señal referencia alta resolución temporización A - pulsos intermitentes',
      'Timing reference high resolution signal A - intermittent pulses',
    ),
    'P0374': (
      'Señal referencia alta resolución temporización A - sin pulsos',
      'Timing reference high resolution signal A - no pulses',
    ),
    'P0375': (
      'Señal referencia alta resolución temporización B - circuito defectuoso',
      'Timing reference high resolution signal B - faulty circuit',
    ),
    'P0376': (
      'Señal referencia alta resolución temporización B - demasiados pulsos',
      'Timing reference high resolution signal B - too many pulses',
    ),
    'P0377': (
      'Señal referencia alta resolución temporización B - pocos pulsos',
      'Timing reference high resolution signal B - too few pulses',
    ),
    'P0378': (
      'Señal referencia alta resolución temporización B - pulsos intermitentes',
      'Timing reference high resolution signal B - intermittent pulses',
    ),
    'P0379': (
      'Señal referencia alta resolución temporización B - sin pulsos',
      'Timing reference high resolution signal B - no pulses',
    ),
    'P0380': (
      'Circuito bujía incandescente/calentador A - defectuoso',
      'Glow plug/heater circuit A - faulty',
    ),
    'P0381': (
      'Indicador bujía incandescente/calentador - circuito defectuoso',
      'Glow plug/heater indicator - faulty circuit',
    ),
    'P0382': (
      'Circuito bujía incandescente/calentador B - defectuoso',
      'Glow plug/heater circuit B - faulty',
    ),
    'P0383': (
      'Módulo control bujías incandescentes - señal baja',
      'Glow plug control module - low signal',
    ),
    'P0384': (
      'Módulo control bujías incandescentes - señal alta',
      'Glow plug control module - high signal',
    ),
    'P0385': (
      'Sensor posición cigüeñal B - circuito defectuoso',
      'Crankshaft position sensor B - faulty circuit',
    ),
    'P0386': (
      'Sensor posición cigüeñal B - rango, funcionamiento',
      'Crankshaft position sensor B - range/performance',
    ),
    'P0387': (
      'Sensor posición cigüeñal B - señal baja',
      'Crankshaft position sensor B - low signal',
    ),
    'P0388': (
      'Sensor posición cigüeñal B - señal alta',
      'Crankshaft position sensor B - high signal',
    ),
    'P0389': (
      'Sensor posición cigüeñal B - interrupción intermitente',
      'Crankshaft position sensor B - intermittent',
    ),
    'P0390': (
      'Sensor posición árbol de levas B (bloque 2) - circuito defectuoso',
      'Camshaft position sensor B (bank 2) - faulty circuit',
    ),
    'P0391': (
      'Sensor posición árbol de levas B (bloque 2) - rango, funcionamiento',
      'Camshaft position sensor B (bank 2) - range/performance',
    ),
    'P0392': (
      'Sensor posición árbol de levas B (bloque 2) - señal baja',
      'Camshaft position sensor B (bank 2) - low signal',
    ),
    'P0393': (
      'Sensor posición árbol de levas B (bloque 2) - señal alta',
      'Camshaft position sensor B (bank 2) - high signal',
    ),
    'P0394': (
      'Sensor posición árbol de levas B (bloque 2) - interrupción intermitente',
      'Camshaft position sensor B (bank 2) - intermittent',
    ),
    'P0395': (
      'Sensor posición cigüeñal B - señal baja',
      'Crankshaft position sensor B - low signal',
    ),
    'P0396': (
      'Sensor posición cigüeñal B - señal alta',
      'Crankshaft position sensor B - high signal',
    ),
    'P0397': (
      'Sensor posición cigüeñal B - interrupción intermitente',
      'Crankshaft position sensor B - intermittent',
    ),
    'P0398': (
      'Sensor calentado oxígeno (Sensor 1 bloque 1) - calentador señal baja',
      'Heated O2 sensor (Sensor 1 bank 1) - heater low signal',
    ),
    'P0399': (
      'Sensor calentado oxígeno (Sensor 1 bloque 1) - calentador señal alta',
      'Heated O2 sensor (Sensor 1 bank 1) - heater high signal',
    ),
    'P0400': (
      'Recirculación gases escape - flujo defectuoso',
      'EGR - defective flow',
    ),
    'P0401': (
      'Recirculación gases escape - flujo insuficiente',
      'EGR - insufficient flow',
    ),
    'P0402': (
      'Recirculación gases escape - flujo excesivo',
      'EGR - excessive flow',
    ),
    'P0403': (
      'Recirculación gases escape - circuito defectuoso',
      'EGR - faulty circuit',
    ),
    'P0404': (
      'Recirculación gases escape - rango, funcionamiento',
      'EGR - range/performance',
    ),
    'P0405': (
      'Sensor recirculación gases escape A - señal baja',
      'EGR sensor A - low signal',
    ),
    'P0406': (
      'Sensor recirculación gases escape A - señal alta',
      'EGR sensor A - high signal',
    ),
    'P0407': (
      'Sensor recirculación gases escape B - señal baja',
      'EGR sensor B - low signal',
    ),
    'P0408': (
      'Sensor recirculación gases escape B - señal alta',
      'EGR sensor B - high signal',
    ),
    'P0409': (
      'Sensor recirculación gases escape A - interrupción intermitente',
      'EGR sensor A - intermittent',
    ),
    'P0410': (
      'Sistema inyección aire secundario - circuito defectuoso',
      'Secondary air injection system - faulty circuit',
    ),
    'P0411': (
      'Sistema inyección aire secundario - flujo incorrecto',
      'Secondary air injection system - incorrect flow',
    ),
    'P0412': (
      'Válvula conmutación inyección aire secundario A - circuito defectuoso',
      'Secondary air injection switching valve A - faulty circuit',
    ),
    'P0413': (
      'Válvula conmutación inyección aire secundario A - circuito abierto',
      'Secondary air injection switching valve A - open circuit',
    ),
    'P0414': (
      'Válvula conmutación inyección aire secundario A - cortocircuito',
      'Secondary air injection switching valve A - short circuit',
    ),
    'P0415': (
      'Válvula conmutación inyección aire secundario B - circuito defectuoso',
      'Secondary air injection switching valve B - faulty circuit',
    ),
    'P0416': (
      'Válvula conmutación inyección aire secundario B - circuito abierto',
      'Secondary air injection switching valve B - open circuit',
    ),
    'P0417': (
      'Válvula conmutación inyección aire secundario B - cortocircuito',
      'Secondary air injection switching valve B - short circuit',
    ),
    'P0418': (
      'Relé bomba inyección aire secundario A - circuito defectuoso',
      'Secondary air injection pump relay A - faulty circuit',
    ),
    'P0419': (
      'Relé bomba inyección aire secundario B - circuito defectuoso',
      'Secondary air injection pump relay B - faulty circuit',
    ),
    'P0420': (
      'Sistema catalizador (bloque 1) - eficiencia por debajo umbral',
      'Catalyst system (bank 1) - efficiency below threshold',
    ),
    'P0421': (
      'Calentamiento catalizador (bloque 1) - eficiencia por debajo umbral',
      'Warm up catalyst (bank 1) - efficiency below threshold',
    ),
    'P0422': (
      'Catalizador principal (bloque 1) - eficiencia por debajo umbral',
      'Main catalyst (bank 1) - efficiency below threshold',
    ),
    'P0423': (
      'Catalizador calentado (bloque 1) - eficiencia por debajo umbral',
      'Heated catalyst (bank 1) - efficiency below threshold',
    ),
    'P0424': (
      'Catalizador calentado (bloque 1) - temperatura por debajo umbral',
      'Heated catalyst (bank 1) - temperature below threshold',
    ),
    'P0425': (
      'Sensor temperatura catalizador (bloque 1 sensor 1)',
      'Catalyst temperature sensor (bank 1 sensor 1)',
    ),
    'P0426': (
      'Sensor temperatura catalizador (bloque 1 sensor 1) - rango, funcionamiento',
      'Catalyst temperature sensor (bank 1 sensor 1) - range/performance',
    ),
    'P0427': (
      'Sensor temperatura catalizador (bloque 1 sensor 1) - señal baja',
      'Catalyst temperature sensor (bank 1 sensor 1) - low signal',
    ),
    'P0428': (
      'Sensor temperatura catalizador (bloque 1 sensor 1) - señal alta',
      'Catalyst temperature sensor (bank 1 sensor 1) - high signal',
    ),
    'P0429': (
      'Calentador catalizador (bloque 1) - circuito defectuoso',
      'Catalyst heater (bank 1) - faulty circuit',
    ),
    'P0430': (
      'Sistema catalizador (bloque 2) - eficiencia por debajo umbral',
      'Catalyst system (bank 2) - efficiency below threshold',
    ),
    'P0431': (
      'Calentamiento catalizador (bloque 2) - eficiencia por debajo umbral',
      'Warm up catalyst (bank 2) - efficiency below threshold',
    ),
    'P0432': (
      'Catalizador principal (bloque 2) - eficiencia por debajo umbral',
      'Main catalyst (bank 2) - efficiency below threshold',
    ),
    'P0433': (
      'Catalizador calentado (bloque 2) - eficiencia por debajo umbral',
      'Heated catalyst (bank 2) - efficiency below threshold',
    ),
    'P0434': (
      'Catalizador calentado (bloque 2) - temperatura por debajo umbral',
      'Heated catalyst (bank 2) - temperature below threshold',
    ),
    'P0435': (
      'Sensor temperatura catalizador (bloque 2 sensor 1)',
      'Catalyst temperature sensor (bank 2 sensor 1)',
    ),
    'P0436': (
      'Sensor temperatura catalizador (bloque 2 sensor 1) - rango, funcionamiento',
      'Catalyst temperature sensor (bank 2 sensor 1) - range/performance',
    ),
    'P0437': (
      'Sensor temperatura catalizador (bloque 2 sensor 1) - señal baja',
      'Catalyst temperature sensor (bank 2 sensor 1) - low signal',
    ),
    'P0438': (
      'Sensor temperatura catalizador (bloque 2 sensor 1) - señal alta',
      'Catalyst temperature sensor (bank 2 sensor 1) - high signal',
    ),
    'P0439': (
      'Calentador catalizador (bloque 2) - circuito defectuoso',
      'Catalyst heater (bank 2) - faulty circuit',
    ),
    'P0440': (
      'Sistema control emisiones evaporativas - circuito defectuoso',
      'EVAP emission control system - faulty circuit',
    ),
    'P0441': (
      'Sistema control emisiones evaporativas - flujo purga incorrecto',
      'EVAP emission control system - incorrect purge flow',
    ),
    'P0442': (
      'Sistema control emisiones evaporativas - fuga pequeña detectada',
      'EVAP emission control system - small leak detected',
    ),
    'P0443': (
      'Válvula control purga emisiones evaporativas - circuito defectuoso',
      'EVAP purge control valve - faulty circuit',
    ),
    'P0444': (
      'Válvula control purga emisiones evaporativas - circuito abierto',
      'EVAP purge control valve - open circuit',
    ),
    'P0445': (
      'Válvula control purga emisiones evaporativas - cortocircuito',
      'EVAP purge control valve - short circuit',
    ),
    'P0446': (
      'Sistema control emisiones evaporativas - circuito ventilación defectuoso',
      'EVAP emission control system - vent circuit fault',
    ),
    'P0447': (
      'Sistema control emisiones evaporativas - circuito ventilación abierto',
      'EVAP emission control system - vent circuit open',
    ),
    'P0448': (
      'Sistema control emisiones evaporativas - circuito ventilación cortocircuito',
      'EVAP emission control system - vent circuit shorted',
    ),
    'P0449': (
      'Sistema control emisiones evaporativas - válvula solenoide ventilación defectuosa',
      'EVAP emission control system - vent solenoid valve fault',
    ),
    'P0450': (
      'Sensor presión emisiones evaporativas - circuito defectuoso',
      'EVAP pressure sensor - faulty circuit',
    ),
    'P0451': (
      'Sensor presión emisiones evaporativas - rango, funcionamiento',
      'EVAP pressure sensor - range/performance',
    ),
    'P0452': (
      'Sensor presión emisiones evaporativas - señal baja',
      'EVAP pressure sensor - low signal',
    ),
    'P0453': (
      'Sensor presión emisiones evaporativas - señal alta',
      'EVAP pressure sensor - high signal',
    ),
    'P0454': (
      'Sensor presión emisiones evaporativas - interrupción intermitente',
      'EVAP pressure sensor - intermittent',
    ),
    'P0455': (
      'Sistema control emisiones evaporativas - fuga grande detectada',
      'EVAP emission control system - large leak detected',
    ),
    'P0456': (
      'Sistema control emisiones evaporativas - fuga muy pequeña detectada',
      'EVAP emission control system - very small leak detected',
    ),
    'P0457': (
      'Sistema control emisiones evaporativas - fuga detectada (tapón combustible suelto)',
      'EVAP emission control system - leak detected (loose fuel cap)',
    ),
    'P0458': (
      'Válvula control purga emisiones evaporativas - señal baja',
      'EVAP purge control valve - low signal',
    ),
    'P0459': (
      'Válvula control purga emisiones evaporativas - señal alta',
      'EVAP purge control valve - high signal',
    ),
    'P0460': (
      'Sensor nivel combustible - circuito defectuoso',
      'Fuel level sensor - faulty circuit',
    ),
    'P0461': (
      'Sensor nivel combustible - rango, funcionamiento',
      'Fuel level sensor - range/performance',
    ),
    'P0462': (
      'Sensor nivel combustible - señal baja',
      'Fuel level sensor - low signal',
    ),
    'P0463': (
      'Sensor nivel combustible - señal alta',
      'Fuel level sensor - high signal',
    ),
    'P0464': (
      'Sensor nivel combustible - interrupción intermitente',
      'Fuel level sensor - intermittent',
    ),
    'P0465': (
      'Sensor flujo purga EVAP - circuito defectuoso',
      'EVAP purge flow sensor - faulty circuit',
    ),
    'P0466': (
      'Sensor flujo purga EVAP - rango, funcionamiento',
      'EVAP purge flow sensor - range/performance',
    ),
    'P0467': (
      'Sensor flujo purga EVAP - señal baja',
      'EVAP purge flow sensor - low signal',
    ),
    'P0468': (
      'Sensor flujo purga EVAP - señal alta',
      'EVAP purge flow sensor - high signal',
    ),
    'P0469': (
      'Sensor flujo purga EVAP - interrupción intermitente',
      'EVAP purge flow sensor - intermittent',
    ),
    'P0470': (
      'Sensor presión gases escape - circuito defectuoso',
      'Exhaust gas pressure sensor - faulty circuit',
    ),
    'P0471': (
      'Sensor presión gases escape - rango, funcionamiento',
      'Exhaust gas pressure sensor - range/performance',
    ),
    'P0472': (
      'Sensor presión gases escape - señal baja',
      'Exhaust gas pressure sensor - low signal',
    ),
    'P0473': (
      'Sensor presión gases escape - señal alta',
      'Exhaust gas pressure sensor - high signal',
    ),
    'P0474': (
      'Sensor presión gases escape - interrupción intermitente',
      'Exhaust gas pressure sensor - intermittent',
    ),
    'P0475': (
      'Regulador presión gases escape - circuito defectuoso',
      'Exhaust gas pressure regulator - faulty circuit',
    ),
    'P0476': (
      'Regulador presión gases escape - rango, funcionamiento',
      'Exhaust gas pressure regulator - range/performance',
    ),
    'P0477': (
      'Regulador presión gases escape - señal baja',
      'Exhaust gas pressure regulator - low signal',
    ),
    'P0478': (
      'Regulador presión gases escape - señal alta',
      'Exhaust gas pressure regulator - high signal',
    ),
    'P0479': (
      'Regulador presión gases escape - interrupción intermitente',
      'Exhaust gas pressure regulator - intermittent',
    ),
    'P0480': (
      'Circuito ventilador refrigeración 1 - defectuoso',
      'Cooling fan 1 circuit - faulty',
    ),
    'P0481': (
      'Circuito ventilador refrigeración 2 - defectuoso',
      'Cooling fan 2 circuit - faulty',
    ),
    'P0482': (
      'Circuito ventilador refrigeración 3 - defectuoso',
      'Cooling fan 3 circuit - faulty',
    ),
    'P0483': (
      'Ventilador refrigeración - verificación funcionamiento racional',
      'Cooling fan - rationality check',
    ),
    'P0484': (
      'Circuito ventilador refrigeración - sobrecorriente',
      'Cooling fan circuit - overcurrent',
    ),
    'P0485': (
      'Circuito ventilador refrigeración - alimentación/masa',
      'Cooling fan circuit - power/ground',
    ),
    'P0486': (
      'Sensor posición recirculación gases escape B - circuito defectuoso',
      'EGR position sensor B - faulty circuit',
    ),
    'P0487': (
      'Posición mariposa recirculación gases escape - circuito defectuoso',
      'EGR throttle position - faulty circuit',
    ),
    'P0488': (
      'Posición mariposa recirculación gases escape - rango, funcionamiento',
      'EGR throttle position - range/performance',
    ),
    'P0489': ('Recirculación gases escape - señal baja', 'EGR - low signal'),
    'P0490': ('Recirculación gases escape - señal alta', 'EGR - high signal'),
    'P0491': (
      'Sistema inyección aire secundario (bloque 1) - defectuoso',
      'Secondary air injection system (bank 1) - faulty',
    ),
    'P0492': (
      'Sistema inyección aire secundario (bloque 2) - defectuoso',
      'Secondary air injection system (bank 2) - faulty',
    ),
    'P0493': (
      'Sobrevelocidad ventilador (embrague bloqueado)',
      'Fan overspeed (clutch locked)',
    ),
    'P0494': ('Velocidad ventilador baja', 'Fan speed low'),
    'P0495': ('Velocidad ventilador alta', 'Fan speed high'),
    'P0496': (
      'Sistema emisiones evaporativas - flujo purga alto',
      'EVAP emission system - high purge flow',
    ),
    'P0497': (
      'Sistema emisiones evaporativas - flujo purga bajo',
      'EVAP emission system - low purge flow',
    ),
    'P0498': (
      'Control ventilación emisiones evaporativas - señal baja',
      'EVAP vent control - low signal',
    ),
    'P0499': (
      'Control ventilación emisiones evaporativas - señal alta',
      'EVAP vent control - high signal',
    ),
    'P0500': (
      'Sensor velocidad vehículo - circuito defectuoso',
      'Vehicle speed sensor - faulty circuit',
    ),
    'P0501': (
      'Sensor velocidad vehículo - rango, funcionamiento',
      'Vehicle speed sensor - range/performance',
    ),
    'P0502': (
      'Sensor velocidad vehículo - señal baja',
      'Vehicle speed sensor - low signal',
    ),
    'P0503': (
      'Sensor velocidad vehículo - interrupción intermitente/señal alta',
      'Vehicle speed sensor - intermittent/high signal',
    ),
    'P0504': (
      'Interruptor freno A/B - correlación',
      'Brake switch A/B - correlation',
    ),
    'P0505': (
      'Control ralentí - circuito defectuoso',
      'Idle control system - faulty circuit',
    ),
    'P0506': (
      'Control ralentí - RPM por debajo del esperado',
      'Idle control system - RPM below expected',
    ),
    'P0507': (
      'Control ralentí - RPM por encima del esperado',
      'Idle control system - RPM above expected',
    ),
    'P0508': (
      'Control ralentí - señal baja',
      'Idle control system - low signal',
    ),
    'P0509': (
      'Control ralentí - señal alta',
      'Idle control system - high signal',
    ),
    'P0510': (
      'Sensor posición mariposa cerrada - circuito defectuoso',
      'Closed throttle position sensor - faulty circuit',
    ),
    'P0511': (
      'Control ralentí - circuito abierto',
      'Idle control - open circuit',
    ),
    'P0512': (
      'Solicitud arranque motor - circuito defectuoso',
      'Starter request circuit - faulty',
    ),
    'P0513': ('Llave inmovilizador incorrecta', 'Incorrect immobilizer key'),
    'P0514': (
      'Sensor temperatura batería - rango, funcionamiento',
      'Battery temperature sensor - range/performance',
    ),
    'P0515': (
      'Sensor temperatura batería - circuito defectuoso',
      'Battery temperature sensor - faulty circuit',
    ),
    'P0516': (
      'Sensor temperatura batería - señal baja',
      'Battery temperature sensor - low signal',
    ),
    'P0517': (
      'Sensor temperatura batería - señal alta',
      'Battery temperature sensor - high signal',
    ),
    'P0518': (
      'Control ralentí - circuito interrupción intermitente',
      'Idle control - intermittent circuit',
    ),
    'P0519': ('Control ralentí - funcionamiento', 'Idle control - performance'),
    'P0520': (
      'Sensor presión aceite motor - circuito defectuoso',
      'Engine oil pressure sensor - faulty circuit',
    ),
    'P0521': (
      'Sensor presión aceite motor - rango, funcionamiento',
      'Engine oil pressure sensor - range/performance',
    ),
    'P0522': (
      'Sensor presión aceite motor - señal baja',
      'Engine oil pressure sensor - low signal',
    ),
    'P0523': (
      'Sensor presión aceite motor - señal alta',
      'Engine oil pressure sensor - high signal',
    ),
    'P0524': (
      'Presión aceite motor demasiado baja',
      'Engine oil pressure too low',
    ),
    'P0525': (
      'Control velocidad crucero - rango, funcionamiento servo',
      'Cruise control - servo range/performance',
    ),
    'P0526': (
      'Sensor velocidad ventilador refrigeración - circuito defectuoso',
      'Cooling fan speed sensor - faulty circuit',
    ),
    'P0527': (
      'Sensor velocidad ventilador refrigeración - rango, funcionamiento',
      'Cooling fan speed sensor - range/performance',
    ),
    'P0528': (
      'Sensor velocidad ventilador refrigeración - sin señal',
      'Cooling fan speed sensor - no signal',
    ),
    'P0529': (
      'Sensor velocidad ventilador refrigeración - interrupción intermitente',
      'Cooling fan speed sensor - intermittent',
    ),
    'P0530': (
      'Sensor presión refrigerante A/C - circuito defectuoso',
      'A/C refrigerant pressure sensor - faulty circuit',
    ),
    'P0531': (
      'Sensor presión refrigerante A/C - rango, funcionamiento',
      'A/C refrigerant pressure sensor - range/performance',
    ),
    'P0532': (
      'Sensor presión refrigerante A/C - señal baja',
      'A/C refrigerant pressure sensor - low signal',
    ),
    'P0533': (
      'Sensor presión refrigerante A/C - señal alta',
      'A/C refrigerant pressure sensor - high signal',
    ),
    'P0534': (
      'Pérdida carga refrigerante aire acondicionado',
      'A/C refrigerant charge loss',
    ),
    'P0535': (
      'Sensor temperatura evaporador A/C - circuito defectuoso',
      'A/C evaporator temperature sensor - faulty circuit',
    ),
    'P0536': (
      'Sensor temperatura evaporador A/C - rango, funcionamiento',
      'A/C evaporator temperature sensor - range/performance',
    ),
    'P0537': (
      'Sensor temperatura evaporador A/C - señal baja',
      'A/C evaporator temperature sensor - low signal',
    ),
    'P0538': (
      'Sensor temperatura evaporador A/C - señal alta',
      'A/C evaporator temperature sensor - high signal',
    ),
    'P0539': (
      'Sensor temperatura evaporador A/C - interrupción intermitente',
      'A/C evaporator temperature sensor - intermittent',
    ),
    'P0540': (
      'Calentador aire admisión A - circuito defectuoso',
      'Intake air heater A - faulty circuit',
    ),
    'P0541': (
      'Calentador aire admisión A - señal baja',
      'Intake air heater A - low signal',
    ),
    'P0542': (
      'Calentador aire admisión A - señal alta',
      'Intake air heater A - high signal',
    ),
    'P0543': (
      'Calentador aire admisión A - circuito abierto',
      'Intake air heater A - open circuit',
    ),
    'P0544': (
      'Sensor temperatura gases escape (bloque 1 sensor 1) - circuito defectuoso',
      'Exhaust gas temperature sensor (bank 1 sensor 1) - faulty circuit',
    ),
    'P0545': (
      'Sensor temperatura gases escape (bloque 1 sensor 1) - señal baja',
      'Exhaust gas temperature sensor (bank 1 sensor 1) - low signal',
    ),
    'P0546': (
      'Sensor temperatura gases escape (bloque 1 sensor 1) - señal alta',
      'Exhaust gas temperature sensor (bank 1 sensor 1) - high signal',
    ),
    'P0547': (
      'Sensor temperatura gases escape (bloque 1 sensor 2) - circuito defectuoso',
      'Exhaust gas temperature sensor (bank 1 sensor 2) - faulty circuit',
    ),
    'P0548': (
      'Sensor temperatura gases escape (bloque 1 sensor 2) - señal baja',
      'Exhaust gas temperature sensor (bank 1 sensor 2) - low signal',
    ),
    'P0549': (
      'Sensor temperatura gases escape (bloque 1 sensor 2) - señal alta',
      'Exhaust gas temperature sensor (bank 1 sensor 2) - high signal',
    ),
    'P0550': (
      'Sensor presión dirección asistida - circuito defectuoso',
      'Power steering pressure sensor - faulty circuit',
    ),
    'P0551': (
      'Sensor presión dirección asistida - rango, funcionamiento',
      'Power steering pressure sensor - range/performance',
    ),
    'P0552': (
      'Sensor presión dirección asistida - señal baja',
      'Power steering pressure sensor - low signal',
    ),
    'P0553': (
      'Sensor presión dirección asistida - señal alta',
      'Power steering pressure sensor - high signal',
    ),
    'P0554': (
      'Sensor presión dirección asistida - interrupción intermitente',
      'Power steering pressure sensor - intermittent',
    ),
    'P0555': (
      'Sensor presión servofreno - circuito defectuoso',
      'Brake booster pressure sensor - faulty circuit',
    ),
    'P0556': (
      'Sensor presión servofreno - rango, funcionamiento',
      'Brake booster pressure sensor - range/performance',
    ),
    'P0557': (
      'Sensor presión servofreno - señal baja',
      'Brake booster pressure sensor - low signal',
    ),
    'P0558': (
      'Sensor presión servofreno - señal alta',
      'Brake booster pressure sensor - high signal',
    ),
    'P0559': (
      'Sensor presión servofreno - interrupción intermitente',
      'Brake booster pressure sensor - intermittent',
    ),
    'P0560': (
      'Tensión sistema - circuito defectuoso',
      'System voltage - faulty circuit',
    ),
    'P0561': ('Tensión sistema - inestable', 'System voltage - unstable'),
    'P0562': ('Tensión sistema - baja', 'System voltage - low'),
    'P0563': ('Tensión sistema - alta', 'System voltage - high'),
    'P0564': (
      'Control velocidad crucero - señal entrada múltiple',
      'Cruise control - multi-function input signal',
    ),
    'P0565': (
      'Señal activación control velocidad crucero - circuito defectuoso',
      'Cruise control on signal - faulty circuit',
    ),
    'P0566': (
      'Señal desactivación control velocidad crucero - circuito defectuoso',
      'Cruise control off signal - faulty circuit',
    ),
    'P0567': (
      'Señal reanudación control velocidad crucero - circuito defectuoso',
      'Cruise control resume signal - faulty circuit',
    ),
    'P0568': (
      'Señal ajuste velocidad crucero - circuito defectuoso',
      'Cruise control set signal - faulty circuit',
    ),
    'P0569': (
      'Señal desaceleración control velocidad crucero - circuito defectuoso',
      'Cruise control coast signal - faulty circuit',
    ),
    'P0570': (
      'Señal aceleración control velocidad crucero - circuito defectuoso',
      'Cruise control accel signal - faulty circuit',
    ),
    'P0571': (
      'Interruptor freno control velocidad crucero A - circuito defectuoso',
      'Cruise control brake switch A - faulty circuit',
    ),
    'P0572': (
      'Interruptor freno control velocidad crucero A - señal baja',
      'Cruise control brake switch A - low signal',
    ),
    'P0573': (
      'Interruptor freno control velocidad crucero A - señal alta',
      'Cruise control brake switch A - high signal',
    ),
    'P0574': (
      'Control velocidad crucero - velocidad vehículo demasiado alta',
      'Cruise control - vehicle speed too high',
    ),
    'P0575': (
      'Control velocidad crucero - circuito entrada defectuoso',
      'Cruise control - input circuit fault',
    ),
    'P0576': (
      'Control velocidad crucero - circuito entrada señal baja',
      'Cruise control - input circuit low signal',
    ),
    'P0577': (
      'Control velocidad crucero - circuito entrada señal alta',
      'Cruise control - input circuit high signal',
    ),
    'P0578': (
      'Control velocidad crucero - entrada múltiple atascada',
      'Cruise control - multi-function input stuck',
    ),
    'P0579': (
      'Control velocidad crucero - rango, funcionamiento entrada múltiple',
      'Cruise control - multi-function input range/performance',
    ),
    'P0580': (
      'Control velocidad crucero - circuito entrada múltiple señal baja',
      'Cruise control - multi-function input low signal',
    ),
    'P0581': (
      'Control velocidad crucero - circuito entrada múltiple señal alta',
      'Cruise control - multi-function input high signal',
    ),
    'P0582': (
      'Control velocidad crucero - circuito vacío defectuoso',
      'Cruise control - vacuum circuit fault',
    ),
    'P0583': (
      'Control velocidad crucero - circuito ventilación defectuoso',
      'Cruise control - vent circuit fault',
    ),
    'P0584': (
      'Control velocidad crucero - velocidad vehículo demasiado baja',
      'Cruise control - vehicle speed too low',
    ),
    'P0585': (
      'Correlación señales A/B control velocidad crucero',
      'Cruise control A/B signal correlation',
    ),
    'P0586': (
      'Circuito control ventilador refrigeración - señal baja',
      'Cooling fan control circuit - low signal',
    ),
    'P0587': (
      'Control calentador termostato - señal baja',
      'Thermostat heater control - low signal',
    ),
    'P0588': (
      'Control calentador termostato - señal alta',
      'Thermostat heater control - high signal',
    ),
    'P0589': (
      'Control calentador termostato - circuito abierto',
      'Thermostat heater control - open circuit',
    ),
    'P0590': (
      'Control velocidad crucero - interruptor atascado',
      'Cruise control - switch stuck',
    ),
    'P0591': (
      'Control velocidad crucero - señal entrada múltiple B - rango, funcionamiento',
      'Cruise control - multi-function input B - range/performance',
    ),
    'P0592': (
      'Control velocidad crucero - señal entrada múltiple B - señal baja',
      'Cruise control - multi-function input B - low signal',
    ),
    'P0593': (
      'Control velocidad crucero - señal entrada múltiple B - señal alta',
      'Cruise control - multi-function input B - high signal',
    ),
    'P0594': (
      'Servo control velocidad crucero - circuito abierto',
      'Cruise control servo - open circuit',
    ),
    'P0595': (
      'Servo control velocidad crucero - señal baja',
      'Cruise control servo - low signal',
    ),
    'P0596': (
      'Servo control velocidad crucero - señal alta',
      'Cruise control servo - high signal',
    ),
    'P0597': (
      'Control calentador termostato - circuito abierto',
      'Thermostat heater control - open circuit',
    ),
    'P0598': (
      'Control calentador termostato - señal baja',
      'Thermostat heater control - low signal',
    ),
    'P0599': (
      'Control calentador termostato - señal alta',
      'Thermostat heater control - high signal',
    ),
    'P0600': ('Bus de datos CAN - defectuoso', 'CAN data bus - faulty'),
    'P0601': (
      'Módulo control motor (ECM/PCM) - error memoria',
      'Engine control module (ECM/PCM) - memory error',
    ),
    'P0602': (
      'Módulo control motor (ECM/PCM) - error programación',
      'Engine control module (ECM/PCM) - programming error',
    ),
    'P0603': (
      'Módulo control motor (ECM/PCM) - error memoria KAM',
      'Engine control module (ECM/PCM) - KAM memory error',
    ),
    'P0604': (
      'Módulo control motor (ECM/PCM) - error memoria RAM',
      'Engine control module (ECM/PCM) - RAM memory error',
    ),
    'P0605': (
      'Módulo control motor (ECM/PCM) - error memoria ROM',
      'Engine control module (ECM/PCM) - ROM memory error',
    ),
    'P0606': (
      'Módulo control motor (ECM/PCM) - error procesador',
      'Engine control module (ECM/PCM) - processor error',
    ),
    'P0607': (
      'Módulo control motor - rendimiento',
      'Engine control module - performance',
    ),
    'P0608': (
      'Módulo control motor - sensor velocidad vehículo salida A',
      'Engine control module - vehicle speed sensor output A',
    ),
    'P0609': (
      'Módulo control motor - sensor velocidad vehículo salida B',
      'Engine control module - vehicle speed sensor output B',
    ),
    'P0610': (
      'Módulo control motor - error opciones vehículo',
      'Engine control module - vehicle options error',
    ),
    'P0611': (
      'Control módulo inyector combustible - rendimiento',
      'Fuel injector control module - performance',
    ),
    'P0612': (
      'Control relé inyector combustible - circuito defectuoso',
      'Fuel injector relay control - faulty circuit',
    ),
    'P0613': (
      'Módulo control transmisión (TCM) - error procesador',
      'Transmission control module (TCM) - processor error',
    ),
    'P0614': ('ECM/TCM - incompatibilidad', 'ECM/TCM - incompatibility'),
    'P0615': (
      'Relé motor arranque - circuito defectuoso',
      'Starter relay - faulty circuit',
    ),
    'P0616': ('Relé motor arranque - señal baja', 'Starter relay - low signal'),
    'P0617': (
      'Relé motor arranque - señal alta',
      'Starter relay - high signal',
    ),
    'P0618': (
      'Módulo control combustible alternativo - error memoria KAM',
      'Alternative fuel control module - KAM memory error',
    ),
    'P0619': (
      'Módulo control combustible alternativo - error memoria RAM/ROM',
      'Alternative fuel control module - RAM/ROM memory error',
    ),
    'P0620': (
      'Control alternador - circuito defectuoso',
      'Alternator control - faulty circuit',
    ),
    'P0621': (
      'Lámpara carga alternador - circuito defectuoso',
      'Alternator charge lamp - faulty circuit',
    ),
    'P0622': (
      'Campo alternador - circuito defectuoso',
      'Alternator field - faulty circuit',
    ),
    'P0623': (
      'Control bomba combustible - circuito defectuoso',
      'Fuel pump control - faulty circuit',
    ),
    'P0624': (
      'Control lámpara tapón combustible - circuito defectuoso',
      'Fuel cap lamp control - faulty circuit',
    ),
    'P0625': ('Campo alternador - señal baja', 'Alternator field - low signal'),
    'P0626': (
      'Campo alternador - señal alta',
      'Alternator field - high signal',
    ),
    'P0627': (
      'Control bomba combustible A - circuito abierto',
      'Fuel pump A control - open circuit',
    ),
    'P0628': (
      'Control bomba combustible A - señal baja',
      'Fuel pump A control - low signal',
    ),
    'P0629': (
      'Control bomba combustible A - señal alta',
      'Fuel pump A control - high signal',
    ),
    'P0630': (
      'Número VIN no programado o incompatible - ECM/PCM',
      'VIN not programmed or incompatible - ECM/PCM',
    ),
    'P0631': (
      'Número VIN no programado o incompatible - TCM',
      'VIN not programmed or incompatible - TCM',
    ),
    'P0632': (
      'Odómetro no programado - ECM/PCM',
      'Odometer not programmed - ECM/PCM',
    ),
    'P0633': (
      'Llave inmovilizador no programada - ECM/PCM',
      'Immobilizer key not programmed - ECM/PCM',
    ),
    'P0634': (
      'Temperatura interna ECM/PCM demasiado alta',
      'ECM/PCM internal temperature too high',
    ),
    'P0635': (
      'Circuito control dirección asistida - defectuoso',
      'Power steering control circuit - faulty',
    ),
    'P0636': (
      'Circuito control dirección asistida - señal baja',
      'Power steering control circuit - low signal',
    ),
    'P0637': (
      'Circuito control dirección asistida - señal alta',
      'Power steering control circuit - high signal',
    ),
    'P0638': (
      'Control actuador mariposa (bloque 1) - rango, funcionamiento',
      'Throttle actuator control (bank 1) - range/performance',
    ),
    'P0639': (
      'Control actuador mariposa (bloque 2) - rango, funcionamiento',
      'Throttle actuator control (bank 2) - range/performance',
    ),
    'P0640': (
      'Control calentador aire admisión - circuito defectuoso',
      'Intake air heater control - faulty circuit',
    ),
    'P0641': (
      'Circuito referencia tensión sensor A - abierto',
      'Sensor reference voltage A circuit - open',
    ),
    'P0642': (
      'Circuito referencia tensión sensor A - señal baja',
      'Sensor reference voltage A circuit - low signal',
    ),
    'P0643': (
      'Circuito referencia tensión sensor A - señal alta',
      'Sensor reference voltage A circuit - high signal',
    ),
    'P0644': (
      'Pantalla conductor - circuito comunicación serie',
      'Driver display - serial communication circuit',
    ),
    'P0645': (
      'Relé embrague A/C - circuito defectuoso',
      'A/C clutch relay - faulty circuit',
    ),
    'P0646': (
      'Relé embrague A/C - señal baja',
      'A/C clutch relay - low signal',
    ),
    'P0647': (
      'Relé embrague A/C - señal alta',
      'A/C clutch relay - high signal',
    ),
    'P0648': (
      'Lámpara control inmovilizador - circuito defectuoso',
      'Immobilizer control lamp - faulty circuit',
    ),
    'P0649': (
      'Lámpara control velocidad crucero - circuito defectuoso',
      'Cruise control lamp - faulty circuit',
    ),
    'P0650': (
      'Lámpara indicadora avería (MIL) - circuito defectuoso',
      'Malfunction indicator lamp (MIL) - faulty circuit',
    ),
    'P0651': (
      'Circuito referencia tensión sensor B - abierto',
      'Sensor reference voltage B circuit - open',
    ),
    'P0652': (
      'Circuito referencia tensión sensor B - señal baja',
      'Sensor reference voltage B circuit - low signal',
    ),
    'P0653': (
      'Circuito referencia tensión sensor B - señal alta',
      'Sensor reference voltage B circuit - high signal',
    ),
    'P0654': (
      'RPM motor - circuito salida defectuoso',
      'Engine RPM - output circuit fault',
    ),
    'P0655': (
      'Lámpara sobrecalentamiento motor - circuito defectuoso',
      'Engine overheating lamp - faulty circuit',
    ),
    'P0656': (
      'Indicador nivel combustible - circuito defectuoso',
      'Fuel level indicator - faulty circuit',
    ),
    'P0657': (
      'Circuito alimentación actuador A - abierto',
      'Actuator supply voltage A circuit - open',
    ),
    'P0658': (
      'Circuito alimentación actuador A - señal baja',
      'Actuator supply voltage A circuit - low signal',
    ),
    'P0659': (
      'Circuito alimentación actuador A - señal alta',
      'Actuator supply voltage A circuit - high signal',
    ),
    'P0660': (
      'Control válvula colector admisión - circuito defectuoso (bloque 1)',
      'Intake manifold runner control circuit - faulty (bank 1)',
    ),
    'P0661': (
      'Control válvula colector admisión (bloque 1) - señal baja',
      'Intake manifold runner control (bank 1) - low signal',
    ),
    'P0662': (
      'Control válvula colector admisión (bloque 1) - señal alta',
      'Intake manifold runner control (bank 1) - high signal',
    ),
    'P0663': (
      'Control válvula colector admisión - circuito defectuoso (bloque 2)',
      'Intake manifold runner control circuit - faulty (bank 2)',
    ),
    'P0664': (
      'Control válvula colector admisión (bloque 2) - señal baja',
      'Intake manifold runner control (bank 2) - low signal',
    ),
    'P0665': (
      'Control válvula colector admisión (bloque 2) - señal alta',
      'Intake manifold runner control (bank 2) - high signal',
    ),
    'P0666': (
      'Sensor temperatura interna ECM/PCM - circuito defectuoso',
      'ECM/PCM internal temperature sensor - faulty circuit',
    ),
    'P0667': (
      'Sensor temperatura interna ECM/PCM - rango, funcionamiento',
      'ECM/PCM internal temperature sensor - range/performance',
    ),
    'P0668': (
      'Sensor temperatura interna ECM/PCM - señal baja',
      'ECM/PCM internal temperature sensor - low signal',
    ),
    'P0669': (
      'Sensor temperatura interna ECM/PCM - señal alta',
      'ECM/PCM internal temperature sensor - high signal',
    ),
    'P0670': (
      'Módulo control bujías incandescentes - circuito defectuoso',
      'Glow plug control module - faulty circuit',
    ),
    'P0671': (
      'Bujía incandescente cilindro 1 - circuito defectuoso',
      'Glow plug cylinder 1 - faulty circuit',
    ),
    'P0672': (
      'Bujía incandescente cilindro 2 - circuito defectuoso',
      'Glow plug cylinder 2 - faulty circuit',
    ),
    'P0673': (
      'Bujía incandescente cilindro 3 - circuito defectuoso',
      'Glow plug cylinder 3 - faulty circuit',
    ),
    'P0674': (
      'Bujía incandescente cilindro 4 - circuito defectuoso',
      'Glow plug cylinder 4 - faulty circuit',
    ),
    'P0675': (
      'Bujía incandescente cilindro 5 - circuito defectuoso',
      'Glow plug cylinder 5 - faulty circuit',
    ),
    'P0676': (
      'Bujía incandescente cilindro 6 - circuito defectuoso',
      'Glow plug cylinder 6 - faulty circuit',
    ),
    'P0677': (
      'Bujía incandescente cilindro 7 - circuito defectuoso',
      'Glow plug cylinder 7 - faulty circuit',
    ),
    'P0678': (
      'Bujía incandescente cilindro 8 - circuito defectuoso',
      'Glow plug cylinder 8 - faulty circuit',
    ),
    'P0679': (
      'Bujía incandescente cilindro 9 - circuito defectuoso',
      'Glow plug cylinder 9 - faulty circuit',
    ),
    'P0680': (
      'Bujía incandescente cilindro 10 - circuito defectuoso',
      'Glow plug cylinder 10 - faulty circuit',
    ),
    'P0681': (
      'Bujía incandescente cilindro 11 - circuito defectuoso',
      'Glow plug cylinder 11 - faulty circuit',
    ),
    'P0682': (
      'Bujía incandescente cilindro 12 - circuito defectuoso',
      'Glow plug cylinder 12 - faulty circuit',
    ),
    'P0683': (
      'Comunicación módulo control bujías incandescentes - ECM/PCM',
      'Glow plug control module communication - ECM/PCM',
    ),
    'P0684': (
      'Comunicación módulo control bujías incandescentes - rango, funcionamiento',
      'Glow plug control module communication - range/performance',
    ),
    'P0685': (
      'Relé alimentación ECM/PCM - circuito abierto',
      'ECM/PCM power relay - open circuit',
    ),
    'P0686': (
      'Relé alimentación ECM/PCM - señal baja',
      'ECM/PCM power relay - low signal',
    ),
    'P0687': (
      'Relé alimentación ECM/PCM - señal alta',
      'ECM/PCM power relay - high signal',
    ),
    'P0688': (
      'Relé alimentación ECM/PCM - sentido señal baja',
      'ECM/PCM power relay - sense low signal',
    ),
    'P0689': (
      'Relé alimentación ECM/PCM - sentido señal alta',
      'ECM/PCM power relay - sense high signal',
    ),
    'P0690': (
      'Relé alimentación ECM/PCM - sentido circuito abierto',
      'ECM/PCM power relay - sense open circuit',
    ),
    'P0691': (
      'Ventilador refrigeración 1 - señal baja',
      'Cooling fan 1 - low signal',
    ),
    'P0692': (
      'Ventilador refrigeración 1 - señal alta',
      'Cooling fan 1 - high signal',
    ),
    'P0693': (
      'Ventilador refrigeración 2 - señal baja',
      'Cooling fan 2 - low signal',
    ),
    'P0694': (
      'Ventilador refrigeración 2 - señal alta',
      'Cooling fan 2 - high signal',
    ),
    'P0695': (
      'Ventilador refrigeración 3 - señal baja',
      'Cooling fan 3 - low signal',
    ),
    'P0696': (
      'Ventilador refrigeración 3 - señal alta',
      'Cooling fan 3 - high signal',
    ),
    'P0697': (
      'Circuito referencia tensión sensor C - abierto',
      'Sensor reference voltage C circuit - open',
    ),
    'P0698': (
      'Circuito referencia tensión sensor C - señal baja',
      'Sensor reference voltage C circuit - low signal',
    ),
    'P0699': (
      'Circuito referencia tensión sensor C - señal alta',
      'Sensor reference voltage C circuit - high signal',
    ),
    'P0700': (
      'Sistema control transmisión - defectuoso',
      'Transmission control system - faulty',
    ),
    'P0701': (
      'Sistema control transmisión - rango, funcionamiento',
      'Transmission control system - range/performance',
    ),
    'P0702': (
      'Sistema control transmisión - eléctrico',
      'Transmission control system - electrical',
    ),
    'P0703': (
      'Interruptor freno B - circuito defectuoso',
      'Brake switch B - faulty circuit',
    ),
    'P0704': (
      'Interruptor embrague - circuito defectuoso',
      'Clutch switch - faulty circuit',
    ),
    'P0705': (
      'Sensor rango transmisión - circuito defectuoso (entrada PRNDL)',
      'Transmission range sensor - faulty circuit (PRNDL input)',
    ),
    'P0706': (
      'Sensor rango transmisión - rango, funcionamiento',
      'Transmission range sensor - range/performance',
    ),
    'P0707': (
      'Sensor rango transmisión - señal baja',
      'Transmission range sensor - low signal',
    ),
    'P0708': (
      'Sensor rango transmisión - señal alta',
      'Transmission range sensor - high signal',
    ),
    'P0709': (
      'Sensor rango transmisión - interrupción intermitente',
      'Transmission range sensor - intermittent',
    ),
    'P0710': (
      'Sensor temperatura aceite transmisión - circuito defectuoso',
      'Transmission oil temperature sensor - faulty circuit',
    ),
    'P0711': (
      'Sensor temperatura aceite transmisión - rango, funcionamiento',
      'Transmission oil temperature sensor - range/performance',
    ),
    'P0712': (
      'Sensor temperatura aceite transmisión - señal baja',
      'Transmission oil temperature sensor - low signal',
    ),
    'P0713': (
      'Sensor temperatura aceite transmisión - señal alta',
      'Transmission oil temperature sensor - high signal',
    ),
    'P0714': (
      'Sensor temperatura aceite transmisión - interrupción intermitente',
      'Transmission oil temperature sensor - intermittent',
    ),
    'P0715': (
      'Sensor velocidad turbina/entrada transmisión - circuito defectuoso',
      'Turbine/input shaft speed sensor - faulty circuit',
    ),
    'P0716': (
      'Sensor velocidad turbina/entrada transmisión - rango, funcionamiento',
      'Turbine/input shaft speed sensor - range/performance',
    ),
    'P0717': (
      'Sensor velocidad turbina/entrada transmisión - sin señal',
      'Turbine/input shaft speed sensor - no signal',
    ),
    'P0718': (
      'Sensor velocidad turbina/entrada transmisión - interrupción intermitente',
      'Turbine/input shaft speed sensor - intermittent',
    ),
    'P0719': (
      'Interruptor freno B - señal baja',
      'Brake switch B - low signal',
    ),
    'P0720': (
      'Sensor velocidad salida transmisión - circuito defectuoso',
      'Output shaft speed sensor - faulty circuit',
    ),
    'P0721': (
      'Sensor velocidad salida transmisión - rango, funcionamiento',
      'Output shaft speed sensor - range/performance',
    ),
    'P0722': (
      'Sensor velocidad salida transmisión - sin señal',
      'Output shaft speed sensor - no signal',
    ),
    'P0723': (
      'Sensor velocidad salida transmisión - interrupción intermitente',
      'Output shaft speed sensor - intermittent',
    ),
    'P0724': (
      'Interruptor freno B - señal alta',
      'Brake switch B - high signal',
    ),
    'P0725': (
      'Señal entrada velocidad motor - circuito defectuoso',
      'Engine speed input signal - faulty circuit',
    ),
    'P0726': (
      'Señal entrada velocidad motor - rango, funcionamiento',
      'Engine speed input signal - range/performance',
    ),
    'P0727': (
      'Señal entrada velocidad motor - sin señal',
      'Engine speed input signal - no signal',
    ),
    'P0728': (
      'Señal entrada velocidad motor - interrupción intermitente',
      'Engine speed input signal - intermittent',
    ),
    'P0729': ('Relación 6ª marcha - incorrecta', '6th gear ratio - incorrect'),
    'P0730': ('Relación de marcha - incorrecta', 'Gear ratio - incorrect'),
    'P0731': ('Relación 1ª marcha - incorrecta', '1st gear ratio - incorrect'),
    'P0732': ('Relación 2ª marcha - incorrecta', '2nd gear ratio - incorrect'),
    'P0733': ('Relación 3ª marcha - incorrecta', '3rd gear ratio - incorrect'),
    'P0734': ('Relación 4ª marcha - incorrecta', '4th gear ratio - incorrect'),
    'P0735': ('Relación 5ª marcha - incorrecta', '5th gear ratio - incorrect'),
    'P0736': (
      'Relación marcha atrás - incorrecta',
      'Reverse gear ratio - incorrect',
    ),
    'P0737': (
      'Velocidad salida TCM - circuito defectuoso',
      'TCM output speed - faulty circuit',
    ),
    'P0738': (
      'Velocidad salida TCM - señal baja',
      'TCM output speed - low signal',
    ),
    'P0739': (
      'Velocidad salida TCM - señal alta',
      'TCM output speed - high signal',
    ),
    'P0740': (
      'Embrague convertidor par - circuito defectuoso',
      'Torque converter clutch - faulty circuit',
    ),
    'P0741': (
      'Embrague convertidor par - rendimiento o atascado desactivado',
      'Torque converter clutch - performance or stuck off',
    ),
    'P0742': (
      'Embrague convertidor par - atascado activado',
      'Torque converter clutch - stuck on',
    ),
    'P0743': (
      'Embrague convertidor par - eléctrico',
      'Torque converter clutch - electrical',
    ),
    'P0744': (
      'Embrague convertidor par - interrupción intermitente',
      'Torque converter clutch - intermittent',
    ),
    'P0745': (
      'Solenoide presión transmisión A - circuito defectuoso',
      'Transmission pressure solenoid A - faulty circuit',
    ),
    'P0746': (
      'Solenoide presión transmisión A - rendimiento o atascado desactivado',
      'Transmission pressure solenoid A - performance or stuck off',
    ),
    'P0747': (
      'Solenoide presión transmisión A - atascado activado',
      'Transmission pressure solenoid A - stuck on',
    ),
    'P0748': (
      'Solenoide presión transmisión A - eléctrico',
      'Transmission pressure solenoid A - electrical',
    ),
    'P0749': (
      'Solenoide presión transmisión A - interrupción intermitente',
      'Transmission pressure solenoid A - intermittent',
    ),
    'P0750': (
      'Solenoide cambio A - circuito defectuoso',
      'Shift solenoid A - faulty circuit',
    ),
    'P0751': (
      'Solenoide cambio A - rendimiento o atascado desactivado',
      'Shift solenoid A - performance or stuck off',
    ),
    'P0752': (
      'Solenoide cambio A - atascado activado',
      'Shift solenoid A - stuck on',
    ),
    'P0753': (
      'Solenoide cambio A - eléctrico',
      'Shift solenoid A - electrical',
    ),
    'P0754': (
      'Solenoide cambio A - interrupción intermitente',
      'Shift solenoid A - intermittent',
    ),
    'P0755': (
      'Solenoide cambio B - circuito defectuoso',
      'Shift solenoid B - faulty circuit',
    ),
    'P0756': (
      'Solenoide cambio B - rendimiento o atascado desactivado',
      'Shift solenoid B - performance or stuck off',
    ),
    'P0757': (
      'Solenoide cambio B - atascado activado',
      'Shift solenoid B - stuck on',
    ),
    'P0758': (
      'Solenoide cambio B - eléctrico',
      'Shift solenoid B - electrical',
    ),
    'P0759': (
      'Solenoide cambio B - interrupción intermitente',
      'Shift solenoid B - intermittent',
    ),
    'P0760': (
      'Solenoide cambio C - circuito defectuoso',
      'Shift solenoid C - faulty circuit',
    ),
    'P0761': (
      'Solenoide cambio C - rendimiento o atascado desactivado',
      'Shift solenoid C - performance or stuck off',
    ),
    'P0762': (
      'Solenoide cambio C - atascado activado',
      'Shift solenoid C - stuck on',
    ),
    'P0763': (
      'Solenoide cambio C - eléctrico',
      'Shift solenoid C - electrical',
    ),
    'P0764': (
      'Solenoide cambio C - interrupción intermitente',
      'Shift solenoid C - intermittent',
    ),
    'P0765': (
      'Solenoide cambio D - circuito defectuoso',
      'Shift solenoid D - faulty circuit',
    ),
    'P0766': (
      'Solenoide cambio D - rendimiento o atascado desactivado',
      'Shift solenoid D - performance or stuck off',
    ),
    'P0767': (
      'Solenoide cambio D - atascado activado',
      'Shift solenoid D - stuck on',
    ),
    'P0768': (
      'Solenoide cambio D - eléctrico',
      'Shift solenoid D - electrical',
    ),
    'P0769': (
      'Solenoide cambio D - interrupción intermitente',
      'Shift solenoid D - intermittent',
    ),
    'P0770': (
      'Solenoide cambio E - circuito defectuoso',
      'Shift solenoid E - faulty circuit',
    ),
    'P0771': (
      'Solenoide cambio E - rendimiento o atascado desactivado',
      'Shift solenoid E - performance or stuck off',
    ),
    'P0772': (
      'Solenoide cambio E - atascado activado',
      'Shift solenoid E - stuck on',
    ),
    'P0773': (
      'Solenoide cambio E - eléctrico',
      'Shift solenoid E - electrical',
    ),
    'P0774': (
      'Solenoide cambio E - interrupción intermitente',
      'Shift solenoid E - intermittent',
    ),
    'P0775': (
      'Solenoide control presión B - circuito defectuoso',
      'Pressure control solenoid B - faulty circuit',
    ),
    'P0776': (
      'Solenoide control presión B - rendimiento o atascado desactivado',
      'Pressure control solenoid B - performance or stuck off',
    ),
    'P0777': (
      'Solenoide control presión B - atascado activado',
      'Pressure control solenoid B - stuck on',
    ),
    'P0778': (
      'Solenoide control presión B - eléctrico',
      'Pressure control solenoid B - electrical',
    ),
    'P0779': (
      'Solenoide control presión B - interrupción intermitente',
      'Pressure control solenoid B - intermittent',
    ),
    'P0780': ('Cambio de marcha - defectuoso', 'Shift malfunction'),
    'P0781': ('Selección marcha 1-2 - defectuoso', '1-2 shift malfunction'),
    'P0782': ('Selección marcha 2-3 - defectuoso', '2-3 shift malfunction'),
    'P0783': ('Selección marcha 3-4 - defectuoso', '3-4 shift malfunction'),
    'P0784': ('Selección marcha 4-5 - defectuoso', '4-5 shift malfunction'),
    'P0785': (
      'Solenoide temporización cambio - circuito defectuoso',
      'Shift timing solenoid - faulty circuit',
    ),
    'P0786': (
      'Solenoide temporización cambio - rango, funcionamiento',
      'Shift timing solenoid - range/performance',
    ),
    'P0787': (
      'Solenoide temporización cambio - señal baja',
      'Shift timing solenoid - low signal',
    ),
    'P0788': (
      'Solenoide temporización cambio - señal alta',
      'Shift timing solenoid - high signal',
    ),
    'P0789': (
      'Solenoide temporización cambio - interrupción intermitente',
      'Shift timing solenoid - intermittent',
    ),
    'P0790': (
      'Interruptor modo normal/rendimiento - circuito defectuoso',
      'Normal/performance mode switch - faulty circuit',
    ),
    'P0791': (
      'Sensor velocidad eje intermedio - circuito defectuoso',
      'Intermediate shaft speed sensor - faulty circuit',
    ),
    'P0792': (
      'Sensor velocidad eje intermedio - rango, funcionamiento',
      'Intermediate shaft speed sensor - range/performance',
    ),
    'P0793': (
      'Sensor velocidad eje intermedio - sin señal',
      'Intermediate shaft speed sensor - no signal',
    ),
    'P0794': (
      'Sensor velocidad eje intermedio - interrupción intermitente',
      'Intermediate shaft speed sensor - intermittent',
    ),
    'P0795': (
      'Solenoide control presión C - circuito defectuoso',
      'Pressure control solenoid C - faulty circuit',
    ),
    'P0796': (
      'Solenoide control presión C - rendimiento o atascado desactivado',
      'Pressure control solenoid C - performance or stuck off',
    ),
    'P0797': (
      'Solenoide control presión C - atascado activado',
      'Pressure control solenoid C - stuck on',
    ),
    'P0798': (
      'Solenoide control presión C - eléctrico',
      'Pressure control solenoid C - electrical',
    ),
    'P0799': (
      'Solenoide control presión C - interrupción intermitente',
      'Pressure control solenoid C - intermittent',
    ),
    'P0800': (
      'Control caja transferencia - circuito defectuoso (solicitud MIL)',
      'Transfer case control - faulty circuit (MIL request)',
    ),
    'P0801': (
      'Circuito inhibición marcha atrás - defectuoso',
      'Reverse inhibit circuit - faulty',
    ),
    'P0802': (
      'Circuito solicitud MIL transmisión - abierto',
      'Transmission MIL request circuit - open',
    ),
    'P0803': (
      'Solenoide cambio 1-4 (salto marcha) - circuito defectuoso',
      '1-4 upshift (skip shift) solenoid - faulty circuit',
    ),
    'P0804': (
      'Lámpara indicadora cambio 1-4 (salto marcha) - circuito defectuoso',
      '1-4 upshift (skip shift) indicator lamp - faulty circuit',
    ),
    'P0805': (
      'Sensor posición embrague - circuito defectuoso',
      'Clutch position sensor - faulty circuit',
    ),
    'P0806': (
      'Sensor posición embrague - rango, funcionamiento',
      'Clutch position sensor - range/performance',
    ),
    'P0807': (
      'Sensor posición embrague - señal baja',
      'Clutch position sensor - low signal',
    ),
    'P0808': (
      'Sensor posición embrague - señal alta',
      'Clutch position sensor - high signal',
    ),
    'P0809': (
      'Sensor posición embrague - interrupción intermitente',
      'Clutch position sensor - intermittent',
    ),
    'P0810': (
      'Error control posición embrague',
      'Clutch position control error',
    ),
    'P0811': ('Deslizamiento excesivo embrague', 'Excessive clutch slippage'),
    'P0812': ('Circuito marcha atrás - defectuoso', 'Reverse circuit - faulty'),
    'P0813': (
      'Circuito salida marcha atrás - defectuoso',
      'Reverse output circuit - faulty',
    ),
    'P0814': (
      'Indicador rango transmisión - circuito defectuoso',
      'Transmission range display - faulty circuit',
    ),
    'P0815': (
      'Interruptor selección marcha arriba - circuito defectuoso',
      'Upshift switch - faulty circuit',
    ),
    'P0816': (
      'Interruptor selección marcha abajo - circuito defectuoso',
      'Downshift switch - faulty circuit',
    ),
    'P0817': (
      'Circuito bloqueo arranque - defectuoso',
      'Starter disable circuit - faulty',
    ),
    'P0818': (
      'Interruptor desconexión transmisión - circuito defectuoso',
      'Driveline disconnect switch - faulty circuit',
    ),
    'P0819': (
      'Selección marcha arriba/abajo - correlación interruptor cambio',
      'Up/downshift - shift switch correlation',
    ),
    'P0820': (
      'Sensor posición palanca cambios X-Y - circuito defectuoso',
      'Gear lever X-Y position sensor - faulty circuit',
    ),
    'P0821': (
      'Posición palanca cambios X - circuito defectuoso',
      'Gear lever X position - faulty circuit',
    ),
    'P0822': (
      'Posición palanca cambios Y - circuito defectuoso',
      'Gear lever Y position - faulty circuit',
    ),
    'P0823': (
      'Posición palanca cambios X - interrupción intermitente',
      'Gear lever X position - intermittent',
    ),
    'P0824': (
      'Posición palanca cambios Y - interrupción intermitente',
      'Gear lever Y position - intermittent',
    ),
    'P0825': (
      'Palanca cambios posición empujar-tirar (adelante-atrás)',
      'Gear lever push-pull switch (forward-reverse)',
    ),
    'P0826': (
      'Interruptor selección marcha arriba/abajo - circuito defectuoso',
      'Up/downshift switch - faulty circuit',
    ),
    'P0827': (
      'Interruptor selección marcha arriba/abajo - señal baja',
      'Up/downshift switch - low signal',
    ),
    'P0828': (
      'Interruptor selección marcha arriba/abajo - señal alta',
      'Up/downshift switch - high signal',
    ),
    'P0829': ('Cambio marcha 5-6 - defectuoso', '5-6 shift malfunction'),
    'P0830': (
      'Interruptor posición pedal embrague A - circuito defectuoso',
      'Clutch pedal position switch A - faulty circuit',
    ),
    'P0831': (
      'Interruptor posición pedal embrague A - señal baja',
      'Clutch pedal position switch A - low signal',
    ),
    'P0832': (
      'Interruptor posición pedal embrague A - señal alta',
      'Clutch pedal position switch A - high signal',
    ),
    'P0833': (
      'Interruptor posición pedal embrague B - circuito defectuoso',
      'Clutch pedal position switch B - faulty circuit',
    ),
    'P0834': (
      'Interruptor posición pedal embrague B - señal baja',
      'Clutch pedal position switch B - low signal',
    ),
    'P0835': (
      'Interruptor posición pedal embrague B - señal alta',
      'Clutch pedal position switch B - high signal',
    ),
    'P0836': (
      'Interruptor tracción 4WD - circuito defectuoso',
      '4WD switch - faulty circuit',
    ),
    'P0837': (
      'Interruptor tracción 4WD - rango, funcionamiento',
      '4WD switch - range/performance',
    ),
    'P0838': (
      'Interruptor tracción 4WD - señal baja',
      '4WD switch - low signal',
    ),
    'P0839': (
      'Interruptor tracción 4WD - señal alta',
      '4WD switch - high signal',
    ),
    'P0840': (
      'Sensor presión fluido transmisión A - circuito defectuoso',
      'Transmission fluid pressure sensor A - faulty circuit',
    ),
    'P0841': (
      'Sensor presión fluido transmisión A - rango, funcionamiento',
      'Transmission fluid pressure sensor A - range/performance',
    ),
    'P0842': (
      'Sensor presión fluido transmisión A - señal baja',
      'Transmission fluid pressure sensor A - low signal',
    ),
    'P0843': (
      'Sensor presión fluido transmisión A - señal alta',
      'Transmission fluid pressure sensor A - high signal',
    ),
    'P0844': (
      'Sensor presión fluido transmisión A - interrupción intermitente',
      'Transmission fluid pressure sensor A - intermittent',
    ),
    'P0845': (
      'Sensor presión fluido transmisión B - circuito defectuoso',
      'Transmission fluid pressure sensor B - faulty circuit',
    ),
    'P0846': (
      'Sensor presión fluido transmisión B - rango, funcionamiento',
      'Transmission fluid pressure sensor B - range/performance',
    ),
    'P0847': (
      'Sensor presión fluido transmisión B - señal baja',
      'Transmission fluid pressure sensor B - low signal',
    ),
    'P0848': (
      'Sensor presión fluido transmisión B - señal alta',
      'Transmission fluid pressure sensor B - high signal',
    ),
    'P0849': (
      'Sensor presión fluido transmisión B - interrupción intermitente',
      'Transmission fluid pressure sensor B - intermittent',
    ),
    'P0850': (
      'Interruptor posición punto muerto - circuito defectuoso',
      'Park/neutral switch - faulty circuit',
    ),
    'P0851': (
      'Interruptor posición punto muerto - señal baja',
      'Park/neutral switch - low signal',
    ),
    'P0852': (
      'Interruptor posición punto muerto - señal alta',
      'Park/neutral switch - high signal',
    ),
    'P0853': (
      'Interruptor posición conducción - circuito defectuoso',
      'Drive switch - faulty circuit',
    ),
    'P0854': (
      'Interruptor posición conducción - señal baja',
      'Drive switch - low signal',
    ),
    'P0855': (
      'Interruptor posición conducción - señal alta',
      'Drive switch - high signal',
    ),
    'P0856': (
      'Señal entrada control tracción - defectuoso',
      'Traction control input signal - faulty',
    ),
    'P0857': (
      'Señal entrada control tracción - rango, funcionamiento',
      'Traction control input signal - range/performance',
    ),
    'P0858': (
      'Señal entrada control tracción - señal baja',
      'Traction control input signal - low signal',
    ),
    'P0859': (
      'Señal entrada control tracción - señal alta',
      'Traction control input signal - high signal',
    ),
    'P0860': (
      'Comunicación módulo cambio de marchas - circuito defectuoso',
      'Gear shift module communication - faulty circuit',
    ),
    'P0861': (
      'Comunicación módulo cambio de marchas - señal baja',
      'Gear shift module communication - low signal',
    ),
    'P0862': (
      'Comunicación módulo cambio de marchas - señal alta',
      'Gear shift module communication - high signal',
    ),
    'P0863': (
      'Comunicación TCM - circuito defectuoso',
      'TCM communication - faulty circuit',
    ),
    'P0864': (
      'Comunicación TCM - rango, funcionamiento',
      'TCM communication - range/performance',
    ),
    'P0865': (
      'Comunicación TCM - señal baja',
      'TCM communication - low signal',
    ),
    'P0866': (
      'Comunicación TCM - señal alta',
      'TCM communication - high signal',
    ),
    'P0867': ('Presión fluido transmisión', 'Transmission fluid pressure'),
    'P0868': (
      'Presión fluido transmisión - baja',
      'Transmission fluid pressure - low',
    ),
    'P0869': (
      'Presión fluido transmisión - alta',
      'Transmission fluid pressure - high',
    ),
    'P0870': (
      'Sensor presión fluido transmisión C - circuito defectuoso',
      'Transmission fluid pressure sensor C - faulty circuit',
    ),
    'P0871': (
      'Sensor presión fluido transmisión C - rango, funcionamiento',
      'Transmission fluid pressure sensor C - range/performance',
    ),
    'P0872': (
      'Sensor presión fluido transmisión C - señal baja',
      'Transmission fluid pressure sensor C - low signal',
    ),
    'P0873': (
      'Sensor presión fluido transmisión C - señal alta',
      'Transmission fluid pressure sensor C - high signal',
    ),
    'P0874': (
      'Sensor presión fluido transmisión C - interrupción intermitente',
      'Transmission fluid pressure sensor C - intermittent',
    ),
    'P0875': (
      'Sensor presión fluido transmisión D - circuito defectuoso',
      'Transmission fluid pressure sensor D - faulty circuit',
    ),
    'P0876': (
      'Sensor presión fluido transmisión D - rango, funcionamiento',
      'Transmission fluid pressure sensor D - range/performance',
    ),
    'P0877': (
      'Sensor presión fluido transmisión D - señal baja',
      'Transmission fluid pressure sensor D - low signal',
    ),
    'P0878': (
      'Sensor presión fluido transmisión D - señal alta',
      'Transmission fluid pressure sensor D - high signal',
    ),
    'P0879': (
      'Sensor presión fluido transmisión D - interrupción intermitente',
      'Transmission fluid pressure sensor D - intermittent',
    ),
    'P0880': (
      'Señal entrada alimentación TCM - circuito defectuoso',
      'TCM power input signal - faulty circuit',
    ),
    'P0881': (
      'Señal entrada alimentación TCM - rango, funcionamiento',
      'TCM power input signal - range/performance',
    ),
    'P0882': (
      'Señal entrada alimentación TCM - señal baja',
      'TCM power input signal - low signal',
    ),
    'P0883': (
      'Señal entrada alimentación TCM - señal alta',
      'TCM power input signal - high signal',
    ),
    'P0884': (
      'Señal entrada alimentación TCM - interrupción intermitente',
      'TCM power input signal - intermittent',
    ),
    'P0885': (
      'Relé alimentación TCM - circuito abierto',
      'TCM power relay - open circuit',
    ),
    'P0886': (
      'Relé alimentación TCM - señal baja',
      'TCM power relay - low signal',
    ),
    'P0887': (
      'Relé alimentación TCM - señal alta',
      'TCM power relay - high signal',
    ),
    'P0888': (
      'Relé alimentación TCM - sentido circuito defectuoso',
      'TCM power relay - sense circuit fault',
    ),
    'P0889': (
      'Relé alimentación TCM - sentido rango, funcionamiento',
      'TCM power relay - sense range/performance',
    ),
    'P0890': (
      'Relé alimentación TCM - sentido señal baja',
      'TCM power relay - sense low signal',
    ),
    'P0891': (
      'Relé alimentación TCM - sentido señal alta',
      'TCM power relay - sense high signal',
    ),
    'P0892': (
      'Relé alimentación TCM - sentido interrupción intermitente',
      'TCM power relay - sense intermittent',
    ),
    'P0893': ('Múltiples marchas engranadas', 'Multiple gears engaged'),
    'P0894': (
      'Componente transmisión - deslizamiento',
      'Transmission component - slipping',
    ),
    'P0895': ('Tiempo de cambio demasiado corto', 'Shift time too short'),
    'P0896': ('Tiempo de cambio demasiado largo', 'Shift time too long'),
    'P0897': (
      'Fluido transmisión deteriorado',
      'Transmission fluid deteriorated',
    ),
    'P0898': (
      'Control transmisión - solicitud MIL señal baja',
      'Transmission control - MIL request low signal',
    ),
    'P0899': (
      'Control transmisión - solicitud MIL señal alta',
      'Transmission control - MIL request high signal',
    ),
    'P0900': (
      'Actuador embrague - circuito abierto',
      'Clutch actuator - open circuit',
    ),
    'P0901': (
      'Actuador embrague - rango, funcionamiento',
      'Clutch actuator - range/performance',
    ),
    'P0902': ('Actuador embrague - señal baja', 'Clutch actuator - low signal'),
    'P0903': (
      'Actuador embrague - señal alta',
      'Clutch actuator - high signal',
    ),
    'P0904': (
      'Circuito selección posición puerta - defectuoso',
      'Gate select position circuit - faulty',
    ),
    'P0905': (
      'Circuito selección posición puerta - rango, funcionamiento',
      'Gate select position circuit - range/performance',
    ),
    'P0906': (
      'Circuito selección posición puerta - señal baja',
      'Gate select position circuit - low signal',
    ),
    'P0907': (
      'Circuito selección posición puerta - señal alta',
      'Gate select position circuit - high signal',
    ),
    'P0908': (
      'Circuito selección posición puerta - interrupción intermitente',
      'Gate select position circuit - intermittent',
    ),
    'P0909': ('Error control selección puerta', 'Gate select control error'),
    'P0910': (
      'Actuador selección puerta - circuito abierto',
      'Gate select actuator - open circuit',
    ),
    'P0911': (
      'Actuador selección puerta - rango, funcionamiento',
      'Gate select actuator - range/performance',
    ),
    'P0912': (
      'Actuador selección puerta - señal baja',
      'Gate select actuator - low signal',
    ),
    'P0913': (
      'Actuador selección puerta - señal alta',
      'Gate select actuator - high signal',
    ),
    'P0914': (
      'Circuito posición cambio de marchas - defectuoso',
      'Gear shift position circuit - faulty',
    ),
    'P0915': (
      'Circuito posición cambio de marchas - rango, funcionamiento',
      'Gear shift position circuit - range/performance',
    ),
    'P0916': (
      'Circuito posición cambio de marchas - señal baja',
      'Gear shift position circuit - low signal',
    ),
    'P0917': (
      'Circuito posición cambio de marchas - señal alta',
      'Gear shift position circuit - high signal',
    ),
    'P0918': (
      'Circuito posición cambio de marchas - interrupción intermitente',
      'Gear shift position circuit - intermittent',
    ),
    'P0919': (
      'Error control posición cambio de marchas',
      'Gear shift position control error',
    ),
    'P0920': (
      'Actuador cambio de marchas adelante - circuito abierto',
      'Gear shift forward actuator - open circuit',
    ),
    'P0921': (
      'Actuador cambio de marchas adelante - rango, funcionamiento',
      'Gear shift forward actuator - range/performance',
    ),
    'P0922': (
      'Actuador cambio de marchas adelante - señal baja',
      'Gear shift forward actuator - low signal',
    ),
    'P0923': (
      'Actuador cambio de marchas adelante - señal alta',
      'Gear shift forward actuator - high signal',
    ),
    'P0924': (
      'Actuador cambio de marchas atrás - circuito abierto',
      'Gear shift reverse actuator - open circuit',
    ),
    'P0925': (
      'Actuador cambio de marchas atrás - rango, funcionamiento',
      'Gear shift reverse actuator - range/performance',
    ),
    'P0926': (
      'Actuador cambio de marchas atrás - señal baja',
      'Gear shift reverse actuator - low signal',
    ),
    'P0927': (
      'Actuador cambio de marchas atrás - señal alta',
      'Gear shift reverse actuator - high signal',
    ),
    'P0928': (
      'Solenoide bloqueo cambio de marchas - circuito abierto',
      'Gear shift lock solenoid - open circuit',
    ),
    'P0929': (
      'Solenoide bloqueo cambio de marchas - rango, funcionamiento',
      'Gear shift lock solenoid - range/performance',
    ),
    'P0930': (
      'Solenoide bloqueo cambio de marchas - señal baja',
      'Gear shift lock solenoid - low signal',
    ),
    'P0931': (
      'Solenoide bloqueo cambio de marchas - señal alta',
      'Gear shift lock solenoid - high signal',
    ),
    'P0932': (
      'Sensor presión hidráulica - circuito defectuoso',
      'Hydraulic pressure sensor - faulty circuit',
    ),
    'P0933': (
      'Sensor presión hidráulica - rango, funcionamiento',
      'Hydraulic pressure sensor - range/performance',
    ),
    'P0934': (
      'Sensor presión hidráulica - señal baja',
      'Hydraulic pressure sensor - low signal',
    ),
    'P0935': (
      'Sensor presión hidráulica - señal alta',
      'Hydraulic pressure sensor - high signal',
    ),
    'P0936': (
      'Sensor presión hidráulica - interrupción intermitente',
      'Hydraulic pressure sensor - intermittent',
    ),
    'P0937': (
      'Sensor temperatura aceite hidráulico - circuito defectuoso',
      'Hydraulic oil temperature sensor - faulty circuit',
    ),
    'P0938': (
      'Sensor temperatura aceite hidráulico - rango, funcionamiento',
      'Hydraulic oil temperature sensor - range/performance',
    ),
    'P0939': (
      'Sensor temperatura aceite hidráulico - señal baja',
      'Hydraulic oil temperature sensor - low signal',
    ),
    'P0940': (
      'Sensor temperatura aceite hidráulico - señal alta',
      'Hydraulic oil temperature sensor - high signal',
    ),
    'P0941': (
      'Sensor temperatura aceite hidráulico - interrupción intermitente',
      'Hydraulic oil temperature sensor - intermittent',
    ),
    'P0942': ('Unidad presión hidráulica', 'Hydraulic pressure unit'),
    'P0943': (
      'Período ciclo unidad presión hidráulica demasiado corto',
      'Hydraulic pressure unit cycle period too short',
    ),
    'P0944': (
      'Unidad presión hidráulica - pérdida de presión',
      'Hydraulic pressure unit - pressure loss',
    ),
    'P0945': (
      'Relé bomba hidráulica - circuito abierto',
      'Hydraulic pump relay - open circuit',
    ),
    'P0946': (
      'Relé bomba hidráulica - rango, funcionamiento',
      'Hydraulic pump relay - range/performance',
    ),
    'P0947': (
      'Relé bomba hidráulica - señal baja',
      'Hydraulic pump relay - low signal',
    ),
    'P0948': (
      'Relé bomba hidráulica - señal alta',
      'Hydraulic pump relay - high signal',
    ),
    'P0949': (
      'Control adaptativo cambio automático - no aprendido',
      'Auto shift manual adaptive learning - not learned',
    ),
    'P0950': (
      'Control cambio automático - circuito defectuoso',
      'Auto shift manual control - faulty circuit',
    ),
    'P0951': (
      'Control cambio automático - rango, funcionamiento',
      'Auto shift manual control - range/performance',
    ),
    'P0952': (
      'Control cambio automático - señal baja',
      'Auto shift manual control - low signal',
    ),
    'P0953': (
      'Control cambio automático - señal alta',
      'Auto shift manual control - high signal',
    ),
    'P0954': (
      'Control cambio automático - interrupción intermitente',
      'Auto shift manual control - intermittent',
    ),
    'P0955': (
      'Modo cambio automático - circuito defectuoso',
      'Auto shift manual mode - faulty circuit',
    ),
    'P0956': (
      'Modo cambio automático - rango, funcionamiento',
      'Auto shift manual mode - range/performance',
    ),
    'P0957': (
      'Modo cambio automático - señal baja',
      'Auto shift manual mode - low signal',
    ),
    'P0958': (
      'Modo cambio automático - señal alta',
      'Auto shift manual mode - high signal',
    ),
    'P0959': (
      'Modo cambio automático - interrupción intermitente',
      'Auto shift manual mode - intermittent',
    ),
    'P0960': (
      'Solenoide control presión A - circuito abierto',
      'Pressure control solenoid A - open circuit',
    ),
    'P0961': (
      'Solenoide control presión A - rango, funcionamiento',
      'Pressure control solenoid A - range/performance',
    ),
    'P0962': (
      'Solenoide control presión A - señal baja',
      'Pressure control solenoid A - low signal',
    ),
    'P0963': (
      'Solenoide control presión A - señal alta',
      'Pressure control solenoid A - high signal',
    ),
    'P0964': (
      'Solenoide control presión B - circuito abierto',
      'Pressure control solenoid B - open circuit',
    ),
    'P0965': (
      'Solenoide control presión B - rango, funcionamiento',
      'Pressure control solenoid B - range/performance',
    ),
    'P0966': (
      'Solenoide control presión B - señal baja',
      'Pressure control solenoid B - low signal',
    ),
    'P0967': (
      'Solenoide control presión B - señal alta',
      'Pressure control solenoid B - high signal',
    ),
    'P0968': (
      'Solenoide control presión C - circuito abierto',
      'Pressure control solenoid C - open circuit',
    ),
    'P0969': (
      'Solenoide control presión C - rango, funcionamiento',
      'Pressure control solenoid C - range/performance',
    ),
    'P0970': (
      'Solenoide control presión C - señal baja',
      'Pressure control solenoid C - low signal',
    ),
    'P0971': (
      'Solenoide control presión C - señal alta',
      'Pressure control solenoid C - high signal',
    ),
    'P0972': (
      'Solenoide cambio A - rango, funcionamiento',
      'Shift solenoid A - range/performance',
    ),
    'P0973': (
      'Solenoide cambio A - señal baja',
      'Shift solenoid A - low signal',
    ),
    'P0974': (
      'Solenoide cambio A - señal alta',
      'Shift solenoid A - high signal',
    ),
    'P0975': (
      'Solenoide cambio B - rango, funcionamiento',
      'Shift solenoid B - range/performance',
    ),
    'P0976': (
      'Solenoide cambio B - señal baja',
      'Shift solenoid B - low signal',
    ),
    'P0977': (
      'Solenoide cambio B - señal alta',
      'Shift solenoid B - high signal',
    ),
    'P0978': (
      'Solenoide cambio C - rango, funcionamiento',
      'Shift solenoid C - range/performance',
    ),
    'P0979': (
      'Solenoide cambio C - señal baja',
      'Shift solenoid C - low signal',
    ),
    'P0980': (
      'Solenoide cambio C - señal alta',
      'Shift solenoid C - high signal',
    ),
    'P0981': (
      'Solenoide cambio D - rango, funcionamiento',
      'Shift solenoid D - range/performance',
    ),
    'P0982': (
      'Solenoide cambio D - señal baja',
      'Shift solenoid D - low signal',
    ),
    'P0983': (
      'Solenoide cambio D - señal alta',
      'Shift solenoid D - high signal',
    ),
    'P0984': (
      'Solenoide cambio E - rango, funcionamiento',
      'Shift solenoid E - range/performance',
    ),
    'P0985': (
      'Solenoide cambio E - señal baja',
      'Shift solenoid E - low signal',
    ),
    'P0986': (
      'Solenoide cambio E - señal alta',
      'Shift solenoid E - high signal',
    ),
    'P0987': (
      'Sensor presión fluido transmisión E - circuito defectuoso',
      'Transmission fluid pressure sensor E - faulty circuit',
    ),
    'P0988': (
      'Sensor presión fluido transmisión E - rango, funcionamiento',
      'Transmission fluid pressure sensor E - range/performance',
    ),
    'P0989': (
      'Sensor presión fluido transmisión E - señal baja',
      'Transmission fluid pressure sensor E - low signal',
    ),
    'P0990': (
      'Sensor presión fluido transmisión E - señal alta',
      'Transmission fluid pressure sensor E - high signal',
    ),
    'P0991': (
      'Sensor presión fluido transmisión E - interrupción intermitente',
      'Transmission fluid pressure sensor E - intermittent',
    ),
    'P0992': (
      'Sensor presión fluido transmisión F - circuito defectuoso',
      'Transmission fluid pressure sensor F - faulty circuit',
    ),
    'P0993': (
      'Sensor presión fluido transmisión F - rango, funcionamiento',
      'Transmission fluid pressure sensor F - range/performance',
    ),
    'P0994': (
      'Sensor presión fluido transmisión F - señal baja',
      'Transmission fluid pressure sensor F - low signal',
    ),
    'P0995': (
      'Sensor presión fluido transmisión F - señal alta',
      'Transmission fluid pressure sensor F - high signal',
    ),
    'P0996': (
      'Sensor presión fluido transmisión F - interrupción intermitente',
      'Transmission fluid pressure sensor F - intermittent',
    ),
    'P0997': (
      'Solenoide cambio F - rango, funcionamiento',
      'Shift solenoid F - range/performance',
    ),
    'P0998': (
      'Solenoide cambio F - señal baja',
      'Shift solenoid F - low signal',
    ),
    'P0999': (
      'Solenoide cambio F - señal alta',
      'Shift solenoid F - high signal',
    ),
    // P1xxx - Manufacturer specific codes (most common)
    'P1000': (
      'Diagnóstico a bordo (OBD) no completado',
      'On-board diagnostics (OBD) not completed',
    ),
    'P1001': (
      'Autodiagnóstico llave encendida motor apagado no completado',
      'Key on engine off self-test not completed',
    ),
    'P1002': (
      'Autodiagnóstico llave encendida motor encendido no completado',
      'Key on engine running self-test not completed',
    ),
    'P1100': (
      'Sensor masa aire (MAF) - interrupción intermitente',
      'Mass air flow (MAF) sensor - intermittent',
    ),
    'P1101': (
      'Sensor masa aire (MAF) - fuera de rango autodiagnóstico',
      'Mass air flow (MAF) sensor - out of self-test range',
    ),
    'P1102': (
      'Sensor masa aire (MAF) - señal baja durante autodiagnóstico',
      'Mass air flow (MAF) sensor - low signal during self-test',
    ),
    'P1103': (
      'Sensor masa aire (MAF) - señal alta durante autodiagnóstico',
      'Mass air flow (MAF) sensor - high signal during self-test',
    ),
    'P1104': ('Circuito sensor MAF - masa', 'MAF sensor circuit - ground'),
    'P1105': (
      'Presión barométrica dual - fallo autodiagnóstico',
      'Dual barometric pressure - self-test failure',
    ),
    'P1110': (
      'Sensor temperatura aire admisión - fallo autodiagnóstico',
      'Intake air temperature sensor - self-test failure',
    ),
    'P1111': (
      'Temperatura aire admisión (IAT) - señal intermitente',
      'Intake air temperature (IAT) - intermittent signal',
    ),
    'P1112': (
      'Sensor temperatura aire admisión - circuito intermitente',
      'Intake air temperature sensor - intermittent circuit',
    ),
    'P1113': (
      'Sensor temperatura aire admisión - circuito abierto',
      'Intake air temperature sensor - open circuit',
    ),
    'P1114': (
      'Temperatura refrigerante motor (ECT) - señal baja',
      'Engine coolant temperature (ECT) - low signal',
    ),
    'P1115': (
      'Temperatura refrigerante motor (ECT) - señal alta',
      'Engine coolant temperature (ECT) - high signal',
    ),
    'P1116': (
      'Temperatura refrigerante motor (ECT) - fuera de rango',
      'Engine coolant temperature (ECT) - out of range',
    ),
    'P1117': (
      'Temperatura refrigerante motor (ECT) - intermitente',
      'Engine coolant temperature (ECT) - intermittent',
    ),
    'P1120': (
      'Sensor posición mariposa (TPS) - fuera de rango',
      'Throttle position sensor (TPS) - out of range',
    ),
    'P1121': (
      'Sensor posición mariposa (TPS) - inconsistente con MAF',
      'Throttle position sensor (TPS) - inconsistent with MAF',
    ),
    'P1122': (
      'Sensor posición mariposa (TPS) - señal baja intermitente',
      'Throttle position sensor (TPS) - intermittent low signal',
    ),
    'P1123': (
      'Sensor posición mariposa (TPS) - señal alta intermitente',
      'Throttle position sensor (TPS) - intermittent high signal',
    ),
    'P1124': (
      'Señal posición mariposa - fuera de rango autodiagnóstico',
      'Throttle position signal - out of self-test range',
    ),
    'P1125': (
      'Sensor posición mariposa (TPS) - circuito intermitente',
      'Throttle position sensor (TPS) - intermittent circuit',
    ),
    'P1127': (
      'Temperatura gases escape no alcanzada',
      'Exhaust gas temperature not reached',
    ),
    'P1128': (
      'Señales sensor oxígeno invertidas (bloque 1)',
      'O2 sensor signals swapped (bank 1)',
    ),
    'P1129': (
      'Señales sensor oxígeno invertidas (bloque 2)',
      'O2 sensor signals swapped (bank 2)',
    ),
    'P1130': (
      'Falta variación sensor oxígeno (bloque 1 sensor 1)',
      'Lack of O2 sensor variation (bank 1 sensor 1)',
    ),
    'P1131': (
      'Sensor oxígeno (bloque 1 sensor 1) - indica mezcla pobre',
      'O2 sensor (bank 1 sensor 1) - indicates lean',
    ),
    'P1132': (
      'Sensor oxígeno (bloque 1 sensor 1) - indica mezcla rica',
      'O2 sensor (bank 1 sensor 1) - indicates rich',
    ),
    'P1133': (
      'Sensor oxígeno (bloque 1 sensor 1) - tiempo respuesta insuficiente',
      'O2 sensor (bank 1 sensor 1) - insufficient response time',
    ),
    'P1134': (
      'Sensor oxígeno (bloque 1 sensor 1) - transición insuficiente',
      'O2 sensor (bank 1 sensor 1) - insufficient transition',
    ),
    'P1135': (
      'Calentador sensor oxígeno (bloque 1 sensor 1) - circuito intermitente',
      'O2 sensor heater (bank 1 sensor 1) - intermittent circuit',
    ),
    'P1136': (
      'Corrección combustible largo plazo (bloque 1) - mezcla rica',
      'Long term fuel trim (bank 1) - rich',
    ),
    'P1137': (
      'Falta variación sensor oxígeno (bloque 1 sensor 2)',
      'Lack of O2 sensor variation (bank 1 sensor 2)',
    ),
    'P1138': (
      'Sensor oxígeno (bloque 1 sensor 2) - indica mezcla rica',
      'O2 sensor (bank 1 sensor 2) - indicates rich',
    ),
    'P1139': (
      'Señal sensor oxígeno (bloque 1 sensor 2) - intensidad insuficiente',
      'O2 sensor signal (bank 1 sensor 2) - insufficient intensity',
    ),
    'P1140': (
      'Sensor carga agua combustible - circuito defectuoso',
      'Fuel water load sensor - faulty circuit',
    ),
    'P1141': (
      'Sensor carga agua combustible - rango, funcionamiento',
      'Fuel water load sensor - range/performance',
    ),
    'P1150': (
      'Falta variación sensor oxígeno (bloque 2 sensor 1)',
      'Lack of O2 sensor variation (bank 2 sensor 1)',
    ),
    'P1151': (
      'Sensor oxígeno (bloque 2 sensor 1) - indica mezcla pobre',
      'O2 sensor (bank 2 sensor 1) - indicates lean',
    ),
    'P1152': (
      'Sensor oxígeno (bloque 2 sensor 1) - indica mezcla rica',
      'O2 sensor (bank 2 sensor 1) - indicates rich',
    ),
    'P1153': (
      'Sensor oxígeno (bloque 2 sensor 1) - tiempo respuesta insuficiente',
      'O2 sensor (bank 2 sensor 1) - insufficient response time',
    ),
    'P1154': (
      'Sensor oxígeno (bloque 2 sensor 1) - transición insuficiente',
      'O2 sensor (bank 2 sensor 1) - insufficient transition',
    ),
    'P1155': (
      'Calentador sensor oxígeno (bloque 2 sensor 1) - circuito intermitente',
      'O2 sensor heater (bank 2 sensor 1) - intermittent circuit',
    ),
    'P1166': (
      'Corrección combustible largo plazo (bloque 2) - mezcla rica',
      'Long term fuel trim (bank 2) - rich',
    ),
    'P1167': (
      'Corrección combustible largo plazo (bloque 2) - mezcla pobre',
      'Long term fuel trim (bank 2) - lean',
    ),
    'P1170': (
      'Señal sensor oxígeno (bloque 1 sensor 1) - fija en posición media',
      'O2 sensor signal (bank 1 sensor 1) - stuck at mid-range',
    ),
    'P1195': (
      'Sensor presión barométrica - circuito defectuoso',
      'Barometric pressure sensor - faulty circuit',
    ),
    'P1196': (
      'Llave encendida - arranque motor no autorizado',
      'Key on - engine start not authorized',
    ),
    'P1200': (
      'Circuito control inyector - defectuoso',
      'Injector control circuit - faulty',
    ),
    'P1201': (
      'Inyector cilindro 1 - circuito defectuoso',
      'Injector cylinder 1 - faulty circuit',
    ),
    'P1202': (
      'Inyector cilindro 2 - circuito defectuoso',
      'Injector cylinder 2 - faulty circuit',
    ),
    'P1203': (
      'Inyector cilindro 3 - circuito defectuoso',
      'Injector cylinder 3 - faulty circuit',
    ),
    'P1204': (
      'Inyector cilindro 4 - circuito defectuoso',
      'Injector cylinder 4 - faulty circuit',
    ),
    'P1205': (
      'Inyector cilindro 5 - circuito defectuoso',
      'Injector cylinder 5 - faulty circuit',
    ),
    'P1206': (
      'Inyector cilindro 6 - circuito defectuoso',
      'Injector cylinder 6 - faulty circuit',
    ),
    'P1207': (
      'Inyector cilindro 7 - circuito defectuoso',
      'Injector cylinder 7 - faulty circuit',
    ),
    'P1208': (
      'Inyector cilindro 8 - circuito defectuoso',
      'Injector cylinder 8 - faulty circuit',
    ),
    'P1209': (
      'Circuito control presión inyección - defectuoso',
      'Injection pressure control circuit - faulty',
    ),
    'P1210': (
      'Circuito control presión inyección - señal alta',
      'Injection pressure control circuit - high signal',
    ),
    'P1211': (
      'Circuito control presión inyección - señal baja',
      'Injection pressure control circuit - low signal',
    ),
    'P1212': (
      'Circuito control presión inyección - fuera de rango',
      'Injection pressure control circuit - out of range',
    ),
    'P1220': ('Error control mariposa serie', 'Series throttle control error'),
    'P1221': ('Control mariposa - error', 'Throttle control - error'),
    'P1230': ('Bomba combustible - fuera de rango', 'Fuel pump - out of range'),
    'P1231': (
      'Bomba combustible - señal baja velocidad alta',
      'Fuel pump - low signal at high speed',
    ),
    'P1232': (
      'Bomba combustible - señal baja velocidad baja',
      'Fuel pump - low signal at low speed',
    ),
    'P1233': (
      'Módulo control bomba combustible - desactivado',
      'Fuel pump control module - disabled',
    ),
    'P1234': (
      'Módulo control bomba combustible - habilitado',
      'Fuel pump control module - enabled',
    ),
    'P1235': (
      'Control bomba combustible - fuera de rango',
      'Fuel pump control - out of range',
    ),
    'P1236': (
      'Control bomba combustible - señal alta',
      'Fuel pump control - high signal',
    ),
    'P1237': (
      'Control bomba combustible - señal baja',
      'Fuel pump control - low signal',
    ),
    'P1250': (
      'Solenoide control presión - circuito defectuoso',
      'Pressure control solenoid - faulty circuit',
    ),
    'P1260': (
      'Señal robo detectada - motor deshabilitado',
      'Theft detected signal - engine disabled',
    ),
    'P1270': (
      'Velocidad motor o vehículo - límite alcanzado',
      'Engine or vehicle speed - limit reached',
    ),
    'P1275': (
      'Sensor posición pedal acelerador - fuera de rango',
      'Accelerator pedal position sensor - out of range',
    ),
    'P1280': (
      'Circuito control presión inyección - fuera de rango baja',
      'Injection pressure control circuit - out of range low',
    ),
    'P1281': (
      'Circuito control presión inyección - fuera de rango alta',
      'Injection pressure control circuit - out of range high',
    ),
    'P1285': (
      'Temperatura culata - sobrecalentamiento',
      'Cylinder head temperature - overheating',
    ),
    'P1286': (
      'Temperatura culata - sensor fuera de rango',
      'Cylinder head temperature - sensor out of range',
    ),
    'P1288': (
      'Sensor temperatura culata - circuito abierto',
      'Cylinder head temperature sensor - open circuit',
    ),
    'P1289': (
      'Sensor temperatura culata - señal alta',
      'Cylinder head temperature sensor - high signal',
    ),
    'P1290': (
      'Sensor temperatura culata - señal baja',
      'Cylinder head temperature sensor - low signal',
    ),
    'P1299': (
      'Temperatura culata - condición sobrecalentamiento',
      'Cylinder head temperature - overheating condition',
    ),
    'P1300': (
      'Circuito encendido - señal intermitente',
      'Ignition circuit - intermittent signal',
    ),
    'P1316': (
      'Falsa explosión detectada con inyector desactivado',
      'Misfire detected with injector disabled',
    ),
    'P1320': (
      'Circuito primario encendido - defectuoso',
      'Ignition primary circuit - faulty',
    ),
    'P1336': (
      'Sensor posición cigüeñal - variación aprendida no almacenada',
      'Crankshaft position sensor - learned variation not stored',
    ),
    'P1340': (
      'Sensor posición árbol de levas - circuito intermitente',
      'Camshaft position sensor - intermittent circuit',
    ),
    'P1345': (
      'Correlación posición cigüeñal/árbol de levas',
      'Crankshaft/camshaft position correlation',
    ),
    'P1349': (
      'Sistema distribución variable - defectuoso',
      'Variable valve timing system - faulty',
    ),
    'P1350': (
      'Sistema distribución variable - circuito defectuoso',
      'Variable valve timing system - faulty circuit',
    ),
    'P1351': (
      'Circuito diagnóstico encendido - señal alta',
      'Ignition diagnostic circuit - high signal',
    ),
    'P1352': (
      'Circuito diagnóstico encendido - señal baja',
      'Ignition diagnostic circuit - low signal',
    ),
    'P1380': (
      'Sistema detección falsa explosión - circuito defectuoso',
      'Misfire detection system - faulty circuit',
    ),
    'P1381': (
      'Sistema detección falsa explosión - sin comunicación',
      'Misfire detection system - no communication',
    ),
    'P1390': (
      'Sensor posición cigüeñal/árbol de levas - correlación G',
      'Crankshaft/camshaft position sensor - G correlation',
    ),
    'P1391': (
      'Sensor posición cigüeñal/árbol de levas - pérdida señal intermitente',
      'Crankshaft/camshaft position sensor - intermittent signal loss',
    ),
    'P1400': (
      'Sensor presión diferencial DPFE - señal baja',
      'DPFE differential pressure sensor - low signal',
    ),
    'P1401': (
      'Sensor presión diferencial DPFE - señal alta',
      'DPFE differential pressure sensor - high signal',
    ),
    'P1402': ('Válvula EGR - atascada abierta', 'EGR valve - stuck open'),
    'P1403': ('Válvula EGR - atascada cerrada', 'EGR valve - stuck closed'),
    'P1404': (
      'Sistema EGR - válvula cerrada posición pintle',
      'EGR system - closed valve pintle position',
    ),
    'P1405': (
      'Sensor presión diferencial DPFE - manguera invertida',
      'DPFE differential pressure sensor - hose reversed',
    ),
    'P1406': (
      'Posición pintle EGR - circuito defectuoso',
      'EGR pintle position - faulty circuit',
    ),
    'P1410': (
      'Sistema inyección aire secundario (bloque 1) - circuito defectuoso',
      'Secondary air injection system (bank 1) - faulty circuit',
    ),
    'P1411': (
      'Sistema inyección aire secundario - flujo incorrecto',
      'Secondary air injection system - incorrect flow',
    ),
    'P1414': (
      'Sistema inyección aire secundario (bloque 2) - circuito defectuoso',
      'Secondary air injection system (bank 2) - faulty circuit',
    ),
    'P1420': (
      'Circuito control purga EVAP - señal baja',
      'EVAP purge control circuit - low signal',
    ),
    'P1421': (
      'Circuito control purga EVAP - señal alta',
      'EVAP purge control circuit - high signal',
    ),
    'P1441': (
      'Sistema EVAP - flujo durante condición no purga',
      'EVAP system - flow during non-purge condition',
    ),
    'P1442': (
      'Sistema EVAP - fuga pequeña detectada',
      'EVAP system - small leak detected',
    ),
    'P1443': (
      'Sistema EVAP - válvula control ventilación defectuosa',
      'EVAP system - vent control valve faulty',
    ),
    'P1444': (
      'Sensor flujo purga EVAP - señal baja',
      'EVAP purge flow sensor - low signal',
    ),
    'P1445': (
      'Sensor flujo purga EVAP - señal alta',
      'EVAP purge flow sensor - high signal',
    ),
    'P1450': (
      'Sistema EVAP - incapaz de purgar',
      'EVAP system - unable to bleed',
    ),
    'P1451': (
      'Válvula ventilación canister EVAP - circuito defectuoso',
      'EVAP canister vent valve - faulty circuit',
    ),
    'P1460': (
      'Circuito control ventilador refrigeración - defectuoso',
      'Cooling fan control circuit - faulty',
    ),
    'P1480': (
      'Circuito control ventilador refrigeración 1 - defectuoso',
      'Cooling fan 1 control circuit - faulty',
    ),
    'P1481': (
      'Circuito control ventilador refrigeración 2 - defectuoso',
      'Cooling fan 2 control circuit - faulty',
    ),
    'P1500': (
      'Circuito relé motor arranque - defectuoso',
      'Starter relay circuit - faulty',
    ),
    'P1501': (
      'Sensor velocidad vehículo - circuito intermitente',
      'Vehicle speed sensor - intermittent circuit',
    ),
    'P1502': (
      'Sensor velocidad vehículo - señal intermitente',
      'Vehicle speed sensor - intermittent signal',
    ),
    'P1504': (
      'Control ralentí - atascado abierto',
      'Idle control - stuck open',
    ),
    'P1505': (
      'Control ralentí - atascado cerrado',
      'Idle control - stuck closed',
    ),
    'P1506': ('Control ralentí - sobrevelocidad', 'Idle control - overspeed'),
    'P1507': ('Control ralentí - subvelocidad', 'Idle control - underspeed'),
    'P1508': (
      'Válvula control ralentí - circuito abierto',
      'Idle control valve - open circuit',
    ),
    'P1509': (
      'Válvula control ralentí - circuito defectuoso',
      'Idle control valve - faulty circuit',
    ),
    'P1510': (
      'Válvula control ralentí - señal baja',
      'Idle control valve - low signal',
    ),
    'P1516': (
      'Módulo control actuador mariposa - error posición mariposa',
      'Throttle actuator control module - throttle position error',
    ),
    'P1518': (
      'Módulo control actuador mariposa - error comunicación serie',
      'Throttle actuator control module - serial communication error',
    ),
    'P1519': (
      'Control ralentí - error posición mariposa',
      'Idle control - throttle position error',
    ),
    'P1520': (
      'Interruptor posición estacionamiento/punto muerto - circuito defectuoso',
      'Park/neutral position switch - faulty circuit',
    ),
    'P1525': (
      'Válvula derivación aire - circuito defectuoso',
      'Air bypass valve - faulty circuit',
    ),
    'P1530': (
      'Circuito relé embrague A/C - defectuoso',
      'A/C clutch relay circuit - faulty',
    ),
    'P1537': (
      'Control ralentí - autodiagnóstico motor encendido',
      'Idle control - engine running self-test',
    ),
    'P1538': (
      'Control ralentí - autodiagnóstico motor apagado',
      'Idle control - engine off self-test',
    ),
    'P1539': (
      'Circuito alimentación A/C - señal alta',
      'A/C power circuit - high signal',
    ),
    'P1540': (
      'Circuito alimentación A/C - señal baja',
      'A/C power circuit - low signal',
    ),
    'P1550': (
      'Circuito control dirección asistida - defectuoso',
      'Power steering control circuit - faulty',
    ),
    'P1570': (
      'Sistema antirrobo - fallo comunicación GPS',
      'Anti-theft system - GPS communication failure',
    ),
    'P1571': (
      'Interruptor freno - autodiagnóstico motor encendido',
      'Brake switch - engine running self-test',
    ),
    'P1572': (
      'Interruptor freno - autodiagnóstico motor apagado',
      'Brake switch - engine off self-test',
    ),
    'P1600': (
      'Módulo control motor (ECM) - pérdida comunicación',
      'Engine control module (ECM) - communication loss',
    ),
    'P1601': (
      'Módulo control motor (ECM/TCM) - error comunicación serie',
      'Engine control module (ECM/TCM) - serial communication error',
    ),
    'P1602': (
      'Módulo control motor - código no programado',
      'Engine control module - code not programmed',
    ),
    'P1603': (
      'Módulo control motor - error EEPROM',
      'Engine control module - EEPROM error',
    ),
    'P1604': (
      'Módulo control motor - código no aprendido',
      'Engine control module - code not learned',
    ),
    'P1605': (
      'Módulo control motor - diagnóstico a bordo no completado',
      'Engine control module - OBD not completed',
    ),
    'P1610': (
      'Sistema inmovilizador - error comunicación',
      'Immobilizer system - communication error',
    ),
    'P1611': (
      'Sistema inmovilizador - error registro',
      'Immobilizer system - registration error',
    ),
    'P1612': (
      'Sistema inmovilizador - error código',
      'Immobilizer system - code error',
    ),
    'P1613': (
      'Sistema inmovilizador - error comunicación MIL',
      'Immobilizer system - MIL communication error',
    ),
    'P1614': (
      'Sistema inmovilizador - error comunicación ECM',
      'Immobilizer system - ECM communication error',
    ),
    'P1620': (
      'Circuito señal refrigeración - defectuoso',
      'Cooling signal circuit - faulty',
    ),
    'P1621': (
      'Memoria módulo control - error',
      'Control module memory - error',
    ),
    'P1622': (
      'Memoria módulo control - error escritura',
      'Control module memory - write error',
    ),
    'P1624': (
      'Solicitud MIL transmisión - circuito defectuoso',
      'Transmission MIL request - faulty circuit',
    ),
    'P1625': (
      'Señal ventilador B - circuito defectuoso',
      'Fan B signal - faulty circuit',
    ),
    'P1626': (
      'Señal antirrobo - no recibida',
      'Anti-theft signal - not received',
    ),
    'P1627': (
      'Señal módulo control - error analógico/digital',
      'Control module signal - analog/digital error',
    ),
    'P1628': (
      'Señal módulo control - error comunicación serie',
      'Control module signal - serial communication error',
    ),
    'P1630': (
      'Tensión batería fuera de rango autodiagnóstico',
      'Battery voltage out of self-test range',
    ),
    'P1631': (
      'Circuito alternador - señal fuera de rango',
      'Alternator circuit - signal out of range',
    ),
    'P1632': (
      'Circuito control ralentí - señal fuera de rango',
      'Idle control circuit - signal out of range',
    ),
    'P1633': (
      'Circuito alimentación contacto - señal baja',
      'Keep alive power circuit - low signal',
    ),
    'P1634': (
      'Circuito alimentación contacto - señal alta',
      'Keep alive power circuit - high signal',
    ),
    'P1635': (
      'Sensor temperatura neumáticos - circuito defectuoso',
      'Tire temperature sensor - faulty circuit',
    ),
    'P1639': (
      'Señal velocidad vehículo - fuera de rango autodiagnóstico',
      'Vehicle speed signal - out of self-test range',
    ),
    'P1640': (
      'Circuito diagnóstico a bordo - defectuoso',
      'On-board diagnostics circuit - faulty',
    ),
    'P1650': (
      'Solenoide control dirección asistida - circuito defectuoso',
      'Power steering control solenoid - faulty circuit',
    ),
    'P1660': (
      'Circuito control solenoide salida - defectuoso',
      'Output solenoid control circuit - faulty',
    ),
    'P1670': (
      'Circuito señal salida módulo control - defectuoso',
      'Control module output signal circuit - faulty',
    ),
    'P1680': (
      'Circuito control bomba combustible - defectuoso',
      'Fuel pump control circuit - faulty',
    ),
    'P1681': (
      'Circuito control bomba combustible - señal baja',
      'Fuel pump control circuit - low signal',
    ),
    'P1682': (
      'Circuito control bomba combustible - señal alta',
      'Fuel pump control circuit - high signal',
    ),
    'P1690': (
      'Circuito control lámpara avería (MIL) - defectuoso',
      'Malfunction indicator lamp (MIL) control circuit - faulty',
    ),
    'P1693': (
      'Código avería almacenado en módulo complementario',
      'Fault code stored in companion module',
    ),
    'P1700': (
      'Sensor velocidad eje intermedio transmisión - circuito defectuoso',
      'Transmission intermediate shaft speed sensor - faulty circuit',
    ),
    'P1701': (
      'Sensor velocidad eje intermedio transmisión - fuera de rango',
      'Transmission intermediate shaft speed sensor - out of range',
    ),
    'P1702': (
      'Sensor rango transmisión - circuito intermitente',
      'Transmission range sensor - intermittent circuit',
    ),
    'P1703': (
      'Interruptor freno - fuera de rango autodiagnóstico',
      'Brake switch - out of self-test range',
    ),
    'P1705': (
      'Sensor rango transmisión - fuera de rango autodiagnóstico',
      'Transmission range sensor - out of self-test range',
    ),
    'P1709': (
      'Interruptor posición estacionamiento/punto muerto - fuera de rango',
      'Park/neutral position switch - out of range',
    ),
    'P1740': (
      'Embrague convertidor par - circuito defectuoso',
      'Torque converter clutch - faulty circuit',
    ),
    'P1741': (
      'Embrague convertidor par - error control',
      'Torque converter clutch - control error',
    ),
    'P1742': (
      'Embrague convertidor par - deslizamiento excesivo',
      'Torque converter clutch - excessive slippage',
    ),
    'P1743': (
      'Embrague convertidor par - atascado desactivado',
      'Torque converter clutch - stuck off',
    ),
    'P1744': (
      'Embrague convertidor par - error sistema',
      'Torque converter clutch - system error',
    ),
    'P1745': (
      'Solenoide control presión línea - circuito defectuoso',
      'Line pressure control solenoid - faulty circuit',
    ),
    'P1746': (
      'Solenoide control presión - circuito abierto',
      'Pressure control solenoid - open circuit',
    ),
    'P1747': (
      'Solenoide control presión - cortocircuito',
      'Pressure control solenoid - short circuit',
    ),
    'P1749': (
      'Solenoide control presión - señal alta',
      'Pressure control solenoid - high signal',
    ),
    'P1751': (
      'Solenoide cambio A - rendimiento',
      'Shift solenoid A - performance',
    ),
    'P1756': (
      'Solenoide cambio B - rendimiento',
      'Shift solenoid B - performance',
    ),
    'P1760': (
      'Solenoide control presión - señal baja',
      'Pressure control solenoid - low signal',
    ),
    'P1762': (
      'Transmisión - modo protección activado',
      'Transmission - protection mode activated',
    ),
    'P1765': (
      'Solenoide temporización - rendimiento',
      'Timing solenoid - performance',
    ),
    'P1780': (
      'Interruptor modo transmisión - circuito defectuoso',
      'Transmission mode switch - faulty circuit',
    ),
    'P1781': (
      'Interruptor modo 4x4 baja - fuera de rango autodiagnóstico',
      '4x4 low mode switch - out of self-test range',
    ),
    'P1783': (
      'Temperatura transmisión - sobrecalentamiento',
      'Transmission temperature - overheating',
    ),
    'P1785': (
      'Transmisión - primera o marcha atrás seleccionada en movimiento',
      'Transmission - first or reverse selected while moving',
    ),
    'P1788': (
      'Solenoide cambio 3-2 - circuito abierto',
      '3-2 shift solenoid - open circuit',
    ),
    'P1789': (
      'Solenoide cambio 3-2 - cortocircuito',
      '3-2 shift solenoid - short circuit',
    ),
    'P1790': (
      'Transmisión - error mecánico primera marcha',
      'Transmission - first gear mechanical error',
    ),
    // P2xxx - Generic powertrain codes
    'P2000': (
      'Trampa NOx (bloque 1) - eficiencia por debajo umbral',
      'NOx trap (bank 1) - efficiency below threshold',
    ),
    'P2001': (
      'Trampa NOx (bloque 2) - eficiencia por debajo umbral',
      'NOx trap (bank 2) - efficiency below threshold',
    ),
    'P2002': (
      'Filtro partículas diésel (bloque 1) - eficiencia por debajo umbral',
      'Diesel particulate filter (bank 1) - efficiency below threshold',
    ),
    'P2003': (
      'Filtro partículas diésel (bloque 2) - eficiencia por debajo umbral',
      'Diesel particulate filter (bank 2) - efficiency below threshold',
    ),
    'P2004': (
      'Control válvula colector admisión (bloque 1) - atascada abierta',
      'Intake manifold runner control (bank 1) - stuck open',
    ),
    'P2005': (
      'Control válvula colector admisión (bloque 2) - atascada abierta',
      'Intake manifold runner control (bank 2) - stuck open',
    ),
    'P2006': (
      'Control válvula colector admisión (bloque 1) - atascada cerrada',
      'Intake manifold runner control (bank 1) - stuck closed',
    ),
    'P2007': (
      'Control válvula colector admisión (bloque 2) - atascada cerrada',
      'Intake manifold runner control (bank 2) - stuck closed',
    ),
    'P2008': (
      'Control válvula colector admisión - circuito abierto (bloque 1)',
      'Intake manifold runner control - open circuit (bank 1)',
    ),
    'P2009': (
      'Control válvula colector admisión - señal baja (bloque 1)',
      'Intake manifold runner control - low signal (bank 1)',
    ),
    'P2010': (
      'Control válvula colector admisión - señal alta (bloque 1)',
      'Intake manifold runner control - high signal (bank 1)',
    ),
    'P2011': (
      'Control válvula colector admisión - circuito abierto (bloque 2)',
      'Intake manifold runner control - open circuit (bank 2)',
    ),
    'P2012': (
      'Control válvula colector admisión - señal baja (bloque 2)',
      'Intake manifold runner control - low signal (bank 2)',
    ),
    'P2013': (
      'Control válvula colector admisión - señal alta (bloque 2)',
      'Intake manifold runner control - high signal (bank 2)',
    ),
    'P2014': (
      'Sensor posición válvula colector admisión - circuito defectuoso (bloque 1)',
      'Intake manifold runner position sensor - faulty circuit (bank 1)',
    ),
    'P2015': (
      'Sensor posición válvula colector admisión - rango, funcionamiento (bloque 1)',
      'Intake manifold runner position sensor - range/performance (bank 1)',
    ),
    'P2016': (
      'Sensor posición válvula colector admisión - señal baja (bloque 1)',
      'Intake manifold runner position sensor - low signal (bank 1)',
    ),
    'P2017': (
      'Sensor posición válvula colector admisión - señal alta (bloque 1)',
      'Intake manifold runner position sensor - high signal (bank 1)',
    ),
    'P2018': (
      'Sensor posición válvula colector admisión - circuito defectuoso (bloque 2)',
      'Intake manifold runner position sensor - faulty circuit (bank 2)',
    ),
    'P2019': (
      'Sensor posición válvula colector admisión - rango, funcionamiento (bloque 2)',
      'Intake manifold runner position sensor - range/performance (bank 2)',
    ),
    'P2020': (
      'Sensor posición válvula colector admisión - señal baja (bloque 2)',
      'Intake manifold runner position sensor - low signal (bank 2)',
    ),
    'P2021': (
      'Sensor posición válvula colector admisión - señal alta (bloque 2)',
      'Intake manifold runner position sensor - high signal (bank 2)',
    ),
    'P2022': (
      'Sensor presión colector admisión (bloque 1) - circuito defectuoso',
      'Intake manifold pressure sensor (bank 1) - faulty circuit',
    ),
    'P2023': (
      'Sensor presión colector admisión (bloque 1) - rango, funcionamiento',
      'Intake manifold pressure sensor (bank 1) - range/performance',
    ),
    'P2024': (
      'Sensor presión colector admisión (bloque 1) - señal baja',
      'Intake manifold pressure sensor (bank 1) - low signal',
    ),
    'P2025': (
      'Sensor presión colector admisión (bloque 1) - señal alta',
      'Intake manifold pressure sensor (bank 1) - high signal',
    ),
    'P2026': (
      'Sensor presión colector admisión (bloque 1) - interrupción intermitente',
      'Intake manifold pressure sensor (bank 1) - intermittent',
    ),
    'P2027': (
      'Sensor presión colector admisión (bloque 2) - circuito defectuoso',
      'Intake manifold pressure sensor (bank 2) - faulty circuit',
    ),
    'P2028': (
      'Sensor presión colector admisión (bloque 2) - rango, funcionamiento',
      'Intake manifold pressure sensor (bank 2) - range/performance',
    ),
    'P2029': (
      'Sensor presión colector admisión (bloque 2) - señal baja',
      'Intake manifold pressure sensor (bank 2) - low signal',
    ),
    'P2030': (
      'Sensor presión colector admisión (bloque 2) - señal alta',
      'Intake manifold pressure sensor (bank 2) - high signal',
    ),
    'P2031': (
      'Sensor temperatura gases escape (bloque 2 sensor 1) - circuito defectuoso',
      'Exhaust gas temperature sensor (bank 2 sensor 1) - faulty circuit',
    ),
    'P2032': (
      'Sensor temperatura gases escape (bloque 2 sensor 1) - señal baja',
      'Exhaust gas temperature sensor (bank 2 sensor 1) - low signal',
    ),
    'P2033': (
      'Sensor temperatura gases escape (bloque 2 sensor 1) - señal alta',
      'Exhaust gas temperature sensor (bank 2 sensor 1) - high signal',
    ),
    'P2034': (
      'Sensor temperatura gases escape (bloque 2 sensor 2) - circuito defectuoso',
      'Exhaust gas temperature sensor (bank 2 sensor 2) - faulty circuit',
    ),
    'P2035': (
      'Sensor temperatura gases escape (bloque 2 sensor 2) - señal baja',
      'Exhaust gas temperature sensor (bank 2 sensor 2) - low signal',
    ),
    'P2036': (
      'Sensor temperatura gases escape (bloque 2 sensor 2) - señal alta',
      'Exhaust gas temperature sensor (bank 2 sensor 2) - high signal',
    ),
    'P2070': (
      'Control válvula colector admisión - atascada abierta',
      'Intake manifold runner control - stuck open',
    ),
    'P2071': (
      'Control válvula colector admisión - atascada cerrada',
      'Intake manifold runner control - stuck closed',
    ),
    'P2075': (
      'Sensor posición válvula colector admisión - circuito defectuoso',
      'Intake manifold runner position sensor - faulty circuit',
    ),
    'P2076': (
      'Sensor posición válvula colector admisión - rango, funcionamiento',
      'Intake manifold runner position sensor - range/performance',
    ),
    'P2077': (
      'Sensor posición válvula colector admisión - señal baja',
      'Intake manifold runner position sensor - low signal',
    ),
    'P2078': (
      'Sensor posición válvula colector admisión - señal alta',
      'Intake manifold runner position sensor - high signal',
    ),
    'P2080': (
      'Sensor temperatura gases escape (bloque 1 sensor 1) - rango, funcionamiento',
      'Exhaust gas temperature sensor (bank 1 sensor 1) - range/performance',
    ),
    'P2084': (
      'Sensor temperatura gases escape (bloque 2 sensor 1) - rango, funcionamiento',
      'Exhaust gas temperature sensor (bank 2 sensor 1) - range/performance',
    ),
    'P2088': (
      'Posición actuador árbol de levas admisión A (bloque 1) - señal baja',
      'Camshaft intake actuator position A (bank 1) - low signal',
    ),
    'P2089': (
      'Posición actuador árbol de levas admisión A (bloque 1) - señal alta',
      'Camshaft intake actuator position A (bank 1) - high signal',
    ),
    'P2090': (
      'Posición actuador árbol de levas admisión B (bloque 2) - señal baja',
      'Camshaft intake actuator position B (bank 2) - low signal',
    ),
    'P2091': (
      'Posición actuador árbol de levas admisión B (bloque 2) - señal alta',
      'Camshaft intake actuator position B (bank 2) - high signal',
    ),
    'P2092': (
      'Posición actuador árbol de levas escape A (bloque 1) - señal baja',
      'Camshaft exhaust actuator position A (bank 1) - low signal',
    ),
    'P2093': (
      'Posición actuador árbol de levas escape A (bloque 1) - señal alta',
      'Camshaft exhaust actuator position A (bank 1) - high signal',
    ),
    'P2094': (
      'Posición actuador árbol de levas escape B (bloque 2) - señal baja',
      'Camshaft exhaust actuator position B (bank 2) - low signal',
    ),
    'P2095': (
      'Posición actuador árbol de levas escape B (bloque 2) - señal alta',
      'Camshaft exhaust actuator position B (bank 2) - high signal',
    ),
    'P2096': (
      'Corrección combustible post catalizador demasiado pobre (bloque 1)',
      'Post catalyst fuel trim too lean (bank 1)',
    ),
    'P2097': (
      'Corrección combustible post catalizador demasiado rico (bloque 1)',
      'Post catalyst fuel trim too rich (bank 1)',
    ),
    'P2098': (
      'Corrección combustible post catalizador demasiado pobre (bloque 2)',
      'Post catalyst fuel trim too lean (bank 2)',
    ),
    'P2099': (
      'Corrección combustible post catalizador demasiado rico (bloque 2)',
      'Post catalyst fuel trim too rich (bank 2)',
    ),
    'P2100': (
      'Circuito motor actuador mariposa - circuito abierto',
      'Throttle actuator motor circuit - open circuit',
    ),
    'P2101': (
      'Circuito motor actuador mariposa - rango, funcionamiento',
      'Throttle actuator motor circuit - range/performance',
    ),
    'P2102': (
      'Circuito motor actuador mariposa - señal baja',
      'Throttle actuator motor circuit - low signal',
    ),
    'P2103': (
      'Circuito motor actuador mariposa - señal alta',
      'Throttle actuator motor circuit - high signal',
    ),
    'P2104': (
      'Sistema actuador mariposa - modo ralentí forzado',
      'Throttle actuator system - forced idle mode',
    ),
    'P2105': (
      'Sistema actuador mariposa - modo apagado forzado',
      'Throttle actuator system - forced shutdown mode',
    ),
    'P2106': (
      'Sistema actuador mariposa - modo potencia limitada forzado',
      'Throttle actuator system - forced limited power mode',
    ),
    'P2107': (
      'Módulo control actuador mariposa - error procesador',
      'Throttle actuator control module - processor error',
    ),
    'P2108': (
      'Módulo control actuador mariposa - rendimiento',
      'Throttle actuator control module - performance',
    ),
    'P2110': (
      'Sistema actuador mariposa - RPM limitadas forzado',
      'Throttle actuator system - forced limited RPM',
    ),
    'P2111': (
      'Sistema actuador mariposa - atascado abierto',
      'Throttle actuator system - stuck open',
    ),
    'P2112': (
      'Sistema actuador mariposa - atascado cerrado',
      'Throttle actuator system - stuck closed',
    ),
    'P2118': (
      'Circuito motor actuador mariposa - corriente fuera de rango',
      'Throttle actuator motor circuit - current out of range',
    ),
    'P2119': (
      'Cuerpo mariposa - rango, funcionamiento',
      'Throttle body - range/performance',
    ),
    'P2120': (
      'Sensor posición pedal acelerador D - circuito defectuoso',
      'Accelerator pedal position sensor D - faulty circuit',
    ),
    'P2121': (
      'Sensor posición pedal acelerador D - rango, funcionamiento',
      'Accelerator pedal position sensor D - range/performance',
    ),
    'P2122': (
      'Sensor posición pedal acelerador D - señal baja',
      'Accelerator pedal position sensor D - low signal',
    ),
    'P2123': (
      'Sensor posición pedal acelerador D - señal alta',
      'Accelerator pedal position sensor D - high signal',
    ),
    'P2124': (
      'Sensor posición pedal acelerador D - interrupción intermitente',
      'Accelerator pedal position sensor D - intermittent',
    ),
    'P2125': (
      'Sensor posición pedal acelerador E - circuito defectuoso',
      'Accelerator pedal position sensor E - faulty circuit',
    ),
    'P2126': (
      'Sensor posición pedal acelerador E - rango, funcionamiento',
      'Accelerator pedal position sensor E - range/performance',
    ),
    'P2127': (
      'Sensor posición pedal acelerador E - señal baja',
      'Accelerator pedal position sensor E - low signal',
    ),
    'P2128': (
      'Sensor posición pedal acelerador E - señal alta',
      'Accelerator pedal position sensor E - high signal',
    ),
    'P2129': (
      'Sensor posición pedal acelerador E - interrupción intermitente',
      'Accelerator pedal position sensor E - intermittent',
    ),
    'P2130': (
      'Sensor posición pedal acelerador F - circuito defectuoso',
      'Accelerator pedal position sensor F - faulty circuit',
    ),
    'P2131': (
      'Sensor posición pedal acelerador F - rango, funcionamiento',
      'Accelerator pedal position sensor F - range/performance',
    ),
    'P2132': (
      'Sensor posición pedal acelerador F - señal baja',
      'Accelerator pedal position sensor F - low signal',
    ),
    'P2133': (
      'Sensor posición pedal acelerador F - señal alta',
      'Accelerator pedal position sensor F - high signal',
    ),
    'P2134': (
      'Sensor posición pedal acelerador F - interrupción intermitente',
      'Accelerator pedal position sensor F - intermittent',
    ),
    'P2135': (
      'Correlación sensor posición mariposa/pedal acelerador A/B',
      'Throttle/pedal position sensor A/B correlation',
    ),
    'P2136': (
      'Correlación sensor posición mariposa/pedal acelerador A/C',
      'Throttle/pedal position sensor A/C correlation',
    ),
    'P2137': (
      'Correlación sensor posición mariposa/pedal acelerador B/C',
      'Throttle/pedal position sensor B/C correlation',
    ),
    'P2138': (
      'Correlación sensor posición pedal acelerador D/E',
      'Accelerator pedal position sensor D/E correlation',
    ),
    'P2139': (
      'Correlación sensor posición pedal acelerador D/F',
      'Accelerator pedal position sensor D/F correlation',
    ),
    'P2140': (
      'Correlación sensor posición pedal acelerador E/F',
      'Accelerator pedal position sensor E/F correlation',
    ),
    'P2141': (
      'Circuito sensor recirculación gases escape A - señal baja',
      'EGR sensor A circuit - low signal',
    ),
    'P2142': (
      'Circuito sensor recirculación gases escape A - señal alta',
      'EGR sensor A circuit - high signal',
    ),
    'P2143': (
      'Circuito sensor recirculación gases escape B - circuito defectuoso',
      'EGR sensor B circuit - faulty circuit',
    ),
    'P2144': (
      'Circuito sensor recirculación gases escape B - señal baja',
      'EGR sensor B circuit - low signal',
    ),
    'P2145': (
      'Circuito sensor recirculación gases escape B - señal alta',
      'EGR sensor B circuit - high signal',
    ),
    'P2146': (
      'Grupo A alimentación inyectores - circuito abierto',
      'Fuel injector group A supply - open circuit',
    ),
    'P2147': (
      'Grupo A alimentación inyectores - señal baja',
      'Fuel injector group A supply - low signal',
    ),
    'P2148': (
      'Grupo A alimentación inyectores - señal alta',
      'Fuel injector group A supply - high signal',
    ),
    'P2149': (
      'Grupo B alimentación inyectores - circuito abierto',
      'Fuel injector group B supply - open circuit',
    ),
    'P2150': (
      'Grupo B alimentación inyectores - señal baja',
      'Fuel injector group B supply - low signal',
    ),
    'P2151': (
      'Grupo B alimentación inyectores - señal alta',
      'Fuel injector group B supply - high signal',
    ),
    'P2176': (
      'Sistema actuador mariposa - posición reposo no aprendida',
      'Throttle actuator system - rest position not learned',
    ),
    'P2177': (
      'Sistema demasiado pobre fuera de ralentí (bloque 1)',
      'System too lean off idle (bank 1)',
    ),
    'P2178': (
      'Sistema demasiado rico fuera de ralentí (bloque 1)',
      'System too rich off idle (bank 1)',
    ),
    'P2179': (
      'Sistema demasiado pobre fuera de ralentí (bloque 2)',
      'System too lean off idle (bank 2)',
    ),
    'P2180': (
      'Sistema demasiado rico fuera de ralentí (bloque 2)',
      'System too rich off idle (bank 2)',
    ),
    'P2181': (
      'Sistema refrigeración - rendimiento',
      'Cooling system - performance',
    ),
    'P2182': (
      'Sensor temperatura refrigerante motor 2 - circuito defectuoso',
      'Engine coolant temperature sensor 2 - faulty circuit',
    ),
    'P2183': (
      'Sensor temperatura refrigerante motor 2 - rango, funcionamiento',
      'Engine coolant temperature sensor 2 - range/performance',
    ),
    'P2184': (
      'Sensor temperatura refrigerante motor 2 - señal baja',
      'Engine coolant temperature sensor 2 - low signal',
    ),
    'P2185': (
      'Sensor temperatura refrigerante motor 2 - señal alta',
      'Engine coolant temperature sensor 2 - high signal',
    ),
    'P2186': (
      'Sensor temperatura refrigerante motor 2 - interrupción intermitente',
      'Engine coolant temperature sensor 2 - intermittent',
    ),
    'P2187': (
      'Sistema demasiado pobre en ralentí (bloque 1)',
      'System too lean at idle (bank 1)',
    ),
    'P2188': (
      'Sistema demasiado rico en ralentí (bloque 1)',
      'System too rich at idle (bank 1)',
    ),
    'P2189': (
      'Sistema demasiado pobre en ralentí (bloque 2)',
      'System too lean at idle (bank 2)',
    ),
    'P2190': (
      'Sistema demasiado rico en ralentí (bloque 2)',
      'System too rich at idle (bank 2)',
    ),
    'P2191': (
      'Sistema demasiado pobre a alta carga (bloque 1)',
      'System too lean at high load (bank 1)',
    ),
    'P2192': (
      'Sistema demasiado rico a alta carga (bloque 1)',
      'System too rich at high load (bank 1)',
    ),
    'P2193': (
      'Sistema demasiado pobre a alta carga (bloque 2)',
      'System too lean at high load (bank 2)',
    ),
    'P2194': (
      'Sistema demasiado rico a alta carga (bloque 2)',
      'System too rich at high load (bank 2)',
    ),
    'P2195': (
      'Sensor oxígeno (bloque 1 sensor 1) - señal atascada pobre',
      'O2 sensor (bank 1 sensor 1) - signal stuck lean',
    ),
    'P2196': (
      'Sensor oxígeno (bloque 1 sensor 1) - señal atascada rica',
      'O2 sensor (bank 1 sensor 1) - signal stuck rich',
    ),
    'P2197': (
      'Sensor oxígeno (bloque 2 sensor 1) - señal atascada pobre',
      'O2 sensor (bank 2 sensor 1) - signal stuck lean',
    ),
    'P2198': (
      'Sensor oxígeno (bloque 2 sensor 1) - señal atascada rica',
      'O2 sensor (bank 2 sensor 1) - signal stuck rich',
    ),
    'P2199': (
      'Correlación sensor temperatura aire admisión 1/2',
      'Intake air temperature sensor 1/2 correlation',
    ),
    'P2200': (
      'Sensor NOx - circuito defectuoso (bloque 1)',
      'NOx sensor - faulty circuit (bank 1)',
    ),
    'P2201': (
      'Sensor NOx - rango, funcionamiento (bloque 1)',
      'NOx sensor - range/performance (bank 1)',
    ),
    'P2202': (
      'Sensor NOx - señal baja (bloque 1)',
      'NOx sensor - low signal (bank 1)',
    ),
    'P2203': (
      'Sensor NOx - señal alta (bloque 1)',
      'NOx sensor - high signal (bank 1)',
    ),
    'P2204': (
      'Sensor NOx - interrupción intermitente (bloque 1)',
      'NOx sensor - intermittent (bank 1)',
    ),
    'P2205': (
      'Calentador sensor NOx (bloque 1) - circuito defectuoso',
      'NOx sensor heater (bank 1) - faulty circuit',
    ),
    'P2206': (
      'Calentador sensor NOx (bloque 1) - señal baja',
      'NOx sensor heater (bank 1) - low signal',
    ),
    'P2207': (
      'Calentador sensor NOx (bloque 1) - señal alta',
      'NOx sensor heater (bank 1) - high signal',
    ),
    'P2208': (
      'Sensor NOx - circuito defectuoso (bloque 2)',
      'NOx sensor - faulty circuit (bank 2)',
    ),
    'P2209': (
      'Sensor NOx - rango, funcionamiento (bloque 2)',
      'NOx sensor - range/performance (bank 2)',
    ),
    'P2226': (
      'Sensor presión barométrica - circuito defectuoso',
      'Barometric pressure sensor - faulty circuit',
    ),
    'P2227': (
      'Sensor presión barométrica - rango, funcionamiento',
      'Barometric pressure sensor - range/performance',
    ),
    'P2228': (
      'Sensor presión barométrica - señal baja',
      'Barometric pressure sensor - low signal',
    ),
    'P2229': (
      'Sensor presión barométrica - señal alta',
      'Barometric pressure sensor - high signal',
    ),
    'P2230': (
      'Sensor presión barométrica - interrupción intermitente',
      'Barometric pressure sensor - intermittent',
    ),
    'P2231': (
      'Señal sensor oxígeno (bloque 1 sensor 1) - cortocircuito a calentador',
      'O2 sensor signal (bank 1 sensor 1) - short to heater',
    ),
    'P2232': (
      'Señal sensor oxígeno (bloque 1 sensor 2) - cortocircuito a calentador',
      'O2 sensor signal (bank 1 sensor 2) - short to heater',
    ),
    'P2237': (
      'Corriente positiva sensor oxígeno (bloque 1 sensor 1) - circuito defectuoso',
      'O2 sensor positive current (bank 1 sensor 1) - faulty circuit',
    ),
    'P2240': (
      'Corriente positiva sensor oxígeno (bloque 2 sensor 1) - circuito defectuoso',
      'O2 sensor positive current (bank 2 sensor 1) - faulty circuit',
    ),
    'P2243': (
      'Tensión referencia sensor oxígeno (bloque 1 sensor 1) - circuito defectuoso',
      'O2 sensor reference voltage (bank 1 sensor 1) - faulty circuit',
    ),
    'P2247': (
      'Tensión referencia sensor oxígeno (bloque 2 sensor 1) - circuito defectuoso',
      'O2 sensor reference voltage (bank 2 sensor 1) - faulty circuit',
    ),
    'P2251': (
      'Corriente negativa sensor oxígeno (bloque 1 sensor 1) - circuito defectuoso',
      'O2 sensor negative current (bank 1 sensor 1) - faulty circuit',
    ),
    'P2254': (
      'Corriente negativa sensor oxígeno (bloque 2 sensor 1) - circuito defectuoso',
      'O2 sensor negative current (bank 2 sensor 1) - faulty circuit',
    ),
    'P2261': (
      'Válvula derivación turbocompresor - mecánica',
      'Turbocharger bypass valve - mechanical',
    ),
    'P2262': (
      'Presión sobrealimentación turbo - no detectada (mecánica)',
      'Turbo boost pressure - not detected (mechanical)',
    ),
    'P2263': (
      'Rendimiento sobrealimentación turbo/supercargador',
      'Turbo/supercharger boost performance',
    ),
    'P2264': (
      'Sensor presencia agua combustible - circuito defectuoso',
      'Fuel water presence sensor - faulty circuit',
    ),
    'P2265': (
      'Sensor presencia agua combustible - rango, funcionamiento',
      'Fuel water presence sensor - range/performance',
    ),
    'P2266': (
      'Sensor presencia agua combustible - señal baja',
      'Fuel water presence sensor - low signal',
    ),
    'P2267': (
      'Sensor presencia agua combustible - señal alta',
      'Fuel water presence sensor - high signal',
    ),
    'P2269': ('Sensor calidad agua combustible', 'Fuel water quality sensor'),
    'P2270': (
      'Sensor oxígeno (bloque 1 sensor 2) - señal atascada pobre',
      'O2 sensor (bank 1 sensor 2) - signal stuck lean',
    ),
    'P2271': (
      'Sensor oxígeno (bloque 1 sensor 2) - señal atascada rica',
      'O2 sensor (bank 1 sensor 2) - signal stuck rich',
    ),
    'P2272': (
      'Sensor oxígeno (bloque 2 sensor 2) - señal atascada pobre',
      'O2 sensor (bank 2 sensor 2) - signal stuck lean',
    ),
    'P2273': (
      'Sensor oxígeno (bloque 2 sensor 2) - señal atascada rica',
      'O2 sensor (bank 2 sensor 2) - signal stuck rich',
    ),
    'P2279': ('Fuga sistema admisión aire', 'Intake air system leak'),
    'P2280': (
      'Restricción flujo aire entre filtro y MAF',
      'Air flow restriction between filter and MAF',
    ),
    'P2281': (
      'Fuga aire entre MAF y mariposa',
      'Air leak between MAF and throttle',
    ),
    'P2282': (
      'Fuga aire entre mariposa y válvulas admisión',
      'Air leak between throttle and intake valves',
    ),
    'P2290': (
      'Presión control inyector demasiado baja',
      'Injector control pressure too low',
    ),
    'P2291': (
      'Presión control inyector demasiado baja - motor arrancando',
      'Injector control pressure too low - engine cranking',
    ),
    'P2292': (
      'Presión control inyector - errática',
      'Injector control pressure - erratic',
    ),
    'P2293': (
      'Regulador presión rampa combustible 2 - rendimiento',
      'Fuel rail pressure regulator 2 - performance',
    ),
    'P2294': (
      'Regulador presión rampa combustible 2 - circuito abierto',
      'Fuel rail pressure regulator 2 - open circuit',
    ),
    'P2295': (
      'Regulador presión rampa combustible 2 - señal baja',
      'Fuel rail pressure regulator 2 - low signal',
    ),
    'P2296': (
      'Regulador presión rampa combustible 2 - señal alta',
      'Fuel rail pressure regulator 2 - high signal',
    ),
    'P2297': (
      'Sensor oxígeno (bloque 1 sensor 1) - señal fuera de rango durante desaceleración',
      'O2 sensor (bank 1 sensor 1) - signal out of range during deceleration',
    ),
    'P2298': (
      'Sensor oxígeno (bloque 2 sensor 1) - señal fuera de rango durante desaceleración',
      'O2 sensor (bank 2 sensor 1) - signal out of range during deceleration',
    ),
    'P2299': (
      'Sensor posición pedal freno/mariposa - correlación incompatible',
      'Brake pedal/throttle position sensor - incompatible correlation',
    ),
    'P2300': (
      'Circuito bobina encendido A - señal baja',
      'Ignition coil A circuit - low signal',
    ),
    'P2301': (
      'Circuito bobina encendido A - señal alta',
      'Ignition coil A circuit - high signal',
    ),
    'P2302': (
      'Circuito bobina encendido B - señal baja',
      'Ignition coil B circuit - low signal',
    ),
    'P2303': (
      'Circuito bobina encendido B - señal alta',
      'Ignition coil B circuit - high signal',
    ),
    'P2304': (
      'Circuito bobina encendido C - señal baja',
      'Ignition coil C circuit - low signal',
    ),
    'P2305': (
      'Circuito bobina encendido C - señal alta',
      'Ignition coil C circuit - high signal',
    ),
    'P2306': (
      'Circuito bobina encendido D - señal baja',
      'Ignition coil D circuit - low signal',
    ),
    'P2307': (
      'Circuito bobina encendido D - señal alta',
      'Ignition coil D circuit - high signal',
    ),
    'P2400': (
      'Circuito bomba detección fugas EVAP - defectuoso',
      'EVAP leak detection pump circuit - faulty',
    ),
    'P2401': (
      'Circuito bomba detección fugas EVAP - señal baja',
      'EVAP leak detection pump circuit - low signal',
    ),
    'P2402': (
      'Circuito bomba detección fugas EVAP - señal alta',
      'EVAP leak detection pump circuit - high signal',
    ),
    'P2403': (
      'Circuito bomba detección fugas EVAP - interrupción intermitente',
      'EVAP leak detection pump circuit - intermittent',
    ),
    'P2404': (
      'Sensor bomba detección fugas EVAP - rango, funcionamiento',
      'EVAP leak detection pump sensor - range/performance',
    ),
    'P2419': (
      'Válvula conmutación EVAP - señal baja',
      'EVAP switching valve - low signal',
    ),
    'P2420': (
      'Válvula conmutación EVAP - señal alta',
      'EVAP switching valve - high signal',
    ),
    'P2431': (
      'Bomba inyección aire secundario - rendimiento (bloque 1)',
      'Secondary air injection pump - performance (bank 1)',
    ),
    'P2432': (
      'Bomba inyección aire secundario - rendimiento (bloque 2)',
      'Secondary air injection pump - performance (bank 2)',
    ),
    'P2440': (
      'Válvula conmutación inyección aire secundario (bloque 1) - atascada abierta',
      'Secondary air injection switching valve (bank 1) - stuck open',
    ),
    'P2441': (
      'Válvula conmutación inyección aire secundario (bloque 1) - atascada cerrada',
      'Secondary air injection switching valve (bank 1) - stuck closed',
    ),
    'P2442': (
      'Válvula conmutación inyección aire secundario (bloque 2) - atascada abierta',
      'Secondary air injection switching valve (bank 2) - stuck open',
    ),
    'P2443': (
      'Válvula conmutación inyección aire secundario (bloque 2) - atascada cerrada',
      'Secondary air injection switching valve (bank 2) - stuck closed',
    ),
    'P2444': (
      'Sistema inyección aire secundario - bomba atascada activada (bloque 1)',
      'Secondary air injection system - pump stuck on (bank 1)',
    ),
    'P2445': (
      'Sistema inyección aire secundario - bomba atascada desactivada (bloque 1)',
      'Secondary air injection system - pump stuck off (bank 1)',
    ),
    'P2446': (
      'Sistema inyección aire secundario - bomba atascada activada (bloque 2)',
      'Secondary air injection system - pump stuck on (bank 2)',
    ),
    'P2447': (
      'Sistema inyección aire secundario - bomba atascada desactivada (bloque 2)',
      'Secondary air injection system - pump stuck off (bank 2)',
    ),
    'P2500': (
      'Circuito lámpara/indicador carga alternador - defectuoso',
      'Alternator charge indicator/lamp circuit - faulty',
    ),
    'P2501': (
      'Circuito lámpara/indicador carga alternador - señal baja',
      'Alternator charge indicator/lamp circuit - low signal',
    ),
    'P2502': (
      'Circuito lámpara/indicador carga alternador - señal alta',
      'Alternator charge indicator/lamp circuit - high signal',
    ),
    'P2503': (
      'Circuito alimentación sistema carga - señal baja',
      'Charging system supply circuit - low signal',
    ),
    'P2504': (
      'Circuito alimentación sistema carga - señal alta',
      'Charging system supply circuit - high signal',
    ),
    'P2530': (
      'Circuito interruptor solicitud encendido - defectuoso',
      'Ignition request switch circuit - faulty',
    ),
    'P2531': (
      'Circuito interruptor solicitud encendido - señal baja',
      'Ignition request switch circuit - low signal',
    ),
    'P2532': (
      'Circuito interruptor solicitud encendido - señal alta',
      'Ignition request switch circuit - high signal',
    ),
    'P2544': (
      'Solicitud par motor A - rango, funcionamiento',
      'Torque management request A - range/performance',
    ),
    'P2545': (
      'Solicitud par motor B - rango, funcionamiento',
      'Torque management request B - range/performance',
    ),
    'P2550': (
      'Actuador posición árbol de levas admisión (bloque 1) - circuito defectuoso',
      'Camshaft intake position actuator (bank 1) - faulty circuit',
    ),
    'P2551': (
      'Actuador posición árbol de levas admisión (bloque 1) - rango, funcionamiento',
      'Camshaft intake position actuator (bank 1) - range/performance',
    ),
    'P2552': (
      'Actuador posición árbol de levas admisión (bloque 1) - señal baja',
      'Camshaft intake position actuator (bank 1) - low signal',
    ),
    'P2553': (
      'Actuador posición árbol de levas admisión (bloque 1) - señal alta',
      'Camshaft intake position actuator (bank 1) - high signal',
    ),
    'P2600': (
      'Circuito control bomba refrigerante - abierto',
      'Coolant pump control circuit - open',
    ),
    'P2601': (
      'Circuito control bomba refrigerante - rango, funcionamiento',
      'Coolant pump control circuit - range/performance',
    ),
    'P2602': (
      'Circuito control bomba refrigerante - señal baja',
      'Coolant pump control circuit - low signal',
    ),
    'P2603': (
      'Circuito control bomba refrigerante - señal alta',
      'Coolant pump control circuit - high signal',
    ),
    'P2610': (
      'Temporizador posición ECM/PCM - rendimiento',
      'ECM/PCM position timer - performance',
    ),
    'P2626': (
      'Corriente bombeo sensor oxígeno (bloque 1 sensor 1) - circuito abierto',
      'O2 sensor pumping current (bank 1 sensor 1) - open circuit',
    ),
    'P2627': (
      'Corriente bombeo sensor oxígeno (bloque 1 sensor 1) - señal baja',
      'O2 sensor pumping current (bank 1 sensor 1) - low signal',
    ),
    'P2628': (
      'Corriente bombeo sensor oxígeno (bloque 1 sensor 1) - señal alta',
      'O2 sensor pumping current (bank 1 sensor 1) - high signal',
    ),
    'P2629': (
      'Corriente bombeo sensor oxígeno (bloque 2 sensor 1) - circuito abierto',
      'O2 sensor pumping current (bank 2 sensor 1) - open circuit',
    ),
    'P2630': (
      'Corriente bombeo sensor oxígeno (bloque 2 sensor 1) - señal baja',
      'O2 sensor pumping current (bank 2 sensor 1) - low signal',
    ),
    'P2631': (
      'Corriente bombeo sensor oxígeno (bloque 2 sensor 1) - señal alta',
      'O2 sensor pumping current (bank 2 sensor 1) - high signal',
    ),
    'P2646': (
      'Rocker arm actuador A (bloque 1) - rendimiento o atascado desactivado',
      'Rocker arm actuator A (bank 1) - performance or stuck off',
    ),
    'P2647': (
      'Rocker arm actuador A (bloque 1) - atascado activado',
      'Rocker arm actuator A (bank 1) - stuck on',
    ),
    'P2648': (
      'Rocker arm actuador A (bloque 1) - señal baja',
      'Rocker arm actuator A (bank 1) - low signal',
    ),
    'P2649': (
      'Rocker arm actuador A (bloque 1) - señal alta',
      'Rocker arm actuator A (bank 1) - high signal',
    ),
    'P2650': (
      'Rocker arm actuador B (bloque 1) - rendimiento o atascado desactivado',
      'Rocker arm actuator B (bank 1) - performance or stuck off',
    ),
    'P2700': (
      'Solenoide cambio F - circuito defectuoso',
      'Shift solenoid F - faulty circuit',
    ),
    'P2701': (
      'Solenoide cambio F - rendimiento o atascado desactivado',
      'Shift solenoid F - performance or stuck off',
    ),
    'P2702': (
      'Solenoide cambio F - atascado activado',
      'Shift solenoid F - stuck on',
    ),
    'P2703': (
      'Solenoide cambio F - eléctrico',
      'Shift solenoid F - electrical',
    ),
    'P2704': (
      'Solenoide cambio F - interrupción intermitente',
      'Shift solenoid F - intermittent',
    ),
    'P2705': (
      'Solenoide cambio G - circuito defectuoso',
      'Shift solenoid G - faulty circuit',
    ),
    'P2706': (
      'Solenoide cambio G - rendimiento o atascado desactivado',
      'Shift solenoid G - performance or stuck off',
    ),
    'P2707': (
      'Solenoide cambio G - atascado activado',
      'Shift solenoid G - stuck on',
    ),
    'P2708': (
      'Solenoide cambio G - eléctrico',
      'Shift solenoid G - electrical',
    ),
    'P2709': (
      'Solenoide cambio G - interrupción intermitente',
      'Shift solenoid G - intermittent',
    ),
    'P2714': (
      'Solenoide control presión D - circuito defectuoso',
      'Pressure control solenoid D - faulty circuit',
    ),
    'P2715': (
      'Solenoide control presión D - rendimiento o atascado desactivado',
      'Pressure control solenoid D - performance or stuck off',
    ),
    'P2716': (
      'Solenoide control presión D - atascado activado',
      'Pressure control solenoid D - stuck on',
    ),
    'P2717': (
      'Solenoide control presión D - eléctrico',
      'Pressure control solenoid D - electrical',
    ),
    'P2718': (
      'Solenoide control presión D - interrupción intermitente',
      'Pressure control solenoid D - intermittent',
    ),
    'P2719': (
      'Solenoide control presión E - circuito defectuoso',
      'Pressure control solenoid E - faulty circuit',
    ),
    'P2720': (
      'Solenoide control presión E - rendimiento o atascado desactivado',
      'Pressure control solenoid E - performance or stuck off',
    ),
    'P2721': (
      'Solenoide control presión E - atascado activado',
      'Pressure control solenoid E - stuck on',
    ),
    'P2722': (
      'Solenoide control presión E - eléctrico',
      'Pressure control solenoid E - electrical',
    ),
    'P2723': (
      'Solenoide control presión E - interrupción intermitente',
      'Pressure control solenoid E - intermittent',
    ),
    'P2750': (
      'Solenoide embrague convertidor par - circuito defectuoso',
      'Torque converter clutch solenoid - faulty circuit',
    ),
    'P2751': (
      'Solenoide embrague convertidor par - rendimiento o atascado desactivado',
      'Torque converter clutch solenoid - performance or stuck off',
    ),
    'P2752': (
      'Solenoide embrague convertidor par - atascado activado',
      'Torque converter clutch solenoid - stuck on',
    ),
    'P2753': (
      'Solenoide embrague convertidor par - eléctrico',
      'Torque converter clutch solenoid - electrical',
    ),
    'P2754': (
      'Solenoide embrague convertidor par - interrupción intermitente',
      'Torque converter clutch solenoid - intermittent',
    ),
    'P2757': (
      'Embrague convertidor par - circuito control presión defectuoso',
      'Torque converter clutch - pressure control circuit fault',
    ),
    'P2758': (
      'Embrague convertidor par - circuito control presión señal baja',
      'Torque converter clutch - pressure control circuit low signal',
    ),
    'P2759': (
      'Embrague convertidor par - circuito control presión señal alta',
      'Torque converter clutch - pressure control circuit high signal',
    ),
    'P2761': (
      'Embrague convertidor par - circuito control presión abierto',
      'Torque converter clutch - pressure control circuit open',
    ),
    'P2762': (
      'Embrague convertidor par - circuito control presión rango, funcionamiento',
      'Torque converter clutch - pressure control circuit range/performance',
    ),
    'P2763': (
      'Embrague convertidor par - circuito control presión señal alta',
      'Torque converter clutch - pressure control circuit high',
    ),
    'P2764': (
      'Embrague convertidor par - circuito control presión señal baja',
      'Torque converter clutch - pressure control circuit low',
    ),
    'P2769': (
      'Embrague convertidor par - señal baja',
      'Torque converter clutch - low signal',
    ),
    'P2770': (
      'Embrague convertidor par - señal alta',
      'Torque converter clutch - high signal',
    ),
    'P2800': (
      'Sensor rango transmisión B - circuito defectuoso',
      'Transmission range sensor B - faulty circuit',
    ),
    'P2801': (
      'Sensor rango transmisión B - rango, funcionamiento',
      'Transmission range sensor B - range/performance',
    ),
    'P2802': (
      'Sensor rango transmisión B - señal baja',
      'Transmission range sensor B - low signal',
    ),
    'P2803': (
      'Sensor rango transmisión B - señal alta',
      'Transmission range sensor B - high signal',
    ),
    'P2804': (
      'Sensor rango transmisión B - interrupción intermitente',
      'Transmission range sensor B - intermittent',
    ),
    'P2A00': (
      'Sensor oxígeno (bloque 1 sensor 1) - rango, funcionamiento circuito',
      'O2 sensor (bank 1 sensor 1) - circuit range/performance',
    ),
    'P2A01': (
      'Sensor oxígeno (bloque 1 sensor 2) - rango, funcionamiento circuito',
      'O2 sensor (bank 1 sensor 2) - circuit range/performance',
    ),
    'P2A02': (
      'Sensor oxígeno (bloque 2 sensor 1) - rango, funcionamiento circuito',
      'O2 sensor (bank 2 sensor 1) - circuit range/performance',
    ),
    'P2A03': (
      'Sensor oxígeno (bloque 2 sensor 2) - rango, funcionamiento circuito',
      'O2 sensor (bank 2 sensor 2) - circuit range/performance',
    ),
    // Common B-codes (Body)
    'B0001': (
      'Circuito control airbag conductor - defectuoso',
      'Driver airbag control circuit - faulty',
    ),
    'B0002': (
      'Circuito control airbag pasajero - defectuoso',
      'Passenger airbag control circuit - faulty',
    ),
    'B0100': (
      'Circuito airbag frontal conductor - defectuoso',
      'Driver front airbag circuit - faulty',
    ),
    'B0101': (
      'Circuito airbag frontal pasajero - defectuoso',
      'Passenger front airbag circuit - faulty',
    ),
    // Common C-codes (Chassis)
    'C0035': (
      'Sensor velocidad rueda delantera izquierda - circuito defectuoso',
      'Left front wheel speed sensor - faulty circuit',
    ),
    'C0040': (
      'Sensor velocidad rueda delantera derecha - circuito defectuoso',
      'Right front wheel speed sensor - faulty circuit',
    ),
    'C0045': (
      'Sensor velocidad rueda trasera izquierda - circuito defectuoso',
      'Left rear wheel speed sensor - faulty circuit',
    ),
    'C0050': (
      'Sensor velocidad rueda trasera derecha - circuito defectuoso',
      'Right rear wheel speed sensor - faulty circuit',
    ),
    'C0060': (
      'Circuito solenoide ABS delantera izquierda - defectuoso',
      'Left front ABS solenoid circuit - faulty',
    ),
    'C0065': (
      'Circuito solenoide ABS delantera derecha - defectuoso',
      'Right front ABS solenoid circuit - faulty',
    ),
    'C0070': (
      'Circuito solenoide ABS trasera izquierda - defectuoso',
      'Left rear ABS solenoid circuit - faulty',
    ),
    'C0075': (
      'Circuito solenoide ABS trasera derecha - defectuoso',
      'Right rear ABS solenoid circuit - faulty',
    ),
    'C0110': (
      'Circuito motor bomba ABS - defectuoso',
      'ABS pump motor circuit - faulty',
    ),
    'C0121': (
      'Válvula solenoide control tracción - defectuoso',
      'Traction control solenoid valve - faulty',
    ),
    'C0161': (
      'Circuito interruptor freno ABS - defectuoso',
      'ABS brake switch circuit - faulty',
    ),
    'C0265': (
      'Relé motor bomba EBCM - circuito abierto',
      'EBCM pump motor relay - open circuit',
    ),
    'C0550': (
      'Módulo control electrónico - rendimiento',
      'Electronic control module - performance',
    ),
    // Common U-codes (Network)
    'U0001': (
      'Bus CAN alta velocidad - defectuoso',
      'High speed CAN bus - faulty',
    ),
    'U0002': (
      'Bus CAN alta velocidad - rendimiento',
      'High speed CAN bus - performance',
    ),
    'U0003': ('Bus CAN alta velocidad - abierto', 'High speed CAN bus - open'),
    'U0004': (
      'Bus CAN alta velocidad - señal baja',
      'High speed CAN bus - low signal',
    ),
    'U0005': (
      'Bus CAN alta velocidad - señal alta',
      'High speed CAN bus - high signal',
    ),
    'U0100': (
      'Pérdida comunicación con ECM/PCM A',
      'Lost communication with ECM/PCM A',
    ),
    'U0101': ('Pérdida comunicación con TCM', 'Lost communication with TCM'),
    'U0102': (
      'Pérdida comunicación con módulo caja transferencia',
      'Lost communication with transfer case module',
    ),
    'U0103': (
      'Pérdida comunicación con módulo cambio de marchas',
      'Lost communication with gear shift module',
    ),
    'U0104': (
      'Pérdida comunicación con módulo control crucero',
      'Lost communication with cruise control module',
    ),
    'U0105': (
      'Pérdida comunicación con módulo control combustible',
      'Lost communication with fuel injector control module',
    ),
    'U0106': (
      'Pérdida comunicación con módulo bujías incandescentes',
      'Lost communication with glow plug control module',
    ),
    'U0107': (
      'Pérdida comunicación con módulo control mariposa',
      'Lost communication with throttle actuator control module',
    ),
    'U0108': (
      'Pérdida comunicación con módulo combustible alternativo',
      'Lost communication with alternative fuel control module',
    ),
    'U0109': (
      'Pérdida comunicación con módulo control bomba combustible',
      'Lost communication with fuel pump control module',
    ),
    'U0110': (
      'Pérdida comunicación con módulo control tracción',
      'Lost communication with drive control module',
    ),
    'U0111': (
      'Pérdida comunicación con módulo control batería',
      'Lost communication with battery energy control module',
    ),
    'U0121': (
      'Pérdida comunicación con módulo control ABS',
      'Lost communication with ABS control module',
    ),
    'U0122': (
      'Pérdida comunicación con módulo control estabilidad',
      'Lost communication with vehicle stability control module',
    ),
    'U0126': (
      'Pérdida comunicación con módulo control dirección',
      'Lost communication with steering control module',
    ),
    'U0128': (
      'Pérdida comunicación con módulo control estacionamiento',
      'Lost communication with park brake control module',
    ),
    'U0129': (
      'Pérdida comunicación con módulo control freno',
      'Lost communication with brake system control module',
    ),
    'U0131': (
      'Pérdida comunicación con módulo control dirección asistida',
      'Lost communication with power steering control module',
    ),
    'U0140': (
      'Pérdida comunicación con módulo control carrocería',
      'Lost communication with body control module',
    ),
    'U0141': (
      'Pérdida comunicación con módulo control carrocería A',
      'Lost communication with body control module A',
    ),
    'U0142': (
      'Pérdida comunicación con módulo control carrocería B',
      'Lost communication with body control module B',
    ),
    'U0151': (
      'Pérdida comunicación con módulo control restricción',
      'Lost communication with restraint control module',
    ),
    'U0155': (
      'Pérdida comunicación con módulo control instrumentos',
      'Lost communication with instrument cluster control module',
    ),
    'U0164': (
      'Pérdida comunicación con módulo control climatización',
      'Lost communication with HVAC control module',
    ),
    'U0167': (
      'Pérdida comunicación con módulo control seguridad',
      'Lost communication with vehicle security control module',
    ),
    'U0168': (
      'Pérdida comunicación con módulo control inmovilizador',
      'Lost communication with vehicle immobilizer control module',
    ),
    'U0184': (
      'Pérdida comunicación con módulo control audio',
      'Lost communication with audio control module',
    ),
    'U0199': (
      'Pérdida comunicación con módulo control puerta A',
      'Lost communication with door control module A',
    ),
    'U0200': (
      'Pérdida comunicación con módulo control puerta B',
      'Lost communication with door control module B',
    ),
    'U0214': (
      'Pérdida comunicación con módulo control remoto',
      'Lost communication with remote control module',
    ),
    'U0230': (
      'Pérdida comunicación con módulo control asiento conductor',
      'Lost communication with driver seat control module',
    ),
    'U0235': (
      'Pérdida comunicación con módulo control columna dirección',
      'Lost communication with steering column control module',
    ),
    'U0300': (
      'Incompatibilidad software módulo interno',
      'Internal control module software incompatibility',
    ),
    'U0301': (
      'Incompatibilidad software con ECM/PCM',
      'Software incompatibility with ECM/PCM',
    ),
    'U0302': (
      'Incompatibilidad software con TCM',
      'Software incompatibility with TCM',
    ),
    'U0401': (
      'Datos inválidos recibidos de ECM/PCM',
      'Invalid data received from ECM/PCM',
    ),
    'U0402': (
      'Datos inválidos recibidos de TCM',
      'Invalid data received from TCM',
    ),
    'U0404': (
      'Datos inválidos recibidos de módulo cambio de marchas',
      'Invalid data received from gear shift module',
    ),
    'U0416': (
      'Datos inválidos recibidos de módulo control estabilidad',
      'Invalid data received from vehicle stability control module',
    ),
    'U0422': (
      'Datos inválidos recibidos de módulo control carrocería',
      'Invalid data received from body control module',
    ),
    'U0426': (
      'Datos inválidos recibidos de módulo control inmovilizador',
      'Invalid data received from immobilizer control module',
    ),
    'U1000': ('Bus CAN clase 2 - defectuoso', 'Class 2 CAN bus - faulty'),
    'U1001': (
      'Bus CAN clase 2 - pérdida comunicación',
      'Class 2 CAN bus - communication loss',
    ),
    'U1016': (
      'Pérdida comunicación con módulo control motor',
      'Lost communication with engine control module',
    ),
    'U1040': (
      'Pérdida comunicación con módulo control transmisión',
      'Lost communication with transmission control module',
    ),
    'U1073': (
      'Pérdida comunicación con módulo control carrocería',
      'Lost communication with body control module',
    ),
    'U1096': (
      'Pérdida comunicación con módulo control instrumentos',
      'Lost communication with instrument cluster module',
    ),
  };
}
