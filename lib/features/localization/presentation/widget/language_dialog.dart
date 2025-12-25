import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inspector/features/localization/domain/model/language.dart';
import 'package:inspector/features/localization/presentation/bloc/language_cubit.dart';
import 'package:inspector/features/localization/presentation/model/language_state.dart';
import 'package:inspector/features/localization/app_strings.dart';

/// Shows language selection dialog
Future<Language?> showLanguageDialog(BuildContext context) {
  return showDialog<Language>(
    context: context,
    builder: (context) => const LanguageDialog(),
  );
}

/// Dialog for selecting app language
class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCubit = GetIt.instance<LanguageCubit>();
    final localizations = AppStrings.of(context);
    
    return BlocBuilder<LanguageCubit, LanguageState>(
      bloc: languageCubit,
      builder: (context, langState) {
        return AlertDialog(
          title: Text(localizations.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Language.supportedLanguages.map((language) {
              final isSelected = langState.currentLanguage == language;
              return ListTile(
                leading: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle_outlined),
                title: Text(language.nativeName),
                subtitle: Text(language.name),
                selected: isSelected,
                onTap: langState.isLoading
                    ? null
                    : () {
                        languageCubit.changeLanguage(language);
                        Navigator.of(context).pop(language);
                      },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
            ),
          ],
        );
      },
    );
  }
}
