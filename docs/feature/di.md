# Feature DI

Location: `features/{feature}/di/{feature}_injection_container.dart`

## Feature DI File

```dart
import 'package:get_it/get_it.dart';
import 'package:inspector/core/core.dart';

final sl = GetIt.instance;

Future<void> initAuthFeature() async {
  // Data Sources (concrete classes - no abstract)
  sl.registerLazySingleton(
    () => AuthRemoteDataSource(networkClient: sl()),
  );
  sl.registerLazySingleton(
    () => AuthLocalDataSource(prefs: sl()),
  );

  // Repository (interface in domain)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // BLoC (Factory - new instance each time)
  sl.registerFactory(() => AuthBloc(
    commonCubit: CommonCubit(),
    loginUseCase: sl(),
  ));
}
```

## Registration Rules

| Component | Type | Notes |
|-----------|------|-------|
| DataSource | `registerLazySingleton` | Concrete class, no type param needed |
| Repository | `registerLazySingleton<Interface>` | Register as interface type |
| UseCase | `registerLazySingleton` | Concrete class |
| BLoC | `registerFactory` | New CommonCubit per instance |

## Main injection_container.dart

`lib/injection_container.dart`:

```dart
import 'package:inspector/core/di/core_injection_container.dart';
import 'package:inspector/features/auth/di/auth_injection_container.dart';

Future<void> initDependencies() async {
  await initCore();
  
  // Features
  await initAuthFeature();
}
```

## Adding New Feature

1. Create `features/{name}/di/{name}_injection_container.dart`
2. Define `init{Name}Feature()` function
3. Import and call in `lib/injection_container.dart`
