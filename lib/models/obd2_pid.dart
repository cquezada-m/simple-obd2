/// Category of an OBD2 PID sensor.
enum PidCategory { engine, fuel, air, emissions, electrical, diagnostic }

/// Definition of an OBD2 PID with decoding formula and metadata.
class Obd2Pid {
  final String pid;
  final String nameEs;
  final String nameEn;
  final String unit;
  final PidCategory category;
  final int dataBytes;
  final double Function(List<int> bytes) decode;
  final double? normalMin;
  final double? normalMax;
  final double? warningMax;

  const Obd2Pid({
    required this.pid,
    required this.nameEs,
    required this.nameEn,
    required this.unit,
    required this.category,
    required this.dataBytes,
    required this.decode,
    this.normalMin,
    this.normalMax,
    this.warningMax,
  });

  String name(String locale) => locale == 'es' ? nameEs : nameEn;
}

/// Live reading of a PID with value history.
class PidReading {
  final Obd2Pid definition;
  double? currentValue;
  final List<double> history;

  PidReading({required this.definition, this.currentValue}) : history = [];

  void addValue(double value) {
    currentValue = value;
    history.add(value);
    // Keep last 300 samples (~5 min at 1/s)
    if (history.length > 300) history.removeAt(0);
  }

  List<double> get sparklineData =>
      history.length > 30 ? history.sublist(history.length - 30) : history;

  double? get minValue =>
      history.isEmpty ? null : history.reduce((a, b) => a < b ? a : b);
  double? get maxValue =>
      history.isEmpty ? null : history.reduce((a, b) => a > b ? a : b);
  double? get avgValue =>
      history.isEmpty ? null : history.reduce((a, b) => a + b) / history.length;
}
