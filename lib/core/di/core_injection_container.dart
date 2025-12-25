import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector_network/inspector_network.dart';
import 'package:inspector/features/localization/data/source/language_local_data_source.dart';

final sl = GetIt.instance;

/// Network configuration - set before calling initCore()
/// This is now derived from AppConfig but can be overridden if needed
NetworkConfig networkConfig = const NetworkConfig(
  baseUrl: 'https://api.example.com', // Will be overridden by AppConfig
  enableLogging: true,
  enableAuth: true,
);

/// Initialize core dependencies
/// 
/// Note: Call AppConfig.initialize() before this method
Future<void> initCore() async {
  // SharedPreferences (must be first)
  if (!sl.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
  }

  // Register AppConfig as singleton for easy access via DI
  if (!sl.isRegistered<AppConfig>()) {
    sl.registerLazySingleton<AppConfig>(() => AppConfig.instance);
  }

  // Update network config from AppConfig
  final config = AppConfig.instance;
  networkConfig = NetworkConfig(
    baseUrl: config.baseUrl,
    enableLogging: config.enableLogging,
    enableAuth: true, // Always enable auth
    connectTimeoutSeconds: 30,
    receiveTimeoutSeconds: 30,
    sendTimeoutSeconds: 30,
  );

  // Global CommonCubit (Singleton - for showGlobalToast)
  sl.registerLazySingleton<CommonCubit>(() => CommonCubit());
  globalCommonCubit = sl<CommonCubit>();

  // TokenProvider
  sl.registerLazySingleton<TokenProvider>(
    () => TokenProviderImpl(prefs: sl<SharedPreferences>()),
  );

  // ErrorMapper
  sl.registerLazySingleton<ErrorMapper<ErrorModel>>(
    () => DefaultErrorMapper(),
  );
}

/// Initialize network layer (call after localization data source is registered)
void initNetwork() {
  final config = AppConfig.instance;

  // AuthHeaderProvider (uses LanguageLocalDataSource for Accept-Language)
  sl.registerLazySingleton<AuthHeaderProvider>(
    () => AuthHeaderProvidersImpl(languageDataSource: sl<LanguageLocalDataSource>()),
  );

  // Dio with interceptors
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: Duration(seconds: networkConfig.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: networkConfig.receiveTimeoutSeconds),
        sendTimeout: Duration(seconds: networkConfig.sendTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor (uses AppLogger which respects AppConfig.enableLogging)
    if (config.enableLogging) {
      dio.interceptors.add(LoggingInterceptor(
        logger: (message) => AppLogger.d(message, tag: 'Network'),
        logData: true,
        logHeaders: false, // Set to true for debugging auth issues
      ));
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
Future<void> _handleUnauthorized() async {
  showGlobalToast(
    message: 'Session expired. Please login again.',
    level: AlertType.warning,
  );
  // TODO: Navigate to login, clear user data
}

