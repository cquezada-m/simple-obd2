import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/alert_config.dart';
import '../theme/app_theme.dart';

/// Banner widget that displays an active real-time alert.
class AlertBanner extends StatelessWidget {
  final ActiveAlert alert;
  final VoidCallback? onDismiss;

  const AlertBanner({super.key, required this.alert, this.onDismiss});

  String _readableParamName(String key, AppLocalizations l) {
    return switch (key) {
      'rpm' => l.paramRpm,
      'speed' => l.paramSpeed,
      'engine_temp' => l.paramEngineTemp,
      'engine_load' => l.paramEngineLoad,
      'intake_pressure' => l.paramIntakePressure,
      'fuel_level' => l.paramFuelLevel,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final paramName = _readableParamName(alert.config.parameterKey, l);
    final condition = alert.config.condition == AlertCondition.above
        ? '▲'
        : '▼';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.error,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$condition $paramName: ${alert.currentValue.toStringAsFixed(0)} (${l.alertThreshold} ${alert.config.threshold.toStringAsFixed(0)})',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.error,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, size: 18, color: AppTheme.error),
            ),
        ],
      ),
    );
  }
}
