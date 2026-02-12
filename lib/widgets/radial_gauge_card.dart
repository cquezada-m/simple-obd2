import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../l10n/app_localizations.dart';
import '../models/vehicle_parameter.dart';
import '../theme/app_theme.dart';
import '../widgets/pulsing_dot.dart';

/// Displays RPM and Speed as analog radial gauges inside a GlassCard.
class RadialGaugeCard extends StatelessWidget {
  final VehicleParameter rpm;
  final VehicleParameter speed;

  const RadialGaugeCard({super.key, required this.rpm, required this.speed});

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
                l.gaugesTitle,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGauge(
                  label: l.paramRpm,
                  value: double.tryParse(rpm.value) ?? 0,
                  min: 0,
                  max: 6000,
                  unit: rpm.unit,
                  color: AppTheme.purple,
                  interval: 1000,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildGauge(
                  label: l.paramSpeed,
                  value: double.tryParse(speed.value) ?? 0,
                  min: 0,
                  max: 240,
                  unit: speed.unit,
                  color: AppTheme.primary,
                  interval: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGauge({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Color color,
    required double interval,
  }) {
    return Semantics(
      label: '$label: ${value.toInt()} $unit',
      child: SizedBox(
        height: 180,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: min,
              maximum: max,
              interval: interval,
              startAngle: 135,
              endAngle: 45,
              showLastLabel: true,
              radiusFactor: 0.95,
              labelOffset: 12,
              axisLabelStyle: GaugeTextStyle(
                fontSize: 9,
                color: AppTheme.textTertiary,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
              axisLineStyle: AxisLineStyle(
                thickness: 0.08,
                thicknessUnit: GaugeSizeUnit.factor,
                color: AppTheme.textTertiary.withValues(alpha: 0.12),
              ),
              majorTickStyle: const MajorTickStyle(
                length: 8,
                thickness: 1.5,
                color: AppTheme.textTertiary,
              ),
              minorTickStyle: const MinorTickStyle(
                length: 4,
                thickness: 1,
                color: AppTheme.textTertiary,
              ),
              minorTicksPerInterval: 4,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: min,
                  endValue: value.clamp(min, max),
                  startWidth: 0.08,
                  endWidth: 0.08,
                  sizeUnit: GaugeSizeUnit.factor,
                  color: color.withValues(alpha: 0.35),
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: value.clamp(min, max),
                  needleLength: 0.6,
                  needleStartWidth: 0.5,
                  needleEndWidth: 2,
                  needleColor: color,
                  knobStyle: KnobStyle(
                    knobRadius: 0.06,
                    color: color,
                    borderColor: Colors.white,
                    borderWidth: 2,
                  ),
                  enableAnimation: true,
                  animationDuration: 180,
                  animationType: AnimationType.ease,
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${value.toInt()}',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        unit,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  positionFactor: 0.75,
                  angle: 90,
                ),
                GaugeAnnotation(
                  widget: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  positionFactor: 0.05,
                  angle: 90,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
