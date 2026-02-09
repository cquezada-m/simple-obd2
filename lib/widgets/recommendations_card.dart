import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import '../theme/app_theme.dart';

class AiRecommendationsCard extends StatelessWidget {
  final List<Recommendation> recommendations;
  const AiRecommendationsCard({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            ...recommendations.map(_buildRec),
            const SizedBox(height: 12),
            _buildDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.purpleLight, AppTheme.primaryLight]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.auto_awesome, size: 20, color: AppTheme.purple),
      ),
      const SizedBox(width: 12),
      const Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analisis AI', style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary)),
          SizedBox(height: 2),
          Text('Recomendaciones basadas en diagnostico', style: TextStyle(
            fontSize: 12, color: AppTheme.textSecondary)),
        ],
      )),
    ]);
  }

  Widget _buildRec(Recommendation rec) {
    final bColor = _pColor(rec.priority);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.build_outlined, size: 16, color: AppTheme.textSecondary),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text(rec.title, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: bColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: bColor.withValues(alpha: 0.3)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_pIcon(rec.priority), size: 12, color: bColor),
                  const SizedBox(width: 4),
                  Text(_pLabel(rec.priority), style: TextStyle(
                    fontSize: 10, color: bColor, fontWeight: FontWeight.w500)),
                ]),
              ),
            ]),
            const SizedBox(height: 6),
            Text(rec.description, style: const TextStyle(
              fontSize: 12, color: AppTheme.textSecondary, height: 1.5)),
            const SizedBox(height: 10),
            const Text('Componentes a revisar:', style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            Wrap(spacing: 6, runSpacing: 6, children: rec.components.map((c) =>
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.border)),
                child: Text(c, style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary)),
              )).toList()),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppTheme.border))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Costo estimado', style: TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary)),
                  Text(rec.estimatedCost, style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                ],
              ),
            ),
          ],
        )),
      ]),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.purpleLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.purple.withValues(alpha: 0.1)),
      ),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.auto_awesome, size: 16, color: AppTheme.purple),
        SizedBox(width: 8),
        Expanded(child: Text.rich(
          TextSpan(children: [
            TextSpan(text: 'Analisis generado por IA: ',
              style: TextStyle(fontWeight: FontWeight.w500)),
            TextSpan(text: 'Las recomendaciones se basan en los codigos de diagnostico actuales y parametros del vehiculo. Consulta con un mecanico certificado.'),
          ]),
          style: TextStyle(fontSize: 12, color: AppTheme.textPrimary),
        )),
      ]),
    );
  }

  Color _pColor(RecommendationPriority p) => switch (p) {
    RecommendationPriority.high => AppTheme.error,
    RecommendationPriority.medium => AppTheme.warning,
    RecommendationPriority.low => AppTheme.success,
  };

  String _pLabel(RecommendationPriority p) => switch (p) {
    RecommendationPriority.high => 'Prioridad Alta',
    RecommendationPriority.medium => 'Prioridad Media',
    RecommendationPriority.low => 'Prioridad Baja',
  };

  IconData _pIcon(RecommendationPriority p) => switch (p) {
    RecommendationPriority.high => Icons.error_outline,
    RecommendationPriority.medium => Icons.lightbulb_outline,
    RecommendationPriority.low => Icons.check_circle_outline,
  };
}
