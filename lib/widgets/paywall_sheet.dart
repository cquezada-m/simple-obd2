import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/subscription_provider.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';

/// Shows the paywall bottom sheet. Call from any widget that gates a PRO feature.
Future<void> showPaywall(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const PaywallSheet(),
  );
}

class PaywallSheet extends StatefulWidget {
  const PaywallSheet({super.key});

  @override
  State<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<PaywallSheet> {
  List<ProPackage> _packages = [];
  int _selectedIndex = 1; // default to annual (best value)
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final packages = await PurchaseService.getOfferings();
    if (!mounted) return;
    setState(() {
      _packages = packages;
      _loading = false;
    });
  }

  Future<void> _purchase() async {
    if (_packages.isEmpty) return;
    final sub = context.read<SubscriptionProvider>();
    final pkg = _packages[_selectedIndex];
    final success = await sub.purchase(pkg.id);
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).paywallSuccess),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _restore() async {
    final sub = context.read<SubscriptionProvider>();
    final restored = await sub.restore();
    if (!mounted) return;
    final l = AppLocalizations.of(context);
    if (restored) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.paywallRestored),
          backgroundColor: AppTheme.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.paywallNoRestore),
          backgroundColor: AppTheme.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sub = context.watch<SubscriptionProvider>();
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom +
                16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildHeader(l),
              const SizedBox(height: 20),
              _buildFeatureList(l),
              const SizedBox(height: 20),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              else ...[
                _buildPackages(l),
                const SizedBox(height: 20),
                _buildPurchaseButton(l, sub),
                const SizedBox(height: 12),
                _buildRestoreButton(l),
                const SizedBox(height: 12),
                _buildLegalText(l),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.purple.withValues(alpha: 0.15),
                AppTheme.primary.withValues(alpha: 0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.workspace_premium_rounded,
            size: 32,
            color: AppTheme.purple,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l.paywallTitle,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l.paywallSubtitle,
          style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureList(AppLocalizations l) {
    final features = [
      l.paywallFeat1,
      l.paywallFeat2,
      l.paywallFeat3,
      l.paywallFeat4,
      l.paywallFeat5,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: features
            .map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: AppTheme.success,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        f,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPackages(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_packages.length, (i) {
          final pkg = _packages[i];
          final selected = i == _selectedIndex;
          final isBestValue = i == 1;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: i == 1 ? 6 : 0),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.primary.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppTheme.primary : AppTheme.border,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (isBestValue)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l.paywallBestValue,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Text(
                      pkg.label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pkg.price,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPurchaseButton(AppLocalizations l, SubscriptionProvider sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: sub.isLoading ? null : _purchase,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: sub.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  l.paywallCta,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRestoreButton(AppLocalizations l) {
    return TextButton(
      onPressed: _restore,
      child: Text(
        l.paywallRestore,
        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _buildLegalText(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        l.paywallLegal,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 10,
          color: AppTheme.textTertiary,
          height: 1.4,
        ),
      ),
    );
  }
}
