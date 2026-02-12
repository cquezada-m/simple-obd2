import '../data/dtc_database.dart';
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

  /// Extracts the data portion from an OBD2 response.
  /// Handles multi-line responses, echoed commands, and various ELM327 quirks.
  /// Returns only the hex data bytes after the mode+PID header.
  ///
  /// For multi-ECU vehicles (BMW, etc.), multiple lines may contain the same
  /// header (e.g., two "410C" lines from two ECUs). We use the FIRST valid match.
  static String? _extractResponseData(String? response, String expectedHeader) {
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }

    // Rechazar respuestas que son puramente errores ELM327
    final upper = response.toUpperCase().trim();
    if (upper == 'STOPPED' || upper == '?' || upper.startsWith('ERROR')) {
      return null;
    }

    final lines = response
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.trim())
        .where(
          (l) =>
              l.isNotEmpty &&
              !l.toUpperCase().startsWith('SEARCHING') &&
              !l.toUpperCase().startsWith('AT') &&
              !l.toUpperCase().startsWith('STOPPED') &&
              !l.toUpperCase().startsWith('ERROR') &&
              l != '?',
        )
        .toList();

    for (final line in lines) {
      final lineHex = line
          .replaceAll(RegExp(r'[^0-9A-Fa-f]'), '')
          .toUpperCase();

      // Saltar líneas que son negative response (7F xx xx)
      if (RegExp(r'^7F[0-9A-F]{4}').hasMatch(lineHex)) continue;

      // Saltar líneas demasiado cortas para contener header + data
      if (lineHex.length < expectedHeader.length + 2) continue;

      // Buscar el header esperado. Solo aceptar si la línea COMIENZA con
      // el header (opcionalmente precedido por dirección CAN de 3 hex chars).
      // Esto evita falsos positivos donde "410C" aparece dentro de datos
      // de otro PID.
      final headerUpper = expectedHeader.toUpperCase();
      final idx = lineHex.indexOf(headerUpper);
      if (idx >= 0 && idx <= 3) {
        // idx 0 = header directo (ej: "410C0A7A")
        // idx 3 = con dirección CAN (ej: "7E8410C0A7A")
        return lineHex.substring(idx + headerUpper.length);
      }
    }

    // NO fallback — si no encontramos el header esperado, no adivinamos.
    return null;
  }

  static int? parseOneByte(String? response, {String expectedHeader = ''}) {
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }
    try {
      String? data;
      if (expectedHeader.isNotEmpty) {
        data = _extractResponseData(response, expectedHeader);
      } else {
        // Legacy fallback with offset
        final cleaned = response.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
        data = cleaned.length >= 6 ? cleaned.substring(4) : null;
      }
      if (data != null && data.length >= 2) {
        return int.parse(data.substring(0, 2), radix: 16);
      }
    } catch (_) {}
    return null;
  }

  static int? parseTwoBytes(String? response, {String expectedHeader = ''}) {
    if (response == null || response.isEmpty || response.contains('NO DATA')) {
      return null;
    }
    try {
      String? data;
      if (expectedHeader.isNotEmpty) {
        data = _extractResponseData(response, expectedHeader);
      } else {
        final cleaned = response.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
        data = cleaned.length >= 8 ? cleaned.substring(4) : null;
      }
      if (data != null && data.length >= 4) {
        final a = int.parse(data.substring(0, 2), radix: 16);
        final b = int.parse(data.substring(2, 4), radix: 16);
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
    // P0xxx: Powertrain generic - often critical
    // P03xx: Ignition/misfire - critical
    // P04xx: Emissions - warning
    // P01xx: Fuel/air metering - warning to critical
    // C/B/U codes: chassis/body/network - typically info/warning
    if (code.startsWith('P03')) return DtcSeverity.critical; // misfire
    if (code.startsWith('P01')) return DtcSeverity.warning; // fuel/air
    if (code.startsWith('P02')) return DtcSeverity.warning; // fuel/air
    if (code.startsWith('P04')) return DtcSeverity.warning; // emissions
    if (code.startsWith('P05') || code.startsWith('P06')) {
      return DtcSeverity.warning; // vehicle speed, idle, aux
    }
    if (code.startsWith('P0')) return DtcSeverity.warning; // other generic
    if (code.startsWith('P1') || code.startsWith('P3')) {
      return DtcSeverity.warning; // manufacturer specific
    }
    if (code.startsWith('P2')) return DtcSeverity.warning;
    if (code.startsWith('U')) return DtcSeverity.info; // network
    if (code.startsWith('B')) return DtcSeverity.info; // body
    if (code.startsWith('C')) return DtcSeverity.info; // chassis
    return DtcSeverity.info;
  }

  static String getDTCDescription(String code, {String locale = 'es'}) {
    return DtcDatabase.getDescription(code, locale) ??
        (locale == 'es'
            ? 'Código de diagnóstico: $code'
            : 'Diagnostic code: $code');
  }
}
