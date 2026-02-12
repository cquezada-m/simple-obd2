import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../models/vehicle_info.dart';
import '../theme/app_theme.dart';

class VehicleInfoCard extends StatefulWidget {
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
  State<VehicleInfoCard> createState() => _VehicleInfoCardState();
}

class _VehicleInfoCardState extends State<VehicleInfoCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GlassCard(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Row(
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
                        widget.vin.isNotEmpty ? widget.vin : l.obd2SystemData,
                        style: widget.vin.isNotEmpty
                            ? GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              )
                            : GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more_rounded,
                    size: 22,
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  if (widget.vin.isNotEmpty)
                    _infoRow(
                      Icons.shield_outlined,
                      'VIN',
                      widget.vin,
                      mono: true,
                    ),
                  if (widget.vin.isNotEmpty) const SizedBox(height: 8),
                  if (widget.vehicleInfo.manufacturer != null) ...[
                    _infoRow(
                      Icons.factory_outlined,
                      l.manufacturer,
                      widget.vehicleInfo.manufacturer!,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (widget.vehicleInfo.modelYear != null) ...[
                    _infoRow(
                      Icons.calendar_today_outlined,
                      l.modelYear,
                      '${widget.vehicleInfo.modelYear}',
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (widget.vehicleInfo.region != null) ...[
                    _infoRow(
                      Icons.public_outlined,
                      l.region,
                      widget.vehicleInfo.region!,
                    ),
                    const SizedBox(height: 8),
                  ],
                  _infoRow(
                    Icons.info_outline_rounded,
                    l.protocol,
                    widget.protocol,
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    Icons.memory_rounded,
                    l.ecusDetected,
                    '${widget.ecuCount}',
                  ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeOutCubic,
          ),
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
