import 'package:flutter/foundation.dart' show debugPrint;

/// Categorías de log para filtrado.
enum LogCategory {
  connection,
  command,
  parse,
  parameter,
  dtc,
  vin,
  ai,
  ui,
  error,
}

/// Entrada de log inmutable.
class LogEntry {
  final DateTime timestamp;
  final LogCategory category;
  final String message;
  final String? detail;

  const LogEntry({
    required this.timestamp,
    required this.category,
    required this.message,
    this.detail,
  });

  String get formatted {
    final ts =
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}.'
        '${timestamp.millisecond.toString().padLeft(3, '0')}';
    final tag = category.name.toUpperCase();
    final base = '[$ts][$tag] $message';
    return detail != null ? '$base\n  → $detail' : base;
  }
}

/// Logger en memoria para capturar toda la actividad de la app.
/// Singleton accesible desde cualquier parte del código.
class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  static const int maxEntries = 2000;
  final List<LogEntry> _entries = [];

  List<LogEntry> get entries => List.unmodifiable(_entries);

  /// Filtra por categoría.
  List<LogEntry> byCategory(LogCategory category) =>
      _entries.where((e) => e.category == category).toList();

  void log(LogCategory category, String message, [String? detail]) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      category: category,
      message: message,
      detail: detail,
    );
    _entries.add(entry);
    if (_entries.length > maxEntries) {
      _entries.removeRange(0, _entries.length - maxEntries);
    }
    debugPrint(entry.formatted);
  }

  void clear() => _entries.clear();

  /// Exporta todos los logs como texto plano.
  String export() => _entries.map((e) => e.formatted).join('\n');
}
