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
}

/// Result of a completed drag run.
class DragRun {
  final DragConfig config;
  final DateTime timestamp;
  final Duration totalTime;
  final double trapSpeedKmh;
  final int maxRpm;
  final int startTempC;
  final int endTempC;
  final List<DragSample> samples;

  const DragRun({
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
}
