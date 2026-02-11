/// Resultado del diagnóstico generado por Gemini AI.
class AiDiagnostic {
  final String summary;
  final List<String> possibleCauses;
  final List<String> checkPoints;
  final String urgencyLevel;
  final String estimatedCost;
  final DateTime timestamp;

  const AiDiagnostic({
    required this.summary,
    required this.possibleCauses,
    required this.checkPoints,
    required this.urgencyLevel,
    required this.estimatedCost,
    required this.timestamp,
  });

  factory AiDiagnostic.fromGeminiResponse(String text) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();

    String summary = '';
    final causes = <String>[];
    final checks = <String>[];
    String urgency = 'Media';
    String cost = 'No estimado';

    _Section current = _Section.none;

    for (final line in lines) {
      final lower = line.toLowerCase().trim();

      if (lower.startsWith('resumen') ||
          lower.startsWith('diagnóstico') ||
          lower.startsWith('diagnostico')) {
        current = _Section.summary;
        final after = _extractAfterColon(line);
        if (after.isNotEmpty) summary = after;
        continue;
      }
      if (lower.startsWith('posibles causas') || lower.startsWith('causas')) {
        current = _Section.causes;
        continue;
      }
      if (lower.startsWith('puntos a revisar') ||
          lower.startsWith('puntos de revisión') ||
          lower.startsWith('revisión') ||
          lower.startsWith('revision')) {
        current = _Section.checks;
        continue;
      }
      if (lower.startsWith('urgencia') ||
          lower.startsWith('nivel de urgencia')) {
        urgency = _extractAfterColon(line);
        if (urgency.isEmpty) urgency = 'Media';
        current = _Section.none;
        continue;
      }
      if (lower.startsWith('costo estimado') ||
          lower.startsWith('coste estimado')) {
        cost = _extractAfterColon(line);
        if (cost.isEmpty) cost = 'No estimado';
        current = _Section.none;
        continue;
      }

      final cleaned = line.trim().replaceFirst(RegExp(r'^[-•*\d.]+\s*'), '');
      if (cleaned.isEmpty) continue;

      switch (current) {
        case _Section.summary:
          summary += summary.isEmpty ? cleaned : ' $cleaned';
        case _Section.causes:
          causes.add(cleaned);
        case _Section.checks:
          checks.add(cleaned);
        case _Section.none:
          if (summary.isEmpty) summary = cleaned;
      }
    }

    return AiDiagnostic(
      summary: summary.isNotEmpty ? summary : text,
      possibleCauses: causes,
      checkPoints: checks,
      urgencyLevel: urgency,
      estimatedCost: cost,
      timestamp: DateTime.now(),
    );
  }

  static String _extractAfterColon(String line) {
    final idx = line.indexOf(':');
    if (idx == -1) return '';
    return line.substring(idx + 1).trim();
  }
}

enum _Section { none, summary, causes, checks }
