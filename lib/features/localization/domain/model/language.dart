import 'package:equatable/equatable.dart';

/// Represents a language supported by the app
class Language extends Equatable {
  final String code;
  final String name;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  @override
  List<Object?> get props => [code, name, nativeName];

  /// Supported languages
  static const english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  );

  static const arabic = Language(
    code: 'ar',
    name: 'Arabic',
    nativeName: 'العربية',
  );

  /// List of all supported languages
  static const List<Language> supportedLanguages = [
    english,
    arabic,
  ];

  /// Get language by code
  static Language fromCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => english,
    );
  }
}

