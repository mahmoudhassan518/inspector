import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for language preferences
/// Handles storing and retrieving language preference
class LanguageLocalDataSource {
  static const String _languageKey = 'user_language';

  final SharedPreferences _prefs;

  LanguageLocalDataSource({required SharedPreferences prefs})
      : _prefs = prefs;

  /// Get the saved language code
  Future<String?> getLanguageCode() async {
    return _prefs.getString(_languageKey);
  }

  /// Save language code
  Future<void> saveLanguageCode(String code) async {
    await _prefs.setString(_languageKey, code);
  }

  /// Clear saved language
  Future<void> clearLanguageCode() async {
    await _prefs.remove(_languageKey);
  }
}
