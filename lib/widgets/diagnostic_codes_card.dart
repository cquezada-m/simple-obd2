import 'package:flutter/material.dart';
import '../models/dtc_code.dart';
import '../theme/app_theme.dart';

class DiagnosticCodesCard extends StatelessWidget {
  final List<DtcCode> codes;
  final VoidCallback onClearCodes;
  final bool isClearing;

  const DiagnosticCodesCard({
    super.key,
    required this.codes,
    required this.onClearCodes,
    required this.isClearing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Códigos de Diagnóstico',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (codes.isNotEmpty)
                  OutlinedButton(
                    onPressed: isClearing ? null : onClearCodes,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                    ),
                    child: Text(
                      isClearing ? 'Borrando...' : 'Borrar',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (codes.isEmpty) _buildEmptyState() else _buildCodesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.successLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 32,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sin códigos de error',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'El sistema está funcionando correctamente',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildCodesList() {
    return Column(
      children: codes.map((code) {
        final (bgColor, borderColor, iconColor, icon, label) = _severityStyle(
          code.severity,
        );
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          code.code,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      code.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  (Color, Color, Color, IconData, String) _severityStyle(DtcSeverity severity) {
    switch (severity) {
      case DtcSeverity.critical:
        return (
          AppTheme.errorLight,
          AppTheme.error.withValues(alpha: 0.2),
          AppTheme.error,
          Icons.report,
          'Crítico',
        );
      case DtcSeverity.warning:
        return (
          AppTheme.warningLight,
          AppTheme.warning.withValues(alpha: 0.2),
          AppTheme.warning,
          Icons.warning_amber,
          'Advertencia',
        );
      case DtcSeverity.info:
        return (
          AppTheme.primaryLight,
          AppTheme.primary.withValues(alpha: 0.2),
          AppTheme.primary,
          Icons.info_outline,
          'Info',
        );
    }
  }
}
