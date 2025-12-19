import 'package:get_it/get_it.dart';
import 'package:inspector/core/di/core_injection_container.dart';
import 'package:inspector/features/auth/di/auth_injection_container.dart';
import 'package:inspector/features/localization/di/localization_injection_container.dart';
import 'package:inspector/features/localization/localization_feature.dart';
import 'package:inspector/inspector/inspector.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // 1. Core basics (SharedPreferences, CommonCubit, TokenProvider)
  await initCore();
  
  // 2. Localization (needs SharedPreferences)
  await initLocalizationFeature();
  
  // 3. Network (needs LanguageLocalDataSource for Accept-Language header)
  initNetwork();
  
  // 4. InspectorBloc (global app state)
  sl.registerLazySingleton(() => InspectorBloc(
    languageCubit: sl<LanguageCubit>(),
  ));
  inspectorBloc = sl<InspectorBloc>();
  
  // 5. Features
  await initAuthFeature();
}
