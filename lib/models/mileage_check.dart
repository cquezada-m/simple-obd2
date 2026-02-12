import 'mileage_source.dart';

/// Verdict of a mileage verification check.
enum MileageVerdict { consistent, suspicious, tampered, insufficientData }

/// Result of a mileage verification across multiple modules.
class MileageCheck {
  final DateTime timestamp;
  final List<MileageSource> sources;
  final MileageVerdict verdict;
  final double? referenceKm;

  /// Number of odometer-type sources used for comparison.
  final int odometerSourceCount;

  const MileageCheck({
    required this.timestamp,
    required this.sources,
    required this.verdict,
    this.referenceKm,
    this.odometerSourceCount = 0,
  });
}
