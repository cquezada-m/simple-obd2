import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para almacenar datos sensibles (API keys) de forma segura.
/// Usa Keychain en iOS y EncryptedSharedPreferences en Android.
class SecureStorageService {
  static const _geminiApiKeyKey = 'gemini_api_key';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Guarda el API key de Gemini de forma segura.
  static Future<void> saveGeminiApiKey(String apiKey) async {
    await _storage.write(key: _geminiApiKeyKey, value: apiKey);
  }

  /// Lee el API key de Gemini almacenado, o null si no existe.
  static Future<String?> getGeminiApiKey() async {
    return _storage.read(key: _geminiApiKeyKey);
  }

  /// Elimina el API key de Gemini almacenado.
  static Future<void> deleteGeminiApiKey() async {
    await _storage.delete(key: _geminiApiKeyKey);
  }

  /// Verifica si hay un API key de Gemini almacenado.
  static Future<bool> hasGeminiApiKey() async {
    final key = await _storage.read(key: _geminiApiKeyKey);
    return key != null && key.isNotEmpty;
  }
}
