/// Whether the source represents an absolute odometer or a relative distance.
enum MileageSourceType {
  /// True odometer reading (PID A6, ECU module odometers).
  odometer,

  /// Relative/partial distance (distance since DTC clear, distance with MIL).
  relativeDistance,
}

/// Identifies which module/PID a mileage reading came from.
enum MileageSourceKey {
  odometerPidA6,
  distanceSinceDtcClear,
  distanceWithMil,
  ecm,
  tcm,
  abs,
}

enum MileageConfidence { high, medium, low, unavailable }

/// A single mileage reading from a vehicle module.
class MileageSource {
  final MileageSourceKey key;
  final String? header;
  final double? valueKm;
  final MileageConfidence confidence;
  final MileageSourceType sourceType;

  const MileageSource({
    required this.key,
    this.header,
    this.valueKm,
    required this.confidence,
    this.sourceType = MileageSourceType.odometer,
  });

  Map<String, dynamic> toJson() => {
    'key': key.name,
    'header': header,
    'valueKm': valueKm,
    'confidence': confidence.name,
    'sourceType': sourceType.name,
  };

  factory MileageSource.fromJson(Map<String, dynamic> json) {
    return MileageSource(
      key: MileageSourceKey.values.byName(json['key'] as String),
      header: json['header'] as String?,
      valueKm: (json['valueKm'] as num?)?.toDouble(),
      confidence: MileageConfidence.values.byName(json['confidence'] as String),
      sourceType: MileageSourceType.values.byName(
        json['sourceType'] as String? ?? 'odometer',
      ),
    );
  }
}
