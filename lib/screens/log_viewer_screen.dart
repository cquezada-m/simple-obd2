import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../services/app_logger.dart';
import '../theme/app_theme.dart';

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key});

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  LogCategory? _filter;
  Timer? _refreshTimer;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  List<LogEntry> get _filteredEntries {
    final logger = AppLogger.instance;
    return _filter == null ? logger.entries : logger.byCategory(_filter!);
  }

  Future<void> _exportCsv(AppLocalizations l) async {
    final entries = _filteredEntries;
    if (entries.isEmpty) return;
    final buf = StringBuffer('timestamp,category,message,detail\n');
    for (final e in entries) {
      final ts = e.timestamp.toIso8601String();
      final cat = e.category.name;
      final msg = e.message.replaceAll('"', '""');
      final det = (e.detail ?? '').replaceAll('"', '""');
      buf.writeln('"$ts","$cat","$msg","$det"');
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/obd2_logs_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(buf.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'OBD2 Scanner Logs');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = _filteredEntries;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(l),
              _buildFilterChips(l),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          l.logsEmpty,
                          style: GoogleFonts.inter(
                            color: AppTheme.textTertiary,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
                        itemCount: entries.length,
                        itemBuilder: (_, i) => _buildLogTile(entries[i]),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        },
        child: const Icon(Icons.arrow_downward, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.logsTitle,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${_filteredEntries.length} entries',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18),
            tooltip: l.logsExport,
            color: AppTheme.primary,
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: AppLogger.instance.export()),
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l.logsCopied)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_download_rounded, size: 18),
            tooltip: l.logsExportCsv,
            color: AppTheme.success,
            onPressed: () => _exportCsv(l),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            tooltip: l.logsClear,
            color: AppTheme.error,
            onPressed: () {
              AppLogger.instance.clear();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(AppLocalizations l) {
    final filters = <LogCategory?, String>{
      null: l.logsFilterAll,
      LogCategory.connection: l.logsFilterConnection,
      LogCategory.command: l.logsFilterCommand,
      LogCategory.parse: l.logsFilterParse,
      LogCategory.dtc: l.logsFilterDtc,
      LogCategory.ai: l.logsFilterAi,
      LogCategory.error: l.logsFilterError,
    };

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: filters.entries.map((e) {
          final selected = _filter == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilterChip(
              label: Text(
                e.value,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppTheme.textSecondary,
                ),
              ),
              selected: selected,
              selectedColor: AppTheme.primary,
              backgroundColor: Colors.white.withValues(alpha: 0.6),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onSelected: (_) => setState(() => _filter = e.key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogTile(LogEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bgForCategory(entry.category),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _iconForCategory(entry.category),
                size: 12,
                color: _colorForCategory(entry.category),
              ),
              const SizedBox(width: 6),
              Text(
                '${entry.timestamp.hour.toString().padLeft(2, '0')}:'
                '${entry.timestamp.minute.toString().padLeft(2, '0')}:'
                '${entry.timestamp.second.toString().padLeft(2, '0')}.'
                '${entry.timestamp.millisecond.toString().padLeft(3, '0')}',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 10,
                  color: AppTheme.textTertiary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.message,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 11,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (entry.detail != null)
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 2),
              child: Text(
                entry.detail!,
                style: GoogleFonts.sourceCodePro(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _colorForCategory(LogCategory cat) => switch (cat) {
    LogCategory.connection => AppTheme.primary,
    LogCategory.command => AppTheme.cyan,
    LogCategory.parse => AppTheme.purple,
    LogCategory.parameter => AppTheme.success,
    LogCategory.dtc => AppTheme.warning,
    LogCategory.vin => AppTheme.primary,
    LogCategory.ai => AppTheme.purple,
    LogCategory.ui => AppTheme.textSecondary,
    LogCategory.error => AppTheme.error,
  };

  Color _bgForCategory(LogCategory cat) => switch (cat) {
    LogCategory.error => AppTheme.errorLight.withValues(alpha: 0.5),
    LogCategory.dtc => AppTheme.warningLight.withValues(alpha: 0.3),
    _ => Colors.white.withValues(alpha: 0.4),
  };

  IconData _iconForCategory(LogCategory cat) => switch (cat) {
    LogCategory.connection => Icons.wifi_rounded,
    LogCategory.command => Icons.terminal_rounded,
    LogCategory.parse => Icons.data_object_rounded,
    LogCategory.parameter => Icons.speed_rounded,
    LogCategory.dtc => Icons.warning_amber_rounded,
    LogCategory.vin => Icons.directions_car_rounded,
    LogCategory.ai => Icons.auto_awesome_rounded,
    LogCategory.ui => Icons.visibility_rounded,
    LogCategory.error => Icons.error_outline_rounded,
  };
}
