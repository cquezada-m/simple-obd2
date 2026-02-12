import '../models/mileage_check.dart';
import '../models/mileage_source.dart';
import 'obd2_base_service.dart';

/// Orchestrates mileage verification by reading odometer data
/// from standard PIDs and multiple ECU modules.
class MileageVerificationService {
  MileageVerificationService._();

  /// Runs a basic mileage check using standard PIDs only.
  /// Available in FREE tier.
  static Future<MileageCheck> basicCheck(Obd2BaseService service) async {
    final sources = <MileageSource>[];

    // PID 0131: Distance since DTCs cleared
    final dist0131 = await _readTwoByteKm(service, '0131', '4131');
    sources.add(
      MileageSource(
        moduleName: 'Distancia desde borrado DTCs',
        moduleNameEn: 'Distance since DTCs cleared',
        valueKm: dist0131,
        confidence: dist0131 != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
      ),
    );

    // PID 01A6: Odometer (MY2019+ US vehicles)
    final odometer = await _readFourByteKm(service, '01A6', '41A6');
    sources.add(
      MileageSource(
        moduleName: 'Odómetro (PID A6)',
        moduleNameEn: 'Odometer (PID A6)',
        valueKm: odometer,
        confidence: odometer != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
      ),
    );

    return _buildVerdict(sources);
  }

  /// Runs a full multi-module mileage check. PRO tier.
  static Future<MileageCheck> fullCheck(Obd2BaseService service) async {
    final sources = <MileageSource>[];

    // Standard PIDs
    final odometer = await _readFourByteKm(service, '01A6', '41A6');
    sources.add(
      MileageSource(
        moduleName: 'Odómetro (PID A6)',
        moduleNameEn: 'Odometer (PID A6)',
        valueKm: odometer,
        confidence: odometer != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
      ),
    );

    final dist0131 = await _readTwoByteKm(service, '0131', '4131');
    sources.add(
      MileageSource(
        moduleName: 'Distancia desde borrado DTCs',
        moduleNameEn: 'Distance since DTCs cleared',
        valueKm: dist0131,
        confidence: dist0131 != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
      ),
    );

    final dist0121 = await _readTwoByteKm(service, '0121', '4121');
    sources.add(
      MileageSource(
        moduleName: 'Distancia con MIL encendido',
        moduleNameEn: 'Distance with MIL on',
        valueKm: dist0121,
        confidence: dist0121 != null
            ? MileageConfidence.medium
            : MileageConfidence.unavailable,
      ),
    );

    // Multi-ECU queries via header switching
    for (final ecu in _ecuModules) {
      final km = await _queryEcuOdometer(service, ecu);
      sources.add(
        MileageSource(
          moduleName: ecu.nameEs,
          moduleNameEn: ecu.nameEn,
          header: ecu.header,
          valueKm: km,
          confidence: km != null
              ? MileageConfidence.medium
              : MileageConfidence.unavailable,
        ),
      );
    }

    // Restore default header
    await service.sendRawCommand('ATSH7DF');

    return _buildVerdict(sources);
  }

  static Future<double?> _readTwoByteKm(
    Obd2BaseService service,
    String pid,
    String header,
  ) async {
    final bytes = await service.queryPid(pid);
    if (bytes == null || bytes.length < 2) return null;
    return (bytes[0] * 256 + bytes[1]).toDouble();
  }

  static Future<double?> _readFourByteKm(
    Obd2BaseService service,
    String pid,
    String header,
  ) async {
    final bytes = await service.queryPid(pid);
    if (bytes == null || bytes.length < 4) return null;
    final raw =
        (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3];
    return raw / 10.0;
  }

  static Future<double?> _queryEcuOdometer(
    Obd2BaseService service,
    _EcuModule ecu,
  ) async {
    try {
      await service.sendRawCommand('AT SH ${ecu.header}');
      final bytes = await service.queryPid('01A6');
      if (bytes == null || bytes.length < 4) return null;
      final raw =
          (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3];
      return raw / 10.0;
    } catch (_) {
      return null;
    }
  }

