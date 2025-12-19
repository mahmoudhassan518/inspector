import 'package:equatable/equatable.dart';
import 'package:inspector/features/localization/localization_feature.dart';

/// Global app state
class InspectorState extends Equatable {
  final LanguageState languageState;
  // Add more global states here (theme, connectivity, etc.)

  const InspectorState({
    this.languageState = const LanguageState(),
  });

  InspectorState copyWith({
    LanguageState? languageState,
  }) {
    return InspectorState(
      languageState: languageState ?? this.languageState,
    );
  }

  @override
  List<Object?> get props => [languageState];
}
