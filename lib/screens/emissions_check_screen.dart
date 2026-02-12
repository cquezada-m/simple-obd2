import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/obd2_provider.dart';
import '../theme/app_theme.dart';

class EmissionsCheckScreen extends StatelessWidget {
  const EmissionsCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.emissionsTitle)),
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
            child: Consumer<Obd2Provider>(
              builder: (context, provider, _) {
                final hasDtcs = provider.dtcCodes.isNotEmpty;
                final passes = !hasDtcs;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      GlassCard(
                        child: Column(
                          children: [
                            Icon(
                              passes
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              size: 64,
                              color: passes ? AppTheme.success : AppTheme.error,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              passes ? l.emissionsPasses : l.emissionsFails,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: passes
                                    ? AppTheme.success
                                    : AppTheme.error,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              passes
                                  ? l.emissionsPassDesc
                                  : l.emissionsFailDesc,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!passes) ...[
                        const SizedBox(height: 12),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.emissionsBlockingCodes,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...provider.dtcCodes.map(
                                (dtc) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        dtc.severity.name == 'critical'
                                            ? Icons.error_rounded
                                            : Icons.warning_amber_rounded,
                                        size: 16,
                                        color: dtc.severity.name == 'critical'
                                            ? AppTheme.error
                                            : AppTheme.warning,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${dtc.code}: ${dtc.description}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      GlassCard(
                        child: Text(
                          l.emissionsDisclaimer,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
