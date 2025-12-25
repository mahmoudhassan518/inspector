import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:inspector/core/config/environment.dart';

/// Application configuration singleton
///
/// Handles all environment-specific configuration including:
/// - API URLs (base URL, portal URL)
/// - Feature flags (logging, analytics, etc.)
/// - App metadata (name, bundle ID suffix)
///
/// Initialize before using:
/// ```dart
/// AppConfig.initialize(); // Auto-detect from FLAVOR
/// // or
/// AppConfig.initialize(environment: Environment.dev);
/// ```
class AppConfig {
  static late AppConfig _instance;

  /// Get the current app configuration instance
  static AppConfig get instance => _instance;

  /// Current environment
  final Environment environment;

  /// Display name for the app
  final String appName;

  /// Base URL for API requests
  final String baseUrl;

  /// Portal/Web URL for linking
  final String portalUrl;

  /// Enable request/response logging
  final bool enableLogging;

  /// Enable analytics tracking
  final bool enableAnalytics;

  /// Enable Firebase Remote Config
  final bool enableRemoteConfig;

  /// Enable device security checks (root/jailbreak detection)
  final bool enableSecurityChecks;

  /// Storage key prefix for SharedPreferences
  final String storageKey;

  /// API key for authentication
  final String apiKey;

  /// Application bundle/package identifier
  final String applicationId;

  /// Google Maps API key
  final String googleMapsApiKey;

  /// Whether running in debug mode
  final bool isDebugMode;

  AppConfig._({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.portalUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableRemoteConfig,
    required this.enableSecurityChecks,
    required this.storageKey,
    required this.apiKey,
    required this.applicationId,
    required this.googleMapsApiKey,
    required this.isDebugMode,
  });

  /// Initialize the app configuration
  ///
  /// [environment] - Optional explicit environment, otherwise auto-detected
  static void initialize({Environment? environment}) {
    final env = environment ?? _detectEnvironment();

    _instance = AppConfig._(
      environment: env,
      appName: _getAppName(env),
      baseUrl: _getBaseUrl(env),
      portalUrl: _getPortalUrl(env),
      enableLogging: _shouldEnableLogging(env),
      enableAnalytics: _shouldEnableAnalytics(env),
      enableRemoteConfig: _shouldEnableRemoteConfig(env),
      enableSecurityChecks: _shouldEnableSecurityChecks(env),
      storageKey: _getStorageKey(env),
      apiKey: _getApiKey(env),
      applicationId: _getApplicationId(env),
      googleMapsApiKey: _getGoogleMapsApiKey(),
      isDebugMode: kDebugMode,
    );
  }

  // ============================================================
  // Environment Detection
  // ============================================================

  /// Detect environment from compile-time constants or build mode
  static Environment _detectEnvironment() {
    // Try compile-time constants first (--dart-define=FLAVOR=xxx)
    const flavorFromDefine = String.fromEnvironment('FLAVOR', defaultValue: '');
    if (flavorFromDefine.isNotEmpty) {
      return _parseEnvironment(flavorFromDefine);
    }

    // Fallback based on build mode
    if (kDebugMode) return Environment.dev;
    if (kProfileMode) return Environment.staging;
    return Environment.prod;
  }

  /// Parse environment string to enum
  static Environment _parseEnvironment(String value) {
    switch (value.toLowerCase()) {
      case 'dev':
      case 'development':
        return Environment.dev;
      case 'qa':
      case 'test':
        return Environment.qa;
      case 'staging':
      case 'stage':
        return Environment.staging;
      case 'prod':
      case 'production':
        return Environment.prod;
      default:
        return Environment.dev;
    }
  }

  // ============================================================
  // Configuration Values
  // ============================================================

  /// Get app name for current environment
  static String _getAppName(Environment env) {
    const appNameFromEnv = String.fromEnvironment('APP_NAME', defaultValue: '');
    if (appNameFromEnv.isNotEmpty) return appNameFromEnv;

    switch (env) {
      case Environment.dev:
        return 'Inspector Dev';
      case Environment.qa:
        return 'Inspector QA';
      case Environment.staging:
        return 'Inspector Staging';
      case Environment.prod:
        return 'Inspector';
    }
  }

  /// Get base API URL for current environment
  static String _getBaseUrl(Environment env) {
    const urlFromEnv = String.fromEnvironment('BASE_URL', defaultValue: '');
    if (urlFromEnv.isNotEmpty) return urlFromEnv;

    // TODO: Replace with actual URLs
    switch (env) {
      case Environment.dev:
        return 'https://dev-api.inspector.example.com/api';
      case Environment.qa:
        return 'https://qa-api.inspector.example.com/api';
      case Environment.staging:
        return 'https://staging-api.inspector.example.com/api';
      case Environment.prod:
        return 'https://api.inspector.example.com/api';
    }
  }

  /// Get portal/web URL for current environment
  static String _getPortalUrl(Environment env) {
    const urlFromEnv = String.fromEnvironment('PORTAL_URL', defaultValue: '');
    if (urlFromEnv.isNotEmpty) return urlFromEnv;

    // TODO: Replace with actual URLs
    switch (env) {
      case Environment.dev:
        return 'https://dev.inspector.example.com';
      case Environment.qa:
        return 'https://qa.inspector.example.com';
      case Environment.staging:
        return 'https://staging.inspector.example.com';
      case Environment.prod:
        return 'https://inspector.example.com';
    }
  }