  static MileageCheck _buildVerdict(List<MileageSource> sources) {
    final validSources = sources.where((s) => s.valueKm != null).toList();

    if (validSources.isEmpty) {
      return MileageCheck(
        timestamp: DateTime.now(),
        sources: sources,
        verdict: MileageVerdict.consistent,
        explanation:
            'No se pudieron obtener lecturas de kilometraje de los módulos del vehículo.',
        explanationEn:
            'Could not obtain mileage readings from vehicle modules.',
      );
    }

    final reference = validSources.first.valueKm!;
    double maxDeviation = 0;

    for (final s in validSources) {
      if (s.valueKm == null || reference == 0) continue;
      final deviation = ((s.valueKm! - reference) / reference).abs();
      if (deviation > maxDeviation) maxDeviation = deviation;
    }

    final MileageVerdict verdict;
    final String explanation;
    final String explanationEn;

    if (maxDeviation <= 0.05) {
      verdict = MileageVerdict.consistent;
      explanation =
          'Todas las lecturas de kilometraje son consistentes entre sí (desviación < 5%).';
      explanationEn =
          'All mileage readings are consistent with each other (deviation < 5%).';
    } else if (maxDeviation <= 0.15) {
      verdict = MileageVerdict.suspicious;
      explanation =
          'Se detectaron discrepancias menores (5-15%) entre módulos. Podría indicar reemplazo de un módulo.';
      explanationEn =
          'Minor discrepancies (5-15%) detected between modules. Could indicate a module replacement.';
    } else {
      verdict = MileageVerdict.tampered;
      explanation =
          'Se detectaron discrepancias significativas (>15%) entre módulos. Posible manipulación del odómetro.';
      explanationEn =
          'Significant discrepancies (>15%) detected between modules. Possible odometer tampering.';
    }

    return MileageCheck(
      timestamp: DateTime.now(),
      sources: sources,
      verdict: verdict,
      explanation: explanation,
      explanationEn: explanationEn,
      referenceKm: reference,
    );
  }

  /// Returns mock demo data for testing without a real OBD2 connection.
  static MileageCheck mockCheck({bool full = false}) {
    final sources = <MileageSource>[
      const MileageSource(
        moduleName: 'Odómetro (PID A6)',
        moduleNameEn: 'Odometer (PID A6)',
        valueKm: 45230,
        confidence: MileageConfidence.high,
      ),
      const MileageSource(
        moduleName: 'Distancia desde borrado DTCs',
        moduleNameEn: 'Distance since DTCs cleared',
        valueKm: 45230,
        confidence: MileageConfidence.high,
      ),
    ];

    if (full) {
      sources.addAll(const [
        MileageSource(
          moduleName: 'Distancia con MIL encendido',
          moduleNameEn: 'Distance with MIL on',
          valueKm: 0,
          confidence: MileageConfidence.medium,
        ),
        MileageSource(
          moduleName: 'ECM (Motor)',
          moduleNameEn: 'ECM (Engine)',
          header: '7E0',
          valueKm: 45180,
          confidence: MileageConfidence.medium,
        ),
        MileageSource(
          moduleName: 'TCM (Transmisión)',
          moduleNameEn: 'TCM (Transmission)',
          header: '7E1',
          valueKm: 45195,
          confidence: MileageConfidence.medium,
        ),
        MileageSource(
          moduleName: 'ABS / ESP',
          moduleNameEn: 'ABS / ESP',
          header: '7E2',
          valueKm: 45210,
          confidence: MileageConfidence.medium,
        ),
      ]);
    }

    return MileageCheck(
      timestamp: DateTime.now(),
      sources: sources,
      verdict: MileageVerdict.consistent,
      explanation:
          'Todas las lecturas de kilometraje son consistentes entre sí (desviación < 5%).',
      explanationEn:
          'All mileage readings are consistent with each other (deviation < 5%).',
      referenceKm: 45230,
    );
  }

  static const _ecuModules = [
    _EcuModule('7E0', 'ECM (Motor)', 'ECM (Engine)'),
    _EcuModule('7E1', 'TCM (Transmisión)', 'TCM (Transmission)'),
    _EcuModule('7E2', 'ABS / ESP', 'ABS / ESP'),
  ];
}

class _EcuModule {
  final String header;
  final String nameEs;
  final String nameEn;
  const _EcuModule(this.header, this.nameEs, this.nameEn);
}
