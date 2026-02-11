import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.privacyPolicyTitle,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F0FE), Color(0xFFF8F9FE), Color(0xFFF3E8FD)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.privacyPolicyTitle,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.privacyLastUpdated,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 20),
                ..._buildSections(l),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSections(AppLocalizations l) {
    final sections = l.privacySections;
    return sections.map((section) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['title']!,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              section['body']!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
