import 'package:inspector_core/inspector_core.dart';
import 'package:inspector/features/localization/domain/model/language.dart';
import 'package:inspector/features/localization/domain/repository/language_repository.dart';

/// UseCase to save language preference
class SaveLanguageUseCase implements UseCase<void, Language> {
  final LanguageRepository repository;

  SaveLanguageUseCase(this.repository);

  @override
  Future<void> call(Language language) => repository.saveLanguage(language);
}

