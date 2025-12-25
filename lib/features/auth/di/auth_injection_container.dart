import 'package:get_it/get_it.dart';
import 'package:inspector/core/core.dart';
import 'package:inspector_network/inspector_network.dart';
import 'package:inspector/features/auth/data/repository/auth_repository_impl.dart';
import 'package:inspector/features/auth/data/source/auth_local_data_source.dart';
import 'package:inspector/features/auth/data/source/auth_remote_data_source.dart';
import 'package:inspector/features/auth/domain/repository/auth_repository.dart';
import 'package:inspector/features/auth/domain/usecases/usecases.dart';
import 'package:inspector/features/auth/presentation/bloc/login_bloc.dart';
import 'package:inspector/features/auth/presentation/bloc/register_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

/// Initialize auth feature dependencies
Future<void> initAuthFeature() async {
  // Data Sources (concrete classes - no abstract)
  sl.registerLazySingleton(
    () => AuthRemoteDataSource(networkClient: sl<NetworkClient>()),
  );
  sl.registerLazySingleton(
    () => AuthLocalDataSource(prefs: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));

  // Login BLoC - handles form state + API calls
  sl.registerFactory(
    () => LoginBloc(
      loginUseCase: sl(),
      commonCubit: CommonCubit(),
    ),
  );

  // Register BLoC - handles form state + API calls
  sl.registerFactory(
    () => RegisterBloc(
      registerUseCase: sl(),
      commonCubit: CommonCubit(),
    ),
  );
}
