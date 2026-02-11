import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.es;

  AppLanguage get language => _language;
  String get locale => _language == AppLanguage.es ? 'es' : 'en';

  void setLanguage(AppLanguage lang) {
    if (_language != lang) {
      _language = lang;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _language = _language == AppLanguage.es ? AppLanguage.en : AppLanguage.es;
    notifyListeners();
  }
}
