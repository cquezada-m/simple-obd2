/// Configuration for a drag race test.
class DragConfig {
  final String name;
  final String nameEn;
  final double startSpeedKmh;
  final double targetSpeedKmh;
  final bool isQuarterMile;

  const DragConfig({
    required this.name,
    required this.nameEn,
    required this.startSpeedKmh,
    required this.targetSpeedKmh,
    this.isQuarterMile = false,
  });

  static const zero100 = DragConfig(
    name: '0-100 km/h',
    nameEn: '0-100 km/h',
    startSpeedKmh: 0,
    targetSpeedKmh: 100,
  );

  static const zero60mph = DragConfig(
    name: '0-60 mph',
    nameEn: '0-60 mph',
    startSpeedKmh: 0,
    targetSpeedKmh: 96.56,
  );

  static const zero200 = DragConfig(
    name: '0-200 km/h',
    nameEn: '0-200 km/h',
    startSpeedKmh: 0,
    targetSpeedKmh: 200,
  );

  static const hundredTo200 = DragConfig(
    name: '100-200 km/h',
    nameEn: '100-200 km/h',
    startSpeedKmh: 100,
    targetSpeedKmh: 200,
  );

  static const quarterMile = DragConfig(
    name: '1/4 de milla',
    nameEn: '1/4 mile',
    startSpeedKmh: 0,
    targetSpeedKmh: 402.336, // distance in meters, handled specially
    isQuarterMile: true,
  );

  static const List<DragConfig> presets = [
    zero100,
    zero60mph,
    zero200,
    hundredTo200,
    quarterMile,
  ];
}
