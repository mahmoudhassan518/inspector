import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inspector/core/core.dart';

final sl = GetIt.instance;

/// Network configuration - set before calling initCore()
NetworkConfig networkConfig = const NetworkConfig(
  baseUrl: 'https://api.example.com',
  enableLogging: true,
  enableAuth: true,
);

/// Initialize core dependencies
Future<void> initCore() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Global CommonCubit (Singleton - for showGlobalToast)
  sl.registerLazySingleton<CommonCubit>(() => CommonCubit());
  globalCommonCubit = sl<CommonCubit>();

  // TokenProvider
  sl.registerLazySingleton<TokenProvider>(
    () => TokenProviderImpl(prefs: sl<SharedPreferences>()),
  );

  // AuthHeaderProvider (Bearer by default)
  sl.registerLazySingleton<AuthHeaderProvider>(
    () => BearerAuthHeaderProvider(),
  );

  // ErrorMapper
  sl.registerLazySingleton<ErrorMapper<ErrorModel>>(
    () => DefaultErrorMapper(),
  );

  // Dio with interceptors
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: networkConfig.baseUrl,
        connectTimeout: Duration(seconds: networkConfig.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: networkConfig.receiveTimeoutSeconds),
        sendTimeout: Duration(seconds: networkConfig.sendTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor (configurable)
    if (networkConfig.enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }

    // Error interceptor - handles error mapping (skips 401)
    dio.interceptors.add(
      ErrorInterceptor(errorMapper: sl<ErrorMapper<ErrorModel>>()),
    );

    // Auth interceptor (configurable) - handles 401 after ErrorInterceptor skips it
    if (networkConfig.enableAuth) {
      dio.interceptors.add(
        AuthInterceptor(
          tokenProvider: sl<TokenProvider>(),
          headerProvider: sl<AuthHeaderProvider>(),
          onUnauthorized: () => _handleUnauthorized(),
        ),
      );
    }

    return dio;
  });

  // NetworkClient
  sl.registerLazySingleton<NetworkClient>(
    () => DioNetworkClient(dio: sl<Dio>()),
  );
}

/// Handle unauthorized (401) - logout user
Future<void> _handleUnauthorized() async{
  showGlobalToast(
    message: 'Session expired. Please login again.',
    level: AlertType.warning,
  );
  // TODO: Navigate to login, clear user data
}