  /// Determine if logging should be enabled
  static bool _shouldEnableLogging(Environment env) {
    const loggingFromEnv = String.fromEnvironment(
      'ENABLE_LOGGING',
      defaultValue: '',
    );
    if (loggingFromEnv.isNotEmpty) {
      return loggingFromEnv.toLowerCase() == 'true';
    }

    // Enable logging for all environments except prod
    return env != Environment.prod;
  }

  /// Determine if analytics should be enabled
  static bool _shouldEnableAnalytics(Environment env) {
    const analyticsFromEnv = String.fromEnvironment(
      'ENABLE_ANALYTICS',
      defaultValue: '',
    );
    if (analyticsFromEnv.isNotEmpty) {
      return analyticsFromEnv.toLowerCase() == 'true';
    }

    // Enable analytics for staging and prod only
    return env == Environment.prod || env == Environment.staging;
  }

  /// Determine if remote config should be enabled
  static bool _shouldEnableRemoteConfig(Environment env) {
    const remoteConfigFromEnv = String.fromEnvironment(
      'ENABLE_REMOTE_CONFIG',
      defaultValue: '',
    );
    if (remoteConfigFromEnv.isNotEmpty) {
      return remoteConfigFromEnv.toLowerCase() == 'true';
    }

    // Enable remote config for all environments
    return true;
  }

  /// Determine if security checks should be enabled
  static bool _shouldEnableSecurityChecks(Environment env) {
    const securityFromEnv = String.fromEnvironment(
      'ENABLE_SECURITY_CHECKS',
      defaultValue: '',
    );
    if (securityFromEnv.isNotEmpty) {
      return securityFromEnv.toLowerCase() == 'true';
    }

    // Enable in release mode or for staging/prod
    if (kReleaseMode) return true;
    return env == Environment.prod || env == Environment.staging;
  }

  /// Get storage key prefix for environment
  static String _getStorageKey(Environment env) {
    return 'inspector_storage_${env.name}';
  }

  /// Get API key for environment
  static String _getApiKey(Environment env) {
    const keyFromEnv = String.fromEnvironment('API_KEY', defaultValue: '');
    if (keyFromEnv.isNotEmpty) return keyFromEnv;

    // TODO: Replace with actual API keys (these are dummy values)
    switch (env) {
      case Environment.dev:
        return 'DEV-INSPECTOR-API-KEY-2024';
      case Environment.qa:
        return 'QA-INSPECTOR-API-KEY-2024';
      case Environment.staging:
        return 'STAGING-INSPECTOR-API-KEY-2024';
      case Environment.prod:
        return 'PROD-INSPECTOR-API-KEY-2024';
    }
  }

  /// Get application bundle/package ID
  static String _getApplicationId(Environment env) {
    String baseId;
    if (Platform.isAndroid) {
      baseId = 'com.inspector.app';
    } else if (Platform.isIOS) {
      baseId = 'com.inspector.app';
    } else {
      baseId = 'com.inspector.app';
    }

    switch (env) {
      case Environment.dev:
        return '$baseId.dev';
      case Environment.qa:
        return '$baseId.qa';
      case Environment.staging:
        return '$baseId.staging';
      case Environment.prod:
        return baseId;
    }
  }

  /// Get Google Maps API key
  static String _getGoogleMapsApiKey() {
    const keyFromEnv = String.fromEnvironment('GOOGLE_MAPS_KEY', defaultValue: '');
    return keyFromEnv;
  }

  // ============================================================
  // Convenience Getters
  // ============================================================

  /// Check if running in development environment
  bool get isDevelopment => environment == Environment.dev;

  /// Check if running in production environment
  bool get isProduction => environment == Environment.prod;

  /// Check if running in QA environment
  bool get isQA => environment == Environment.qa;

  /// Check if running in staging environment
  bool get isStaging => environment == Environment.staging;

  /// Check if this is a test/dev environment (for payment sandboxing, etc.)
  bool get isTestEnvironment =>
      environment == Environment.dev || environment == Environment.qa;

  /// Check if remote config is enabled
  bool get isRemoteConfigEnabled => enableRemoteConfig;

  /// Check if security checks are enabled
  bool get isSecurityEnabled => enableSecurityChecks;

  /// Allow insecure external images (dev/qa only)
  bool get allowInsecureImages =>
      environment == Environment.dev || environment == Environment.qa;

  /// Get environment display name
  String get environmentName => environment.displayName;

  // ============================================================
  // Debug & Logging
  // ============================================================

  /// Convert configuration to map for logging
  Map<String, dynamic> toMap() {
    return {
      'environment': environment.name,
      'appName': appName,
      'baseUrl': baseUrl,
      'portalUrl': portalUrl,
      'enableLogging': enableLogging,
      'enableAnalytics': enableAnalytics,
      'enableRemoteConfig': enableRemoteConfig,
      'enableSecurityChecks': enableSecurityChecks,
      'storageKey': storageKey,
      'apiKey': '<redacted>',
      'applicationId': applicationId,
      'googleMapsApiKey': googleMapsApiKey.isEmpty ? '<empty>' : '<redacted>',
      'isDebugMode': isDebugMode,
      'platform': Platform.operatingSystem,
    };
  }

  /// Log configuration to console (only if logging enabled)
  void logConfiguration() {
    if (enableLogging) {
      debugPrint('╔══════════════════════════════════════════╗');
      debugPrint('║         APP CONFIGURATION                ║');
      debugPrint('╠══════════════════════════════════════════╣');
      toMap().forEach((key, value) {
        debugPrint('║ $key: $value');
      });
      debugPrint('╚══════════════════════════════════════════╝');
    }
  }

  @override
  String toString() => 'AppConfig(${environment.name})';
}
