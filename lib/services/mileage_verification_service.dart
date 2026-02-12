import '../models/mileage_check.dart';
import '../models/mileage_source.dart';
import 'obd2_base_service.dart';

/// Orchestrates mileage verification by reading odometer data
/// from standard PIDs and multiple ECU modules.
class MileageVerificationService {
  MileageVerificationService._();

  /// Runs a basic mileage check using standard PIDs only.
  static Future<MileageCheck> basicCheck(Obd2BaseService service) async {
    final sources = <MileageSource>[];

    final dist0131 = await _readTwoByteKm(service, '0131', '4131');
    sources.add(
      MileageSource(
        key: MileageSourceKey.distanceSinceDtcClear,
        valueKm: dist0131,
        confidence: dist0131 != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
        sourceType: MileageSourceType.relativeDistance,
      ),
    );

    final odometer = await _readFourByteKm(service, '01A6', '41A6');
    sources.add(
      MileageSource(
        key: MileageSourceKey.odometerPidA6,
        valueKm: odometer,
        confidence: odometer != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
      ),
    );

    return _buildVerdict(sources);
  }

  /// Runs a full multi-module mileage check.
  static Future<MileageCheck> fullCheck(Obd2BaseService service) async {
    final sources = <MileageSource>[];

    final odometer = await _readFourByteKm(service, '01A6', '41A6');
    sources.add(
      MileageSource(
        key: MileageSourceKey.odometerPidA6,
        valueKm: odometer,
        confidence: odometer != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
      ),
    );

    final dist0131 = await _readTwoByteKm(service, '0131', '4131');
    sources.add(
      MileageSource(
        key: MileageSourceKey.distanceSinceDtcClear,
        valueKm: dist0131,
        confidence: dist0131 != null
            ? MileageConfidence.high
            : MileageConfidence.unavailable,
        sourceType: MileageSourceType.relativeDistance,
      ),
    );

    final dist0121 = await _readTwoByteKm(service, '0121', '4121');
    sources.add(
      MileageSource(
        key: MileageSourceKey.distanceWithMil,
        valueKm: dist0121,
        confidence: dist0121 != null
            ? MileageConfidence.medium
            : MileageConfidence.unavailable,
        sourceType: MileageSourceType.relativeDistance,
      ),
    );

    for (final ecu in _ecuModules) {
      final km = await _queryEcuOdometer(service, ecu);
      sources.add(
        MileageSource(
          key: ecu.sourceKey,
          header: ecu.header,
          valueKm: km,
          confidence: km != null
              ? MileageConfidence.medium
              : MileageConfidence.unavailable,
        ),
      );
    }

    await service.sendRawCommand('ATSH7DF');
    await service.sendRawCommand('ATAR');

    return _buildVerdict(sources);
  }

  // ── Private helpers ──

  static Future<double?> _readTwoByteKm(
    Obd2BaseService service,
    String pid,
    String expectedHeader,
  ) async {
    final response = await service.sendRawCommand(pid);
    if (response == null || response.isEmpty) return null;
    final bytes = Obd2BaseService.extractResponseBytes(
      response,
      expectedHeader,
    );
    if (bytes == null || bytes.length < 2) return null;
    return (bytes[0] * 256 + bytes[1]).toDouble();
  }

  static Future<double?> _readFourByteKm(
    Obd2BaseService service,
    String pid,
    String expectedHeader,
  ) async {
    final response = await service.sendRawCommand(pid);
    if (response == null || response.isEmpty) return null;
    final bytes = Obd2BaseService.extractResponseBytes(
      response,
      expectedHeader,
    );
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
      await service.sendRawCommand('ATAR');
      await service.sendRawCommand('ATSH${ecu.header}');
      final response = await service.sendRawCommand('01A6');
      if (response == null || response.isEmpty) return null;
      final bytes = Obd2BaseService.extractResponseBytes(response, '41A6');
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
        verdict: MileageVerdict.insufficientData,
      );
    }

    final odometerSources = validSources
        .where((s) => s.sourceType == MileageSourceType.odometer)
        .toList();

    if (odometerSources.length < 2) {
      return MileageCheck(
        timestamp: DateTime.now(),
        sources: sources,
        verdict: MileageVerdict.insufficientData,
        referenceKm: validSources.first.valueKm,
      );
    }

    final reference = odometerSources.first.valueKm!;
    double maxDeviation = 0;

    if (reference > 0) {
      for (final s in odometerSources) {
        final deviation = ((s.valueKm! - reference) / reference).abs();
        if (deviation > maxDeviation) maxDeviation = deviation;
      }
    }

    final MileageVerdict verdict;
    if (maxDeviation <= 0.05) {
      verdict = MileageVerdict.consistent;
    } else if (maxDeviation <= 0.15) {
      verdict = MileageVerdict.suspicious;
    } else {
      verdict = MileageVerdict.tampered;
    }

    return MileageCheck(
      timestamp: DateTime.now(),
      sources: sources,
      verdict: verdict,
      referenceKm: reference,
      odometerSourceCount: odometerSources.length,
    );
  }

  /// Mock demo data for testing without a real OBD2 connection.
  static MileageCheck mockCheck({bool full = false}) {
    final sources = <MileageSource>[
      const MileageSource(
        key: MileageSourceKey.odometerPidA6,
        valueKm: 45230,
        confidence: MileageConfidence.high,
      ),
      const MileageSource(
        key: MileageSourceKey.distanceSinceDtcClear,
        valueKm: 45230,
        confidence: MileageConfidence.high,
        sourceType: MileageSourceType.relativeDistance,
      ),
    ];

    if (full) {
      sources.addAll(const [
        MileageSource(
          key: MileageSourceKey.distanceWithMil,
          valueKm: 0,
          confidence: MileageConfidence.medium,
          sourceType: MileageSourceType.relativeDistance,
        ),
        MileageSource(
          key: MileageSourceKey.ecm,
          header: '7E0',
          valueKm: 45180,
          confidence: MileageConfidence.medium,
        ),
        MileageSource(
          key: MileageSourceKey.tcm,
          header: '7E1',
          valueKm: 45195,
          confidence: MileageConfidence.medium,
        ),
        MileageSource(
          key: MileageSourceKey.abs,
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
      referenceKm: 45230,
      odometerSourceCount: full ? 4 : 1,
    );
  }

  static const _ecuModules = [
    _EcuModule('7E0', MileageSourceKey.ecm),
    _EcuModule('7E1', MileageSourceKey.tcm),
    _EcuModule('7E2', MileageSourceKey.abs),
  ];
}

class _EcuModule {
  final String header;
  final MileageSourceKey sourceKey;
  const _EcuModule(this.header, this.sourceKey);
}
