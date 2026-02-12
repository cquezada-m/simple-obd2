import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/drive_session.dart';
import '../providers/obd2_provider.dart';
import '../theme/app_theme.dart';

class DriveSessionScreen extends StatefulWidget {
  const DriveSessionScreen({super.key});

  @override
  State<DriveSessionScreen> createState() => _DriveSessionScreenState();
}

class _DriveSessionScreenState extends State<DriveSessionScreen> {
  bool _isRecording = false;
  DateTime? _startTime;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  final List<DriveDataPoint> _dataPoints = [];
  final List<DriveEvent> _events = [];
  int _lastSpeed = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    final provider = context.read<Obd2Provider>();
    if (!provider.isConnected) return;

    _startTime = DateTime.now();
    _dataPoints.clear();
    _events.clear();
    _lastSpeed = 0;

    setState(() => _isRecording = true);

    if (provider.useMockData) {
      _startMockRecording();
    } else {
      _startRealRecording();
    }
  }

  void _startRealRecording() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final p = context.read<Obd2Provider>();
      final now = DateTime.now();
      _elapsed = now.difference(_startTime!);

      final rpm = int.tryParse(p.liveParams[0].value) ?? 0;
      final speed = int.tryParse(p.liveParams[1].value) ?? 0;
      final temp = int.tryParse(p.liveParams[2].value) ?? 0;
      final load = int.tryParse(p.liveParams[3].value) ?? 0;

      _addDataPoint(rpm, speed, temp, load);
    });
  }

  void _startMockRecording() {
    final rng = Random();
    // Simulate a city drive: accelerate, cruise, brake, idle, repeat
    double mockSpeed = 0;
    int phase = 0; // 0=accel, 1=cruise, 2=brake, 3=idle
    int phaseCounter = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _elapsed = DateTime.now().difference(_startTime!);

      phaseCounter++;
      switch (phase) {
        case 0: // accelerating
          mockSpeed += 5 + rng.nextDouble() * 8;
          if (mockSpeed > 60 + rng.nextInt(40)) {
            phase = 1;
            phaseCounter = 0;
          }
        case 1: // cruising
          mockSpeed += (rng.nextDouble() - 0.5) * 4;
          mockSpeed = mockSpeed.clamp(30, 120);
          if (phaseCounter > 8 + rng.nextInt(8)) {
            phase = 2;
            phaseCounter = 0;
          }
        case 2: // braking
          mockSpeed -= 6 + rng.nextDouble() * 6;
          if (mockSpeed <= 5) {
            mockSpeed = 0;
            phase = 3;
            phaseCounter = 0;
          }
        case 3: // idle
          mockSpeed = 0;
          if (phaseCounter > 3 + rng.nextInt(4)) {
            phase = 0;
            phaseCounter = 0;
          }
      }
      mockSpeed = mockSpeed.clamp(0, 140);

      final speed = mockSpeed.toInt();
      final rpm = mockSpeed == 0
          ? 750 + rng.nextInt(100)
          : (1500 + mockSpeed * 30 + rng.nextInt(300)).toInt();
      final temp = 88 + rng.nextInt(8);
      final load = mockSpeed == 0
          ? 12 + rng.nextInt(5)
          : (20 + mockSpeed * 0.3 + rng.nextInt(10)).toInt();

      _addDataPoint(rpm, speed, temp, load);
    });
  }

  void _addDataPoint(int rpm, int speed, int temp, int load) {
    _dataPoints.add(
      DriveDataPoint(
        elapsed: _elapsed,
        rpm: rpm,
        speedKmh: speed,
        coolantTempC: temp,
        engineLoadPct: load,
      ),
    );

    // Detect events
    final speedDelta = speed - _lastSpeed;
    if (speedDelta > 15) {
      _events.add(
        DriveEvent(
          timestamp: _elapsed,
          type: DriveEventType.hardAcceleration,
          magnitude: speedDelta.toDouble(),
        ),
      );
    } else if (speedDelta < -20) {
      _events.add(
        DriveEvent(
          timestamp: _elapsed,
          type: DriveEventType.hardBraking,
          magnitude: speedDelta.abs().toDouble(),
        ),
      );
    }
    _lastSpeed = speed;

    setState(() {});
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l.driveSessionTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isRecording) _buildRecordingBadge(l),
                  _buildStatsCard(l),
                  const SizedBox(height: 12),
                  if (_dataPoints.isNotEmpty) ...[
                    _buildSpeedChart(l),
                    const SizedBox(height: 12),
                    _buildRpmChart(l),
                    const SizedBox(height: 12),
                  ],
                  if (_events.isNotEmpty) _buildEventsCard(l),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    icon: Icon(
                      _isRecording
                          ? Icons.stop_rounded
                          : Icons.fiber_manual_record_rounded,
                    ),
                    label: Text(
                      _isRecording ? l.driveSessionStop : l.driveSessionStart,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording
                          ? AppTheme.error
                          : AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingBadge(AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${l.driveSessionRecording} ${_formatDuration(_elapsed)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AppLocalizations l) {
    final session = DriveSession(
      startTime: _startTime ?? DateTime.now(),
      endTime: _isRecording ? null : DateTime.now(),
      dataPoints: _dataPoints,
      events: _events,
    );

    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat(l.driveSessionDuration, _formatDuration(_elapsed)),
          _stat(
            l.driveSessionAvgSpeed,
            '${session.avgSpeedKmh.toStringAsFixed(0)} km/h',
          ),
          _stat(l.driveSessionMaxSpeed, '${session.maxSpeedKmh} km/h'),
          _stat(l.driveSessionEvents, '${_events.length}'),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSpeedChart(AppLocalizations l) {
    final spots = _dataPoints
        .map(
          (d) => FlSpot(d.elapsed.inSeconds.toDouble(), d.speedKmh.toDouble()),
        )
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.paramSpeed,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRpmChart(AppLocalizations l) {
    final spots = _dataPoints
        .map((d) => FlSpot(d.elapsed.inSeconds.toDouble(), d.rpm.toDouble()))
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RPM',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.purple,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.purple.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsCard(AppLocalizations l) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.driveSessionEvents,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ..._events.map((e) {
            final isAccel = e.type == DriveEventType.hardAcceleration;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    isAccel
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 16,
                    color: isAccel ? AppTheme.warning : AppTheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isAccel ? l.driveSessionHardAccel : l.driveSessionHardBrake,
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(e.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${d.inHours > 0 ? '${d.inHours}:' : ''}$m:$s';
  }
}
