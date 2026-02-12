import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/drag_run.dart';
import '../theme/app_theme.dart';

class DragResultScreen extends StatelessWidget {
  final DragRun run;

  const DragResultScreen({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.draggyResults)),
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
                children: [
                  _buildTimeCard(l),
                  const SizedBox(height: 12),
                  _buildStatsCard(l),
                  const SizedBox(height: 12),
                  _buildChart(l),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(AppLocalizations l) {
    return GlassCard(
      child: Column(
        children: [
          Text(
            l.locale == 'es' ? run.config.name : run.config.nameEn,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${run.formattedTime}s',
            style: GoogleFonts.inter(
              fontSize: 56,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AppLocalizations l) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat(
            l.draggyTrapSpeed,
            '${run.trapSpeedKmh.toStringAsFixed(0)} km/h',
          ),
          _stat(l.draggyMaxRpm, '${run.maxRpm}'),
          _stat(l.draggyTempStart, '${run.startTempC}°C'),
          _stat(l.draggyTempEnd, '${run.endTempC}°C'),
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
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildChart(AppLocalizations l) {
    if (run.samples.isEmpty) return const SizedBox.shrink();

    final speedSpots = run.samples
        .map((s) => FlSpot(s.elapsed.inMilliseconds / 1000, s.speedKmh))
        .toList();

    final rpmSpots = run.samples
        .map((s) => FlSpot(s.elapsed.inMilliseconds / 1000, s.rpm.toDouble()))
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.draggyChart,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: speedSpots,
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: rpmSpots,
                    isCurved: true,
                    color: AppTheme.purple.withValues(alpha: 0.5),
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(AppTheme.primary, l.paramSpeed),
              const SizedBox(width: 16),
              _legendDot(AppTheme.purple, 'RPM'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
