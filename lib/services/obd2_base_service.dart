import '../models/dtc_code.dart';

/// Interfaz común para servicios OBD2 (Bluetooth y WiFi)
abstract class Obd2BaseService {
  bool get isConnected;

  Future<void> disconnect();

  Future<int?> getRPM();
  Future<int?> getSpeed();
  Future<int?> getCoolantTemp();
  Future<int?> getEngineLoad();
  Future<int?> getIntakeManifoldPressure();
  Future<int?> getFuelLevel();
  Future<String?> getVIN();
  Future<String?> getProtocol();
  Future<List<DtcCode>> getDTCs();
  Future<bool> clearDTCs();

  void dispose();

  // Helpers compartidos para decodificar respuestas OBD2
  static int? parseOneByte(String? response, {int offset = 4}) {
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }
    try {
      final cleaned = response.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      if (cleaned.length >= offset + 2) {
        return int.parse(cleaned.substring(offset, offset + 2), radix: 16);
      }
    } catch (_) {}
    return null;
  }

  static int? parseTwoBytes(String? response, {int offset = 4}) {
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }
    try {
      final cleaned = response.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
      if (cleaned.length >= offset + 4) {
        final a = int.parse(cleaned.substring(offset, offset + 2), radix: 16);
        final b = int.parse(
          cleaned.substring(offset + 2, offset + 4),
          radix: 16,
        );
        return (a * 256) + b;
      }
    } catch (_) {}
    return null;
  }

  static String? decodeDTC(String hex) {
    if (hex.length < 4 || hex == '0000') return null;
    final firstChar = int.parse(hex[0], radix: 16);
    const prefix = [
      'P0',
      'P1',
      'P2',
      'P3',
      'C0',
      'C1',
      'C2',
      'C3',
      'B0',
      'B1',
      'B2',
      'B3',
      'U0',
      'U1',
      'U2',
      'U3',
    ];
    return '${prefix[firstChar]}${hex.substring(1)}';
  }

  static DtcSeverity getDTCSeverity(String code) {
    if (code.startsWith('P0') && (code.contains('3') || code.contains('1'))) {
      return DtcSeverity.critical;
    }
    if (code.startsWith('P04') || code.startsWith('P01')) {
      return DtcSeverity.warning;
    }
    return DtcSeverity.info;
  }

  static String getDTCDescription(String code) {
    const descriptions = {
      'P0301': 'Fallo de encendido en cilindro 1',
      'P0302': 'Fallo de encendido en cilindro 2',
      'P0303': 'Fallo de encendido en cilindro 3',
      'P0304': 'Fallo de encendido en cilindro 4',
      'P0420': 'Catalizador sistema bajo eficiencia (Banco 1)',
      'P0171': 'Sistema demasiado pobre (Banco 1)',
      'P0172': 'Sistema demasiado rico (Banco 1)',
      'P0300': 'Fallos de encendido aleatorios detectados',
      'P0401': 'Flujo insuficiente de recirculación de gases',
      'P0440': 'Sistema de control de emisiones evaporativas',
      'P0442': 'Fuga pequeña en sistema EVAP',
      'P0455': 'Fuga grande en sistema EVAP',
      'P0500': 'Sensor de velocidad del vehículo',
      'P0505': 'Mal funcionamiento del control de ralentí',
    };
    return descriptions[code] ?? 'Código de diagnóstico: $code';
  }
}
