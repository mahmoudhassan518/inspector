import 'package:inspector/features/localization/domain/model/language.dart';
import 'package:inspector/features/localization/domain/repository/language_repository.dart';
import 'package:inspector/features/localization/data/source/language_local_data_source.dart';

/// Implementation of LanguageRepository
class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDataSource _localDataSource;

  LanguageRepositoryImpl({required LanguageLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Language?> getSavedLanguage() async {
    final code = await _localDataSource.getLanguageCode();
    if (code == null) return null;
    return Language.fromCode(code);
  }

  @override
  Future<void> saveLanguage(Language language) async {
    await _localDataSource.saveLanguageCode(language.code);
  }

  @override
  Future<void> clearLanguage() async {
    await _localDataSource.clearLanguageCode();
  }
}

