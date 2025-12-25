import 'package:inspector_core/inspector_core.dart';
import 'package:inspector/features/localization/domain/model/language.dart';
import 'package:inspector/features/localization/domain/repository/language_repository.dart';

/// UseCase to get the saved language
class GetSavedLanguageUseCase implements UseCase<Language?, NoParams> {
  final LanguageRepository repository;

  GetSavedLanguageUseCase(this.repository);

  @override
  Future<Language?> call(NoParams params) => repository.getSavedLanguage();
}

