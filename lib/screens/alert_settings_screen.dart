import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/alert_config.dart';
import '../providers/history_provider.dart';
import '../providers/subscription_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/paywall_sheet.dart';

/// PRO-only screen for customizing real-time alert thresholds.
class AlertSettingsScreen extends StatelessWidget {
  const AlertSettingsScreen({super.key});

  static const _defaults = <_AlertDef>[
    _AlertDef('rpm', 'RPM', 5500, AlertCondition.above, 'RPM'),
    _AlertDef('coolant_temp', 'Temp. Motor', 110, AlertCondition.above, '°C'),
    _AlertDef('speed', 'Velocidad', 180, AlertCondition.above, 'km/h'),
    _AlertDef('engine_load', 'Carga Motor', 95, AlertCondition.above, '%'),
    _AlertDef('fuel_level', 'Combustible', 10, AlertCondition.below, '%'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isPro = context.watch<SubscriptionProvider>().isPro;

    if (!isPro) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPaywall(context);
        Navigator.pop(context);
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.alertSettingsTitle)),
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
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    GlassCard(
                      child: Text(
                        l.alertSettingsDesc,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    ..._defaults.map(
                      (def) => _buildAlertTile(context, l, def, history),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertTile(
    BuildContext context,
    AppLocalizations l,
    _AlertDef def,
    HistoryProvider history,
  ) {
    final existing = history.alertConfigs
        .where((c) => c.parameterKey == def.key)
        .firstOrNull;
    final config =
        existing ??
        AlertConfig(
          parameterKey: def.key,
          threshold: def.defaultThreshold,
          condition: def.condition,
        );

    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${config.condition == AlertCondition.above ? ">" : "<"} '
                  '${config.threshold.toStringAsFixed(0)} ${def.unit}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: config.enabled,
            activeTrackColor: AppTheme.primary.withValues(alpha: 0.5),
            activeThumbColor: AppTheme.primary,
            onChanged: (v) {
              history.saveAlertConfig(config.copyWith(enabled: v));
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 18),
            color: AppTheme.primary,
            onPressed: () => _editThreshold(context, l, def, config, history),
          ),
        ],
      ),
    );
  }

  void _editThreshold(
    BuildContext context,
    AppLocalizations l,
    _AlertDef def,
    AlertConfig config,
    HistoryProvider history,
  ) {
    final ctrl = TextEditingController(
      text: config.threshold.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${def.label} ${l.alertThreshold}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(suffixText: def.unit),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(ctrl.text);
              if (val == null) return;
              history.saveAlertConfig(config.copyWith(threshold: val));
              Navigator.pop(ctx);
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }
}

class _AlertDef {
  final String key;
  final String label;
  final double defaultThreshold;
  final AlertCondition condition;
  final String unit;
  const _AlertDef(
    this.key,
    this.label,
    this.defaultThreshold,
    this.condition,
    this.unit,
  );
}
