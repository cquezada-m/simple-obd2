/// A single data point in a drive recording session.
class DriveDataPoint {
  final Duration elapsed;
  final int rpm;
  final int speedKmh;
  final int coolantTempC;
  final int engineLoadPct;

  const DriveDataPoint({
    required this.elapsed,
    required this.rpm,
    required this.speedKmh,
    required this.coolantTempC,
    required this.engineLoadPct,
  });
}

/// A detected driving event (hard acceleration, hard braking).
class DriveEvent {
  final Duration timestamp;
  final DriveEventType type;
  final double magnitude;

  const DriveEvent({
    required this.timestamp,
    required this.type,
    required this.magnitude,
  });
}

enum DriveEventType { hardAcceleration, hardBraking }

/// A recorded driving session with all captured data.
class DriveSession {
  final DateTime startTime;
  final DateTime? endTime;
  final List<DriveDataPoint> dataPoints;
  final List<DriveEvent> events;
  final String? vin;

  const DriveSession({
    required this.startTime,
    this.endTime,
    required this.dataPoints,
    required this.events,
    this.vin,
  });

  Duration get duration =>
      endTime != null ? endTime!.difference(startTime) : Duration.zero;

  double get avgSpeedKmh {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((d) => d.speedKmh).reduce((a, b) => a + b) /
        dataPoints.length;
  }

  int get maxRpm {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((d) => d.rpm).reduce((a, b) => a > b ? a : b);
  }

  int get maxSpeedKmh {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((d) => d.speedKmh).reduce((a, b) => a > b ? a : b);
  }
}
