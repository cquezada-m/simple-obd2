import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/obd2_pid.dart';
import '../theme/app_theme.dart';

class SensorDetailScreen extends StatelessWidget {
  final PidReading reading;

  const SensorDetailScreen({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pid = reading.definition;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(pid.name(l.locale))),
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
                  _buildValueCard(l),
                  const SizedBox(height: 12),
                  _buildStatsCard(l),
                  const SizedBox(height: 12),
                  _buildHistoryChart(l),
                  const SizedBox(height: 12),
                  _buildInfoCard(l),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValueCard(AppLocalizations l) {
    return GlassCard(
      child: Column(
        children: [
          Text(
            reading.currentValue?.toStringAsFixed(1) ?? '--',
            style: GoogleFonts.inter(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            reading.definition.unit,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.textSecondary,
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
          _stat(l.sensorMin, reading.minValue?.toStringAsFixed(1) ?? '--'),
          _stat(l.sensorMax, reading.maxValue?.toStringAsFixed(1) ?? '--'),
          _stat(l.sensorAvg, reading.avgValue?.toStringAsFixed(1) ?? '--'),
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHistoryChart(AppLocalizations l) {
    if (reading.history.isEmpty) {
      return GlassCard(
        child: Center(
          child: Text(
            l.sensorNoData,
            style: GoogleFonts.inter(color: AppTheme.textTertiary),
          ),
        ),
      );
    }

    final spots = reading.history
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.sensorHistory,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
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

  Widget _buildInfoCard(AppLocalizations l) {
    final pid = reading.definition;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.sensorInfo,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow('PID', pid.pid),
          _infoRow(l.sensorUnit, pid.unit),
          _infoRow(l.sensorCategory, pid.category.name),
          if (pid.normalMax != null)
            _infoRow(l.sensorNormalMax, '${pid.normalMax} ${pid.unit}'),
          if (pid.warningMax != null)
            _infoRow(l.sensorWarningMax, '${pid.warningMax} ${pid.unit}'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
