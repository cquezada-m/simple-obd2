import 'mileage_source.dart';

/// Verdict of a mileage verification check.
enum MileageVerdict { consistent, suspicious, tampered, insufficientData }

/// Result of a mileage verification across multiple modules.
class MileageCheck {
  final String? id;
  final DateTime timestamp;
  final List<MileageSource> sources;
  final MileageVerdict verdict;
  final double? referenceKm;

  /// Number of odometer-type sources used for comparison.
  final int odometerSourceCount;

  const MileageCheck({
    this.id,
    required this.timestamp,
    required this.sources,
    required this.verdict,
    this.referenceKm,
    this.odometerSourceCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'sources': sources.map((s) => s.toJson()).toList(),
    'verdict': verdict.name,
    'referenceKm': referenceKm,
    'odometerSourceCount': odometerSourceCount,
  };

  factory MileageCheck.fromJson(Map<String, dynamic> json) {
    return MileageCheck(
      id: json['id'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sources: (json['sources'] as List)
          .map((s) => MileageSource.fromJson(s as Map<String, dynamic>))
          .toList(),
      verdict: MileageVerdict.values.byName(json['verdict'] as String),
      referenceKm: (json['referenceKm'] as num?)?.toDouble(),
      odometerSourceCount: json['odometerSourceCount'] as int? ?? 0,
    );
  }
}
