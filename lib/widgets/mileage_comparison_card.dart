import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/mileage_source.dart';
import '../theme/app_theme.dart';

/// Visual comparison table of mileage readings from different modules.
class MileageComparisonCard extends StatelessWidget {
  final List<MileageSource> sources;
  final AppLocalizations l;

  const MileageComparisonCard({
    super.key,
    required this.sources,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sources.map((s) {
          final (color, icon) = switch (s.confidence) {
            MileageConfidence.high => (
              AppTheme.success,
              Icons.check_circle_rounded,
            ),
            MileageConfidence.medium => (AppTheme.warning, Icons.info_rounded),
            MileageConfidence.low => (
              AppTheme.textTertiary,
              Icons.help_outline_rounded,
            ),
            MileageConfidence.unavailable => (
              AppTheme.textTertiary,
              Icons.remove_circle_outline,
            ),
          };

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.mileageSourceName(s.key),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  s.valueKm != null
                      ? '${s.valueKm!.toStringAsFixed(0)} km'
                      : 'N/A',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: s.valueKm != null
                        ? AppTheme.textPrimary
                        : AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
