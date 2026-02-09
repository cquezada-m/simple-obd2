import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/recommendation.dart';
import '../theme/app_theme.dart';

class AiRecommendationsCard extends StatelessWidget {
  final List<Recommendation> recommendations;
  const AiRecommendationsCard({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          ...recommendations.map(_buildRec),
          const SizedBox(height: 8),
          _buildDisclaimer(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.purple.withValues(alpha: 0.12),
                AppTheme.primary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: AppTheme.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Análisis AI',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Recomendaciones basadas en diagnóstico',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRec(Recommendation rec) {
    final bColor = _pColor(rec.priority);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  rec.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_pIcon(rec.priority), size: 11, color: bColor),
                    const SizedBox(width: 4),
                    Text(
                      _pLabel(rec.priority),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: bColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rec.description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: rec.components
                .map(
                  (c) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      c,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.textTertiary.withValues(alpha: 0.15),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Costo estimado',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textTertiary,
                  ),
                ),
                Text(
                  rec.estimatedCost,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.purple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 14,
            color: AppTheme.purple.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Análisis generado por IA. ',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text:
                        'Consulta con un mecánico certificado antes de realizar reparaciones.',
                    style: GoogleFonts.inter(),
                  ),
                ],
              ),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _pColor(RecommendationPriority p) => switch (p) {
    RecommendationPriority.high => AppTheme.error,
    RecommendationPriority.medium => AppTheme.warning,
    RecommendationPriority.low => AppTheme.success,
  };

  String _pLabel(RecommendationPriority p) => switch (p) {
    RecommendationPriority.high => 'Alta',
    RecommendationPriority.medium => 'Media',
    RecommendationPriority.low => 'Baja',
  };

  IconData _pIcon(RecommendationPriority p) => switch (p) {
    RecommendationPriority.high => Icons.error_outline_rounded,
    RecommendationPriority.medium => Icons.lightbulb_outline_rounded,
    RecommendationPriority.low => Icons.check_circle_outline_rounded,
  };
}
