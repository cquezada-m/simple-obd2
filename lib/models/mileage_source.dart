/// A single mileage reading from a vehicle module.
class MileageSource {
  final String moduleName;
  final String moduleNameEn;
  final String? header;
  final double? valueKm;
  final MileageConfidence confidence;

  const MileageSource({
    required this.moduleName,
    required this.moduleNameEn,
    this.header,
    this.valueKm,
    required this.confidence,
  });

  String name(String locale) => locale == 'es' ? moduleName : moduleNameEn;
}

enum MileageConfidence { high, medium, low, unavailable }
