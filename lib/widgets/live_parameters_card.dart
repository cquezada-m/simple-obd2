import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/vehicle_parameter.dart';
import '../theme/app_theme.dart';
import 'animated_value_text.dart';
import 'pulsing_dot.dart';

class LiveParametersCard extends StatelessWidget {
  final List<VehicleParameter> parameters;

  const LiveParametersCard({super.key, required this.parameters});

  Color _progressColor(double percentage) {
    if (percentage > 80) return AppTheme.error;
    if (percentage > 60) return AppTheme.warning;
    if (percentage > 40) return AppTheme.primary;
    return AppTheme.success;
  }

  String _localizedLabel(String key, AppLocalizations l) {
    return switch (key) {
      'rpm' => l.paramRpm,
      'speed' => l.paramSpeed,
      'engine_temp' => l.paramEngineTemp,
      'engine_load' => l.paramEngineLoad,
      'intake_pressure' => l.paramIntakePressure,
      'fuel_level' => l.paramFuelLevel,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Filter out RPM and Speed — they're shown in the RadialGaugeCard
    final filtered = parameters
        .where((p) => p.label != 'rpm' && p.label != 'speed')
        .toList();
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.liveParameters,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PulsingDot(color: AppTheme.success),
                    const SizedBox(width: 5),
                    Text(
                      l.live,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.width > 400
                  ? 1.35
                  : 1.2,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final p = filtered[index];
              final label = _localizedLabel(p.label, l);
              return Semantics(
                label: '$label: ${p.value} ${p.unit}',
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(p.icon, size: 16, color: AppTheme.textTertiary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              label,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedValueText(
                            value: p.value,
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              p.unit,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(end: p.percentage / 100),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        builder: (context, animated, _) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: animated,
                              minHeight: 4,
                              backgroundColor: AppTheme.textTertiary.withValues(
                                alpha: 0.12,
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                _progressColor(p.percentage),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
