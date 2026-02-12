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
}
