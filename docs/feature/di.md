# Feature DI

Each feature has DI folder: `features/{feature}/di/{feature}_injection_container.dart`

## Feature DI File

`lib/features/auth/di/auth_injection_container.dart`:

```dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initAuthFeature() async {
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(networkClient: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // BLoC (Factory - new CommonCubit per BLoC)
  sl.registerFactory(() => AuthBloc(
    commonCubit: CommonCubit(),
    loginUseCase: sl(),
  ));
}
```

## Main injection_container.dart

Core + Network only, imports feature DIs:

```dart
import 'package:inspector/features/auth/di/auth_injection_container.dart';

Future<void> initDependencies() async {
  await _initCore();
  await _initNetworkModule();
  
  // Features
  await initAuthFeature();
}
```

## Adding New Feature

1. Create `features/{name}/di/{name}_injection_container.dart`
2. Define `init{Name}Feature()` function
3. Import and call in `injection_container.dart`
