import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/vehicle_info.dart';
import '../theme/app_theme.dart';

class VehicleInfoCard extends StatelessWidget {
  final String vin;
  final String protocol;
  final int ecuCount;
  final VehicleInfo vehicleInfo;

  const VehicleInfoCard({
    super.key,
    required this.vin,
    required this.protocol,
    required this.ecuCount,
    required this.vehicleInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  size: 22,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.vehicleInfo,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.obd2SystemData,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.shield_outlined, 'VIN', vin, mono: true),
          const SizedBox(height: 8),
          if (vehicleInfo.manufacturer != null) ...[
            _infoRow(
              Icons.factory_outlined,
              l.manufacturer,
              vehicleInfo.manufacturer!,
            ),
            const SizedBox(height: 8),
          ],
          if (vehicleInfo.modelYear != null) ...[
            _infoRow(
              Icons.calendar_today_outlined,
              l.modelYear,
              '${vehicleInfo.modelYear}',
            ),
            const SizedBox(height: 8),
          ],
          if (vehicleInfo.region != null) ...[
            _infoRow(Icons.public_outlined, l.region, vehicleInfo.region!),
            const SizedBox(height: 8),
          ],
          _infoRow(Icons.info_outline_rounded, l.protocol, protocol),
          const SizedBox(height: 8),
          _infoRow(Icons.memory_rounded, l.ecusDetected, '$ecuCount'),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    bool mono = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textTertiary),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: mono ? 12 : 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
