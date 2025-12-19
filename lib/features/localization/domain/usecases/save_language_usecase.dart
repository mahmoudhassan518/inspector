import 'package:inspector_core/inspector_core.dart';
import '../model/language.dart';
import '../repository/language_repository.dart';

/// UseCase to save language preference
class SaveLanguageUseCase implements UseCase<void, Language> {
  final LanguageRepository repository;

  SaveLanguageUseCase(this.repository);

  @override
  Future<void> call(Language language) => repository.saveLanguage(language);
}

