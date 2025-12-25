import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inspector/features/localization/presentation/bloc/language_cubit.dart';
import 'package:inspector/features/localization/presentation/model/language_state.dart';
import 'package:inspector/features/localization/presentation/widget/language_dialog.dart';

/// Icon button that shows language dialog on tap
/// Use in AppBar actions
class LanguageIconButton extends StatelessWidget {
  const LanguageIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      bloc: GetIt.instance<LanguageCubit>(),
      builder: (context, langState) {
        return IconButton(
          icon: const Icon(Icons.language),
          tooltip: langState.currentLanguage.name,
          onPressed: () => showLanguageDialog(context),
        );
      },
    );
  }
}
