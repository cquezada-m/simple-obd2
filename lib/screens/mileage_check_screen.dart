import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/mileage_check.dart';
import '../providers/obd2_provider.dart';
import '../services/mileage_verification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mileage_comparison_card.dart';

class MileageCheckScreen extends StatefulWidget {
  const MileageCheckScreen({super.key});

  @override
  State<MileageCheckScreen> createState() => _MileageCheckScreenState();
}

class _MileageCheckScreenState extends State<MileageCheckScreen> {
  MileageCheck? _result;
  bool _isLoading = false;
  String? _error;

  Future<void> _runCheck({bool full = false}) async {
    final provider = context.read<Obd2Provider>();
    if (!provider.isConnected) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (provider.useMockData) {
        await Future.delayed(const Duration(seconds: 2));
        setState(
          () => _result = MileageVerificationService.mockCheck(full: full),
        );
      } else {
        final service = provider.activeService;
        if (service == null) throw Exception('No active service');

        final result = full
            ? await MileageVerificationService.fullCheck(service)
            : await MileageVerificationService.basicCheck(service);

        setState(() => _result = result);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l.mileageCheckTitle)),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          size: 48,
                          color: AppTheme.primary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.mileageCheckDesc,
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
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  else if (_error != null)
                    GlassCard(
                      child: Text(
                        _error!,
                        style: GoogleFonts.inter(color: AppTheme.error),
                      ),
                    )
                  else if (_result != null) ...[
                    _buildVerdictCard(l),
                    const SizedBox(height: 12),
                    MileageComparisonCard(
                      sources: _result!.sources,
                      locale: l.locale,
                    ),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Text(
                        _result!.explanationLocalized(l.locale),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _runCheck(),
                          child: Text(l.mileageCheckBasic),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () => _runCheck(full: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.purple,
                          ),
                          child: Text(l.mileageCheckFull),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.mileageDisclaimer,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerdictCard(AppLocalizations l) {
    final verdict = _result!.verdict;
    final (color, icon) = switch (verdict) {
      MileageVerdict.consistent => (
        AppTheme.success,
        Icons.check_circle_rounded,
      ),
      MileageVerdict.suspicious => (
        AppTheme.warning,
        Icons.warning_amber_rounded,
      ),
      MileageVerdict.tampered => (AppTheme.error, Icons.error_rounded),
    };

    return GlassCard(
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(
            _result!.verdictLabel(l.locale),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          if (_result!.referenceKm != null) ...[
            const SizedBox(height: 4),
            Text(
              '${_result!.referenceKm!.toStringAsFixed(0)} km',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
