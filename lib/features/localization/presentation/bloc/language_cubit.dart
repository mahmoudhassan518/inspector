import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspector_core/inspector_core.dart';
import 'package:inspector/features/localization/domain/model/language.dart';
import 'package:inspector/features/localization/domain/usecases/get_saved_language_usecase.dart';
import 'package:inspector/features/localization/domain/usecases/save_language_usecase.dart';
import 'package:inspector/features/localization/presentation/model/language_state.dart';

/// Cubit for managing language state
/// Auto-loads saved language on creation
class LanguageCubit extends Cubit<LanguageState> {
  final GetSavedLanguageUseCase _getSavedLanguageUseCase;
  final SaveLanguageUseCase _saveLanguageUseCase;

  LanguageCubit({
    required GetSavedLanguageUseCase getSavedLanguageUseCase,
    required SaveLanguageUseCase saveLanguageUseCase,
  })  : _getSavedLanguageUseCase = getSavedLanguageUseCase,
        _saveLanguageUseCase = saveLanguageUseCase,
        super(const LanguageState()) {
    // Auto-load saved language on creation
    loadLanguage();
  }

  /// Load saved language from storage
  Future<void> loadLanguage() async {
    try {
      emit(state.copyWith(isLoading: true));
      final savedLanguage = await _getSavedLanguageUseCase(const NoParams());
      emit(state.copyWith(
        currentLanguage: savedLanguage ?? Language.english,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        currentLanguage: Language.english,
        isLoading: false,
      ));
    }
  }

  /// Change app language
  Future<void> changeLanguage(Language language) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _saveLanguageUseCase(language);
      emit(state.copyWith(
        currentLanguage: language,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
