import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspector/features/localization/localization_feature.dart';
import 'inspector_event.dart';
import 'inspector_state.dart';

/// Global app bloc containing all global sub-cubits
class InspectorBloc extends Bloc<InspectorEvent, InspectorState> {
  final LanguageCubit languageCubit;
  // Add more global cubits here (themeCubit, connectivityCubit, etc.)

  InspectorBloc({
    required this.languageCubit,
  }) : super(InspectorState(languageState: languageCubit.state)) {
    // Listen to language cubit changes
    languageCubit.stream.listen((langState) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(state.copyWith(languageState: langState));
    });

    // Register event handlers
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<InspectorState> emit,
  ) async {
    await languageCubit.changeLanguage(event.language);
  }

  /// Get current language
  Language get currentLanguage => state.languageState.currentLanguage;

  @override
  Future<void> close() {
    languageCubit.close();
    return super.close();
  }
}

/// Global instance
late InspectorBloc inspectorBloc;
