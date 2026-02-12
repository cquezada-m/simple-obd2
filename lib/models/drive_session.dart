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

  Map<String, dynamic> toJson() => {
    'elapsedMs': elapsed.inMilliseconds,
    'rpm': rpm,
    'speedKmh': speedKmh,
    'coolantTempC': coolantTempC,
    'engineLoadPct': engineLoadPct,
  };

  factory DriveDataPoint.fromJson(Map<String, dynamic> json) {
    return DriveDataPoint(
      elapsed: Duration(milliseconds: json['elapsedMs'] as int),
      rpm: json['rpm'] as int,
      speedKmh: json['speedKmh'] as int,
      coolantTempC: json['coolantTempC'] as int,
      engineLoadPct: json['engineLoadPct'] as int,
    );
  }
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

  Map<String, dynamic> toJson() => {
    'timestampMs': timestamp.inMilliseconds,
    'type': type.name,
    'magnitude': magnitude,
  };

  factory DriveEvent.fromJson(Map<String, dynamic> json) {
    return DriveEvent(
      timestamp: Duration(milliseconds: json['timestampMs'] as int),
      type: DriveEventType.values.byName(json['type'] as String),
      magnitude: (json['magnitude'] as num).toDouble(),
    );
  }
}

enum DriveEventType { hardAcceleration, hardBraking }

/// A recorded driving session with all captured data.
class DriveSession {
  final String? id;
  final DateTime startTime;
  final DateTime? endTime;
  final List<DriveDataPoint> dataPoints;
  final List<DriveEvent> events;
  final String? vin;

  const DriveSession({
    this.id,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'dataPoints': dataPoints.map((d) => d.toJson()).toList(),
    'events': events.map((e) => e.toJson()).toList(),
    'vin': vin,
  };

  factory DriveSession.fromJson(Map<String, dynamic> json) {
    return DriveSession(
      id: json['id'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      dataPoints: (json['dataPoints'] as List)
          .map((d) => DriveDataPoint.fromJson(d as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as List)
          .map((e) => DriveEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      vin: json['vin'] as String?,
    );
  }
}
