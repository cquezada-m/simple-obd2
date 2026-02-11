import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class ConnectionCard extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const ConnectionCard({
    super.key,
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              _buildStatusIcon(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isConnected
                          ? l.connected
                          : isConnecting
                          ? l.connecting
                          : l.disconnected,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (isConnected) ...[
                          const Icon(
                            Icons.wifi_rounded,
                            size: 13,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          isConnected ? 'OBD2 ELM327' : l.obd2Device,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isConnected)
                OutlinedButton(
                  onPressed: onDisconnect,
                  child: Text(
                    l.disconnect,
                    style: GoogleFonts.inter(fontSize: 13),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: isConnecting ? null : onConnect,
                  child: Text(
                    isConnecting ? l.connecting : l.connect,
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
            ],
          ),
          if (!isConnected && !isConnecting) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppTheme.primary.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.connectionHint,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    final Color bgColor;
    final Color iconColor;
    final String statusLabel;
    if (isConnected) {
      bgColor = AppTheme.success.withValues(alpha: 0.12);
      iconColor = AppTheme.success;
      statusLabel = 'Connected';
    } else if (isConnecting) {
      bgColor = AppTheme.primary.withValues(alpha: 0.12);
      iconColor = AppTheme.primary;
      statusLabel = 'Connecting';
    } else {
      bgColor = AppTheme.textTertiary.withValues(alpha: 0.12);
      iconColor = AppTheme.textTertiary;
      statusLabel = 'Disconnected';
    }

    return Semantics(
      label: statusLabel,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.bluetooth_rounded, size: 22, color: iconColor),
      ),
    );
  }
}
