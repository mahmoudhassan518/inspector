import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/model/language.dart';
import '../bloc/language_cubit.dart';
import '../model/language_state.dart';

/// A simple dropdown widget to change language
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCubit = GetIt.instance<LanguageCubit>();
    
    return BlocBuilder<LanguageCubit, LanguageState>(
      bloc: languageCubit,
      builder: (context, langState) {
        return DropdownButton<Language>(
          value: langState.currentLanguage,
          items: Language.supportedLanguages.map((language) {
            return DropdownMenuItem(
              value: language,
              child: Text('${language.nativeName} (${language.name})'),
            );
          }).toList(),
          onChanged: langState.isLoading
              ? null
              : (language) {
                  if (language != null) {
                    languageCubit.changeLanguage(language);
                  }
                },
        );
      },
    );
  }
}
