import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/obd2_pid.dart';
import '../theme/app_theme.dart';
import 'sensor_sparkline.dart';

class SensorTile extends StatelessWidget {
  final Obd2Pid pid;
  final PidReading? reading;
  final String locale;

  const SensorTile({
    super.key,
    required this.pid,
    this.reading,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pid.name(locale),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      reading?.currentValue?.toStringAsFixed(1) ?? '--',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pid.unit,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (reading != null && reading!.sparklineData.isNotEmpty)
            SizedBox(
              width: 80,
              height: 32,
              child: SensorSparkline(data: reading!.sparklineData),
            ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppTheme.textTertiary,
          ),
        ],
      ),
    );
  }
}
