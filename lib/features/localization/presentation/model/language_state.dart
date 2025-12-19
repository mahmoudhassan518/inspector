import 'package:equatable/equatable.dart';
import 'package:inspector_core/inspector_core.dart';
import '../../domain/model/language.dart';

/// State for LanguageBloc
class LanguageState extends Equatable {
  final Language currentLanguage;
  final bool isLoading;

  const LanguageState({
    this.currentLanguage = Language.english,
    this.isLoading = false,
  });

  LanguageState copyWith({
    Language? currentLanguage,
    bool? isLoading,
  }) {
    return LanguageState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [currentLanguage, isLoading];
}

