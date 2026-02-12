import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/drag_config.dart';
import '../models/drag_run.dart';
import '../providers/history_provider.dart';
import '../providers/obd2_provider.dart';
import '../providers/subscription_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/paywall_sheet.dart';
import 'drag_result_screen.dart';

enum DragState { selectTest, ready, running, finished }

class DraggyScreen extends StatefulWidget {
  const DraggyScreen({super.key});

  @override
  State<DraggyScreen> createState() => _DraggyScreenState();
}

class _DraggyScreenState extends State<DraggyScreen> {
  DragConfig _selectedConfig = DragConfig.zero100;
  DragState _state = DragState.selectTest;
  final List<DragSample> _samples = [];
  DateTime? _startTime;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  int _maxRpm = 0;
  int _startTemp = 0;
  // Mock simulation state
  double _mockSpeed = 0;
  int _mockRpm = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTest() {
    final provider = context.read<Obd2Provider>();
    final isPro = context.read<SubscriptionProvider>().isPro;

    // FREE users can only run 0-100 km/h
    if (!isPro && _selectedConfig != DragConfig.zero100) {
      showPaywall(context);
      return;
    }

    // In mock mode, run a simulated drag test
    if (provider.useMockData) {
      _startMockTest();
      return;
    }

    final speed = int.tryParse(provider.liveParams[1].value) ?? 0;
    _startTemp = int.tryParse(provider.liveParams[2].value) ?? 0;

    if (!_selectedConfig.isQuarterMile &&
        _selectedConfig.startSpeedKmh == 0 &&
        speed > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).draggyMustStop),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    setState(() {
      _state = DragState.ready;
      _samples.clear();
      _maxRpm = 0;
      _elapsed = Duration.zero;
    });

    // Listen for speed > 0 to auto-start
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      final p = context.read<Obd2Provider>();
      final currentSpeed = int.tryParse(p.liveParams[1].value) ?? 0;
      final currentRpm = int.tryParse(p.liveParams[0].value) ?? 0;

      if (_state == DragState.ready && currentSpeed > 0) {
        _startTime = DateTime.now();
        setState(() => _state = DragState.running);
      }

      if (_state == DragState.running) {
        final now = DateTime.now();
        final start = _startTime;
        if (start == null) return;
        _elapsed = now.difference(start);
        if (currentRpm > _maxRpm) _maxRpm = currentRpm;

        _samples.add(
          DragSample(
            elapsed: _elapsed,
            speedKmh: currentSpeed.toDouble(),
            rpm: currentRpm,
          ),
        );

        setState(() {});

        // Check if target reached
        if (currentSpeed >= _selectedConfig.targetSpeedKmh) {
          _finishTest(currentSpeed);
        }
      }
    });
  }

  /// Simulates a drag run with realistic acceleration curve for demo mode.
  void _startMockTest() {
    final rng = Random();
    _startTemp = 90 + rng.nextInt(5);
    _mockSpeed = _selectedConfig.startSpeedKmh;
    _mockRpm = 2500;
    _maxRpm = 0;
    _samples.clear();

    final target = _selectedConfig.isQuarterMile
        ? 180.0 // simulate reaching ~180 km/h at 1/4 mile
        : _selectedConfig.targetSpeedKmh;

    // Estimate total time based on target (roughly 8-12s for 0-100)
    final totalMs = (target / 100 * 9000 + rng.nextInt(2000)).toInt();
    final steps = (totalMs / 100).ceil();

    setState(() {
      _state = DragState.running;
      _startTime = DateTime.now();
      _elapsed = Duration.zero;
    });

    int step = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      step++;
      // Ease-out curve: fast start, slower at top end
      final t = step / steps;
      final eased = 1 - pow(1 - t, 2.5);
      _mockSpeed =
          _selectedConfig.startSpeedKmh +
          (target - _selectedConfig.startSpeedKmh) * eased;
      // RPM ramps up then shifts down in steps
      _mockRpm =
          (2500 + 4000 * sin(t * 3.14 * 1.5).abs()).toInt() + rng.nextInt(200);
      if (_mockRpm > _maxRpm) _maxRpm = _mockRpm;

      _elapsed = Duration(milliseconds: step * 100);

      _samples.add(
        DragSample(elapsed: _elapsed, speedKmh: _mockSpeed, rpm: _mockRpm),
      );

      setState(() {});

      if (_mockSpeed >= target || step >= steps) {
        _finishTest(_mockSpeed.toInt());
      }
    });
  }

  void _finishTest(int finalSpeed) {
    _timer?.cancel();
    final provider = context.read<Obd2Provider>();
    final endTemp = provider.useMockData
        ? _startTemp + 3
        : int.tryParse(provider.liveParams[2].value) ?? 0;

    final run = DragRun(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      config: _selectedConfig,
      timestamp: DateTime.now(),
      totalTime: _elapsed,
      trapSpeedKmh: finalSpeed.toDouble(),
      maxRpm: _maxRpm,
      startTempC: _startTemp,
      endTempC: endTemp,
      samples: List.unmodifiable(_samples),
    );

    // Save to history
    context.read<HistoryProvider>().saveDragRun(run);

    setState(() => _state = DragState.finished);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DragResultScreen(run: run)),
    );
  }

  void _cancelTest() {
    _timer?.cancel();
    setState(() {
      _state = DragState.selectTest;
      _samples.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l.draggyTitle),
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
            child: _state == DragState.selectTest
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildTestSelector(l),
                  )
                : _buildRunningView(l),
          ),
        ),
      ),
    );
  }

  Widget _buildTestSelector(AppLocalizations l) {
    final isPro = context.watch<SubscriptionProvider>().isPro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.draggySelectTest,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        RadioGroup<DragConfig>(
          groupValue: _selectedConfig,
          onChanged: (v) => setState(() {
            if (v != null) _selectedConfig = v;
          }),
          child: Column(
            children: DragConfig.presets.map((config) {
              final locked = !isPro && config != DragConfig.zero100;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.locale == 'es' ? config.name : config.nameEn,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (locked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.purple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'PRO',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.purple,
                              ),
                            ),
                          ),
                      ],
                    ),
                    leading: Radio<DragConfig>(
                      value: config,
                      activeColor: AppTheme.primary,
                    ),
                    onTap: () => setState(() => _selectedConfig = config),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Spacer(),
        ElevatedButton(onPressed: _startTest, child: Text(l.draggyStart)),
      ],
    );
  }

  Widget _buildRunningView(AppLocalizations l) {
    final provider = context.watch<Obd2Provider>();
    final speed = provider.useMockData
        ? _mockSpeed.toStringAsFixed(0)
        : provider.liveParams[1].value;
    final rpm = provider.useMockData
        ? '$_mockRpm'
        : provider.liveParams[0].value;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_state == DragState.ready)
              Text(
                l.draggyReady,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.success,
                ),
              ),
            if (_state == DragState.running) ...[
              Text(
                '${(_elapsed.inMilliseconds / 1000).toStringAsFixed(1)}s',
                style: GoogleFonts.inter(
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$speed km/h',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$rpm RPM',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 40),
            OutlinedButton(onPressed: _cancelTest, child: Text(l.cancel)),
          ],
        ),
      ),
    );
  }
}
