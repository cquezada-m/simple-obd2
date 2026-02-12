import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/dtc_code.dart';
import '../providers/subscription_provider.dart';
import '../theme/app_theme.dart';
import 'paywall_sheet.dart';

class DiagnosticCodesCard extends StatelessWidget {
  final List<DtcCode> codes;
  final VoidCallback onClearCodes;
  final bool isClearing;

  const DiagnosticCodesCard({
    super.key,
    required this.codes,
    required this.onClearCodes,
    required this.isClearing,
  });

  Future<void> _confirmClearCodes(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final sub = context.read<SubscriptionProvider>();

    if (!sub.canClearDtcs) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.clearDtcLimitReached),
          backgroundColor: AppTheme.warning,
          action: SnackBarAction(
            label: l.proUpgrade,
            textColor: Colors.white,
            onPressed: () => showPaywall(context),
          ),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l.clearCodesConfirmTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          l.clearCodesConfirmMsg,
          style: GoogleFonts.inter(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text(l.confirm, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      onClearCodes();
      sub.recordDtcClear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.diagnosticCodes,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (codes.isNotEmpty)
                TextButton(
                  onPressed: isClearing
                      ? null
                      : () => _confirmClearCodes(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isClearing ? l.clearing : l.clearCodes,
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (codes.isEmpty)
            _buildEmptyState(l)
          else
            _buildCodesList(context, l),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 32,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.noErrorCodes,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.systemOk,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodesList(BuildContext context, AppLocalizations l) {
    final isPro = context.watch<SubscriptionProvider>().isPro;
    final limit = SubscriptionProvider.freeDtcLimit;
    final visibleCodes = isPro ? codes : codes.take(limit).toList();
    final hasHidden = !isPro && codes.length > limit;

    return Column(
      children: [
        ...visibleCodes.map((code) => _buildCodeTile(code, l)),
        if (hasHidden) ...[
          // Blurred preview of next code
          if (codes.length > limit)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Opacity(
                  opacity: 0.5,
                  child: _buildCodeTile(codes[limit], l),
                ),
              ),
            ),
          // "See all" CTA
          GestureDetector(
            onTap: () => showPaywall(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.purple.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.purple.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 16,
                    color: AppTheme.purple,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l.dtcLimitMsg(limit, codes.length),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.purple,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l.proBadge,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCodeTile(DtcCode code, AppLocalizations l) {
    final (color, icon, label) = _severityStyle(code.severity, l);
    return Semantics(
      label: '${code.code}: ${code.description}. $label',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        code.code,
                        style: GoogleFonts.jetBrainsMono(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    code.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, IconData, String) _severityStyle(
    DtcSeverity severity,
    AppLocalizations l,
  ) {
    switch (severity) {
      case DtcSeverity.critical:
        return (AppTheme.error, Icons.error_rounded, l.severityCritical);
      case DtcSeverity.warning:
        return (
          AppTheme.warning,
          Icons.warning_amber_rounded,
          l.severityWarning,
        );
      case DtcSeverity.info:
        return (AppTheme.primary, Icons.info_outline_rounded, l.severityInfo);
    }
  }
}
