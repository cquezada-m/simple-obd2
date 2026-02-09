enum DtcSeverity { critical, warning, info }

class DtcCode {
  final String code;
  final String description;
  final DtcSeverity severity;

  const DtcCode({
    required this.code,
    required this.description,
    required this.severity,
  });
}
