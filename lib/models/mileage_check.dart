import 'mileage_source.dart';

/// Verdict of a mileage verification check.
enum MileageVerdict { consistent, suspicious, tampered }

/// Result of a mileage verification across multiple modules.
class MileageCheck {
  final DateTime timestamp;
  final List<MileageSource> sources;
  final MileageVerdict verdict;
  final String explanation;
  final String explanationEn;
  final double? referenceKm;

  const MileageCheck({
    required this.timestamp,
    required this.sources,
    required this.verdict,
    required this.explanation,
    required this.explanationEn,
    this.referenceKm,
  });

  String verdictLabel(String locale) {
    final es = switch (verdict) {
      MileageVerdict.consistent => 'Kilometraje Consistente',
      MileageVerdict.suspicious => 'Posible Reemplazo de Módulo',
      MileageVerdict.tampered => 'Posible Manipulación de Odómetro',
    };
    final en = switch (verdict) {
      MileageVerdict.consistent => 'Mileage Consistent',
      MileageVerdict.suspicious => 'Possible Module Replacement',
      MileageVerdict.tampered => 'Possible Odometer Tampering',
    };
    return locale == 'es' ? es : en;
  }

  String explanationLocalized(String locale) =>
      locale == 'es' ? explanation : explanationEn;
}
