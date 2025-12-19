import '../model/language.dart';

/// Repository for managing language preferences
abstract class LanguageRepository {
  /// Get the currently saved language
  Future<Language?> getSavedLanguage();

  /// Save the user's language preference
  Future<void> saveLanguage(Language language);

  /// Clear the saved language
  Future<void> clearLanguage();
}

