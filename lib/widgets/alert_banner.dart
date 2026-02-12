import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/alert_config.dart';
import '../theme/app_theme.dart';

/// Banner widget that displays an active real-time alert.
class AlertBanner extends StatelessWidget {
  final ActiveAlert alert;
  final VoidCallback? onDismiss;

  const AlertBanner({super.key, required this.alert, this.onDismiss});

  @override
  Widget build(BuildContext context) {
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
              '${alert.config.parameterKey}: ${alert.currentValue.toStringAsFixed(0)}',
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
