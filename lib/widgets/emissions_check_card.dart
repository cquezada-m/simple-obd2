import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Quick emissions pre-check result card for the home screen.
class EmissionsCheckCard extends StatelessWidget {
  final bool passes;
  final int dtcCount;
  final VoidCallback onTap;

  const EmissionsCheckCard({
    super.key,
    required this.passes,
    required this.dtcCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (passes ? AppTheme.success : AppTheme.error).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                passes ? Icons.eco_rounded : Icons.block_rounded,
                color: passes ? AppTheme.success : AppTheme.error,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.emissionsTitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    passes ? l.emissionsPasses : l.emissionsFails,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: passes ? AppTheme.success : AppTheme.error,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
