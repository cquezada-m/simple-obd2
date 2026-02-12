import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/drag_run.dart';
import '../models/drive_session.dart';
import '../models/mileage_check.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l.historyTitle),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(text: l.historyTabSessions),
            Tab(text: l.historyTabDraggy),
            Tab(text: l.historyTabMileage),
          ],
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
            child: Consumer<HistoryProvider>(
              builder: (context, history, _) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _SessionsTab(
                      sessions: history.sessions,
                      l: l,
                      history: history,
                    ),
                    _DragRunsTab(
                      runs: history.dragRuns,
                      l: l,
                      history: history,
                    ),
                    _MileageTab(checks: history.mileageChecks, l: l),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionsTab extends StatelessWidget {
  final List<DriveSession> sessions;
  final AppLocalizations l;
  final HistoryProvider history;

  const _SessionsTab({
    required this.sessions,
    required this.l,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return _EmptyState(
        icon: Icons.route_rounded,
        message: l.historyNoSessions,
      );
    }
    final sorted = List<DriveSession>.from(sessions)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final s = sorted[index];
        return Dismissible(
          key: ValueKey(s.id ?? index),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_rounded, color: AppTheme.error),
          ),
          onDismissed: (_) {
            if (s.id != null) history.deleteSession(s.id!);
          },
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.route_rounded,
                        size: 20,
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(s.startTime),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            _formatDuration(s.duration),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (s.vin != null)
                      Text(
                        s.vin!.substring(
                          s.vin!.length > 6 ? s.vin!.length - 6 : 0,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: l.driveSessionAvgSpeed,
                      value: '${s.avgSpeedKmh.toStringAsFixed(0)} km/h',
                    ),
                    _StatChip(
                      label: l.driveSessionMaxSpeed,
                      value: '${s.maxSpeedKmh} km/h',
                    ),
                    _StatChip(
                      label: l.driveSessionEvents,
                      value: '${s.events.length}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DragRunsTab extends StatelessWidget {
  final List<DragRun> runs;
  final AppLocalizations l;
  final HistoryProvider history;

  const _DragRunsTab({
    required this.runs,
    required this.l,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    if (runs.isEmpty) {
      return _EmptyState(
        icon: Icons.timer_rounded,
        message: l.historyNoDragRuns,
      );
    }
    final sorted = List<DragRun>.from(runs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final r = sorted[index];
        final best = history.bestRun(r.config.name);
        final isBest = best != null && best.id == r.id;
        return Dismissible(
          key: ValueKey(r.id ?? index),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_rounded, color: AppTheme.error),
          ),
          onDismissed: (_) {
            if (r.id != null) history.deleteDragRun(r.id!);
          },
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.timer_rounded,
                        size: 20,
                        color: AppTheme.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.config.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            _formatDate(r.timestamp),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${r.formattedTime}s',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isBest ? AppTheme.success : AppTheme.textPrimary,
                      ),
                    ),
                    if (isBest) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.emoji_events_rounded,
                        size: 18,
                        color: AppTheme.warning,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(
                      label: l.draggyTrapSpeed,
                      value: '${r.trapSpeedKmh.toStringAsFixed(0)} km/h',
                    ),
                    _StatChip(label: l.draggyMaxRpm, value: '${r.maxRpm}'),
                    _StatChip(
                      label: l.draggyTempStart,
                      value: '${r.startTempC}°C',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MileageTab extends StatelessWidget {
  final List<MileageCheck> checks;
  final AppLocalizations l;

  const _MileageTab({required this.checks, required this.l});

  @override
  Widget build(BuildContext context) {
    if (checks.isEmpty) {
      return _EmptyState(
        icon: Icons.speed_rounded,
        message: l.historyNoMileage,
      );
    }
    final sorted = List<MileageCheck>.from(checks)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final c = sorted[index];
        final (color, icon) = switch (c.verdict) {
          MileageVerdict.consistent => (
            AppTheme.success,
            Icons.check_circle_rounded,
          ),
          MileageVerdict.suspicious => (
            AppTheme.warning,
            Icons.warning_amber_rounded,
          ),
          MileageVerdict.tampered => (AppTheme.error, Icons.error_rounded),
          MileageVerdict.insufficientData => (
            AppTheme.textTertiary,
            Icons.info_outline_rounded,
          ),
        };
        return GlassCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(c.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${c.sources.length} ${l.historyModulesRead}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    c.verdict.name,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (c.referenceKm != null)
                    Text(
                      '${c.referenceKm!.toStringAsFixed(0)} km',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppTheme.textTertiary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textTertiary),
        ),
      ],
    );
  }
}

String _formatDate(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year} '
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}';
}

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  if (h > 0) return '${h}h ${m}m';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}
