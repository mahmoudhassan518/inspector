import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/navigation/navigation.dart';
import 'package:inspector/features/localization/localization_feature.dart';
import 'package:inspector/inspector/inspector.dart';

/// Main application widget
class InspectorApp extends StatelessWidget {
  const InspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: globalCommonCubit),
        BlocProvider.value(value: inspectorBloc),
      ],
      child: BlocSelector<InspectorBloc, InspectorState, LanguageState>(
        selector: (state) => state.languageState,
        builder: (context, languageState) {
          return MaterialApp.router(
            title: 'Inspector',
            debugShowCheckedModeBanner: false,
            
            // Locale from InspectorBloc
            locale: Locale(languageState.currentLanguage.code),
            
            // Supported locales
            supportedLocales: AppLocalizations.supportedLocales,
            
            // Localization delegates (auto-generated + Material/Cupertino)
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            
            // Wrap router with StateView for global loading/toasts
            builder: (context, child) {
              return StateView(
                cubit: globalCommonCubit,
                child: child,
              );
            },
            
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
