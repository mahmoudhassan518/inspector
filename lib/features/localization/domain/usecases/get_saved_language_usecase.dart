import 'package:inspector_core/inspector_core.dart';
import '../model/language.dart';
import '../repository/language_repository.dart';

/// UseCase to get the saved language
class GetSavedLanguageUseCase implements UseCase<Language?, NoParams> {
  final LanguageRepository repository;

  GetSavedLanguageUseCase(this.repository);

  @override
  Future<Language?> call(NoParams params) => repository.getSavedLanguage();
}

