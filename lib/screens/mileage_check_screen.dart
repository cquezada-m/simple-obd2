import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/mileage_check.dart';
import '../providers/history_provider.dart';
import '../providers/obd2_provider.dart';
import '../providers/subscription_provider.dart';
import '../services/mileage_verification_service.dart';
import '../services/pdf_report_service.dart';
import '../theme/app_theme.dart';
import '../widgets/mileage_comparison_card.dart';
import '../widgets/paywall_sheet.dart';

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

    // Gate full check for FREE users
    if (full && !context.read<SubscriptionProvider>().isPro) {
      showPaywall(context);
      return;
    }

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

      // Save to history
      if (_result != null) {
        // ignore: use_build_context_synchronously
        context.read<HistoryProvider>().saveMileageCheck(_result!);
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
                    MileageComparisonCard(sources: _result!.sources, l: l),
                    const SizedBox(height: 12),
                    GlassCard(
                      child: Text(
                        _verdictExplanation(l),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer<SubscriptionProvider>(
                      builder: (context, sub, _) {
                        if (!sub.isPro) return const SizedBox.shrink();
                        return ElevatedButton.icon(
                          onPressed: () => _exportPdf(context, l),
                          icon: const Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 18,
                          ),
                          label: Text(l.mileageExportPdf),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.error,
                          ),
                        );
                      },
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
                        child: Consumer<SubscriptionProvider>(
                          builder: (context, sub, _) {
                            return ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _runCheck(full: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.purple,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(l.mileageCheckFull),
                                  if (!sub.isPro) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.lock, size: 12),
                                  ],
                                ],
                              ),
                            );
                          },
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

  Future<void> _exportPdf(BuildContext context, AppLocalizations l) async {
    if (_result == null) return;
    try {
      final file = await PdfReportService.generateMileageReport(
        check: _result!,
        vin: context.read<Obd2Provider>().vin,
      );
      if (!context.mounted) return;
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], text: l.mileageExportPdf);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.pdfError}: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  String _verdictLabel(AppLocalizations l) {
    return switch (_result!.verdict) {
      MileageVerdict.consistent => l.mileageVerdictConsistent,
      MileageVerdict.suspicious => l.mileageVerdictSuspicious,
      MileageVerdict.tampered => l.mileageVerdictTampered,
      MileageVerdict.insufficientData => l.mileageVerdictInsufficient,
    };
  }

  String _verdictExplanation(AppLocalizations l) {
    final r = _result!;
    return switch (r.verdict) {
      MileageVerdict.consistent => l.mileageExplConsistent(
        r.odometerSourceCount,
      ),
      MileageVerdict.suspicious => l.mileageExplSuspicious,
      MileageVerdict.tampered => l.mileageExplTampered,
      MileageVerdict.insufficientData =>
        r.referenceKm != null ? l.mileageExplInsufficient : l.mileageExplNoData,
    };
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
      MileageVerdict.insufficientData => (
        AppTheme.textTertiary,
        Icons.info_outline_rounded,
      ),
    };

    return GlassCard(
      child: Column(
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(
            _verdictLabel(l),
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
