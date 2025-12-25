/// Application configuration exports
///
/// Usage:
/// ```dart
/// import 'package:inspector/core/config/config.dart';
///
/// // Initialize at app start
/// AppConfig.initialize();
///
/// // Access configuration
/// print(AppConfig.instance.baseUrl);
/// print(AppConfig.instance.environment);
/// ```
library;

export 'environment.dart';
export 'app_config.dart';
