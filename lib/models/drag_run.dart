import 'drag_config.dart';

/// A single data sample captured during a drag run.
class DragSample {
  final Duration elapsed;
  final double speedKmh;
  final int rpm;

  const DragSample({
    required this.elapsed,
    required this.speedKmh,
    required this.rpm,
  });

  Map<String, dynamic> toJson() => {
    'elapsedMs': elapsed.inMilliseconds,
    'speedKmh': speedKmh,
    'rpm': rpm,
  };

  factory DragSample.fromJson(Map<String, dynamic> json) {
    return DragSample(
      elapsed: Duration(milliseconds: json['elapsedMs'] as int),
      speedKmh: (json['speedKmh'] as num).toDouble(),
      rpm: json['rpm'] as int,
    );
  }
}

/// Result of a completed drag run.
class DragRun {
  final String? id;
  final DragConfig config;
  final DateTime timestamp;
  final Duration totalTime;
  final double trapSpeedKmh;
  final int maxRpm;
  final int startTempC;
  final int endTempC;
  final List<DragSample> samples;

  const DragRun({
    this.id,
    required this.config,
    required this.timestamp,
    required this.totalTime,
    required this.trapSpeedKmh,
    required this.maxRpm,
    required this.startTempC,
    required this.endTempC,
    required this.samples,
  });

  String get formattedTime {
    final ms = totalTime.inMilliseconds;
    final seconds = ms / 1000;
    return seconds.toStringAsFixed(1);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'config': config.toJson(),
    'timestamp': timestamp.toIso8601String(),
    'totalTimeMs': totalTime.inMilliseconds,
    'trapSpeedKmh': trapSpeedKmh,
    'maxRpm': maxRpm,
    'startTempC': startTempC,
    'endTempC': endTempC,
    'samples': samples.map((s) => s.toJson()).toList(),
  };

  factory DragRun.fromJson(Map<String, dynamic> json) {
    return DragRun(
      id: json['id'] as String?,
      config: DragConfig.fromJson(json['config'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      totalTime: Duration(milliseconds: json['totalTimeMs'] as int),
      trapSpeedKmh: (json['trapSpeedKmh'] as num).toDouble(),
      maxRpm: json['maxRpm'] as int,
      startTempC: json['startTempC'] as int,
      endTempC: json['endTempC'] as int,
      samples: (json['samples'] as List)
          .map((s) => DragSample.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
