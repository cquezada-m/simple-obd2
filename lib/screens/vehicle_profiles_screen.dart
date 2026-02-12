import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/vehicle_profile.dart';
import '../providers/history_provider.dart';
import '../providers/subscription_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/paywall_sheet.dart';

class VehicleProfilesScreen extends StatelessWidget {
  const VehicleProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.profilesTitle)),
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
            child: Consumer2<HistoryProvider, SubscriptionProvider>(
              builder: (context, history, sub, _) {
                final profiles = history.profiles;
                return profiles.isEmpty
                    ? _buildEmpty(context, l, history, sub)
                    : _buildList(context, l, profiles, history, sub);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(
    BuildContext context,
    AppLocalizations l,
    HistoryProvider history,
    SubscriptionProvider sub,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_car_rounded,
            size: 64,
            color: AppTheme.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l.profilesEmpty,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddDialog(context, l, history, sub),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(l.profilesAdd),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    AppLocalizations l,
    List<VehicleProfile> profiles,
    HistoryProvider history,
    SubscriptionProvider sub,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...profiles.map((p) => _profileCard(context, l, p, history)),
        const SizedBox(height: 12),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              if (!sub.isPro && profiles.isNotEmpty) {
                showPaywall(context);
              } else {
                _showAddDialog(context, l, history, sub);
              }
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(l.profilesAdd),
          ),
        ),
      ],
    );
  }

  Widget _profileCard(
    BuildContext context,
    AppLocalizations l,
    VehicleProfile profile,
    HistoryProvider history,
  ) {
    final isActive = history.activeProfileId == profile.id;
    return GlassCard(
      child: InkWell(
        onTap: () => history.setActiveProfile(isActive ? null : profile.id),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isActive ? AppTheme.primary : AppTheme.textTertiary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.directions_car_rounded,
                color: isActive ? AppTheme.primary : AppTheme.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.nickname ?? profile.vin,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (profile.nickname != null)
                    Text(
                      profile.vin,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  if (profile.manufacturer != null)
                    Text(
                      '${profile.manufacturer ?? ''} ${profile.modelYear ?? ''}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l.profilesActive,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppTheme.error,
              ),
              onPressed: () => history.deleteProfile(profile.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(
    BuildContext context,
    AppLocalizations l,
    HistoryProvider history,
    SubscriptionProvider sub,
  ) {
    if (!sub.isPro && history.profiles.isNotEmpty) {
      showPaywall(context);
      return;
    }
    final vinCtrl = TextEditingController();
    final nickCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l.profilesAdd,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: vinCtrl,
              decoration: InputDecoration(
                labelText: 'VIN',
                labelStyle: GoogleFonts.inter(fontSize: 13),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nickCtrl,
              decoration: InputDecoration(
                labelText: l.profilesNickname,
                labelStyle: GoogleFonts.inter(fontSize: 13),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final vin = vinCtrl.text.trim();
              if (vin.isEmpty) return;
              final profile = VehicleProfile(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                vin: vin,
                nickname: nickCtrl.text.trim().isEmpty
                    ? null
                    : nickCtrl.text.trim(),
                createdAt: DateTime.now(),
              );
              history.addProfile(profile);
              Navigator.pop(ctx);
            },
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }
}
