import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Log levels for the application logger
enum LogLevel {
  /// Debug level - detailed information for debugging
  debug,
  
  /// Info level - general information
  info,
  
  /// Warning level - potential issues
  warning,
  
  /// Error level - errors that need attention
  error,
}

/// Extension for LogLevel utilities
extension LogLevelExtension on LogLevel {
  /// Get the emoji icon for the log level
  String get icon {
    switch (this) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }
  
  /// Get the log level name in uppercase
  String get label => name.toUpperCase();
}

/// Callback for custom log output (e.g., Firebase Crashlytics, Sentry)
typedef LogCallback = void Function(String message, LogLevel level, {Object? error, StackTrace? stackTrace});

/// Centralized application logger
/// 
/// Provides easy-to-use logging with automatic log level filtering
/// based on `AppConfig.enableLogging`.
/// 
/// Usage:
/// ```dart
/// AppLogger.d('Debug message');
/// AppLogger.i('Info message');
/// AppLogger.w('Warning message');
/// AppLogger.e('Error message', error: exception, stackTrace: stackTrace);
/// ```
class AppLogger {
  /// Whether logging is enabled (set during initialization)
  static bool _enabled = kDebugMode;
  
  /// Optional callback for remote logging (Crashlytics, Sentry, etc.)
  static LogCallback? _remoteLogCallback;
  
  /// Tag to use for dart:developer log
  static String _tag = 'Inspector';
  
  // Private constructor to prevent instantiation
  AppLogger._();
  
  /// Initialize the logger
  /// 
  /// [enabled] - Whether logging should be enabled
  /// [tag] - Optional tag for log messages (default: 'Inspector')
  /// [remoteLogCallback] - Optional callback for sending logs to remote services
  static void init({
    required bool enabled,
    String tag = 'Inspector',
    LogCallback? remoteLogCallback,
  }) {
    _enabled = enabled;
    _tag = tag;
    _remoteLogCallback = remoteLogCallback;
  }
  
  /// Log a debug message
  /// 
  /// Debug logs are for detailed information useful during development.
  static void d(String message, {String? tag}) {
    _log(message, level: LogLevel.debug, tag: tag);
  }
  
  /// Log an info message
  /// 
  /// Info logs are for general information about app operation.
  static void i(String message, {String? tag}) {
    _log(message, level: LogLevel.info, tag: tag);
  }
  
  /// Log a warning message
  /// 
  /// Warning logs indicate potential issues that don't prevent operation.
  static void w(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(message, level: LogLevel.warning, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log an error message
  /// 
  /// Error logs indicate failures that need attention.
  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log(message, level: LogLevel.error, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log a message with specified level
  /// 
  /// This is a convenience method for when set the level dynamically.
  static void log(String message, {LogLevel level = LogLevel.info, String? tag, Object? error, StackTrace? stackTrace}) {
    _log(message, level: level, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Internal logging implementation
  static void _log(
    String message, {
    required LogLevel level,
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? _tag;
    final formattedMessage = '${level.icon} [$logTag] $message';
    
    // Only log to console if enabled
    if (_enabled) {
      // Use dart:developer for debug console
      developer.log(
        formattedMessage,
        name: logTag,
        level: _logLevelToInt(level),
        error: error,
        stackTrace: stackTrace,
      );
      
      // Also use debugPrint for Flutter DevTools (handles long messages)
      if (error != null) {
        debugPrint('$formattedMessage\nError: $error');
        if (stackTrace != null) {
          debugPrint('StackTrace: $stackTrace');
        }
      } else {
        debugPrint(formattedMessage);
      }
    }
    
    // Always send to remote callback if provided (for production logging)
    _remoteLogCallback?.call(message, level, error: error, stackTrace: stackTrace);
  }
  
  /// Convert LogLevel to int for dart:developer
  static int _logLevelToInt(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500; // Fine
      case LogLevel.info:
        return 800; // Info
      case LogLevel.warning:
        return 900; // Warning
      case LogLevel.error:
        return 1000; // Severe
    }
  }
  
  // ============================================================
  // Convenience methods for structured logging
  // ============================================================
  
  /// Log a network request
  static void network(String method, String url, {dynamic body, Map<String, dynamic>? headers}) {
    if (!_enabled) return;
    
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌─────────────────────────────────────────────────────')
      ..writeln('│ 📤 REQUEST')
      ..writeln('│ $method $url');
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers: $headers');
    }
    if (body != null) {
      buffer.writeln('│ Body: $body');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    
    _log(buffer.toString(), level: LogLevel.info, tag: 'Network');
  }
  
  /// Log a network response
  static void networkResponse(int? statusCode, String url, {dynamic data}) {
    if (!_enabled) return;
    
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌─────────────────────────────────────────────────────')
      ..writeln('│ 📥 RESPONSE')
      ..writeln('│ $statusCode $url');
    if (data != null) {
      buffer.writeln('│ Data: $data');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    
    _log(buffer.toString(), level: LogLevel.info, tag: 'Network');
  }
  
  /// Log a network error
  static void networkError(String method, String url, {String? message, int? statusCode, dynamic data}) {
    if (!_enabled) return;
    
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌─────────────────────────────────────────────────────')
      ..writeln('│ ❌ ERROR')
      ..writeln('│ $method $url');
    if (message != null) {
      buffer.writeln('│ Message: $message');
    }
    if (statusCode != null) {
      buffer.writeln('│ Status: $statusCode');
    }
    if (data != null) {
      buffer.writeln('│ Data: $data');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    
    _log(buffer.toString(), level: LogLevel.error, tag: 'Network');
  }
}
