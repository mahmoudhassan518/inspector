import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inspector/features/localization/data/repository/language_repository_impl.dart';
import 'package:inspector/features/localization/data/source/language_local_data_source.dart';
import 'package:inspector/features/localization/domain/repository/language_repository.dart';
import 'package:inspector/features/localization/domain/usecases/get_saved_language_usecase.dart';
import 'package:inspector/features/localization/domain/usecases/save_language_usecase.dart';
import 'package:inspector/features/localization/presentation/bloc/language_cubit.dart';

final sl = GetIt.instance;

/// Initialize localization feature dependencies
Future<void> initLocalizationFeature() async {
  // Data Sources
  sl.registerLazySingleton(
    () => LanguageLocalDataSource(prefs: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<LanguageRepository>(
    () => LanguageRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSavedLanguageUseCase(sl()));
  sl.registerLazySingleton(() => SaveLanguageUseCase(sl()));

  // Cubit (Singleton - shared across app)
  sl.registerLazySingleton(() => LanguageCubit(
    getSavedLanguageUseCase: sl(),
    saveLanguageUseCase: sl(),
  ));
}
