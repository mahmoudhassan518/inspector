import 'package:dio/dio.dart';

/// Callback for logging messages from the interceptor
typedef LoggerCallback = void Function(String message);

/// Logging interceptor for Dio requests
/// 
/// By default uses [print] for logging. You can provide a custom
/// [logger] callback to integrate with your app's logging system.
/// 
/// Example with AppLogger:
/// ```dart
/// LoggingInterceptor(
///   logger: (message) => AppLogger.i(message, tag: 'Network'),
/// )
/// ```
class LoggingInterceptor extends Interceptor {
  /// Custom logger callback. If null, uses [print].
  final LoggerCallback? logger;
  
  /// Whether to log request/response data (can be verbose)
  final bool logData;
  
  /// Whether to log headers
  final bool logHeaders;
  
  /// Creates a logging interceptor
  /// 
  /// [logger] - Custom log function (defaults to print)
  /// [logData] - Whether to include request/response body in logs
  /// [logHeaders] - Whether to include headers in logs
  LoggingInterceptor({
    this.logger,
    this.logData = true,
    this.logHeaders = false,
  });
  
  void _log(String message) {
    if (logger != null) {
      logger!(message);
    } else {
      // Default fallback - the main app should provide a logger
      // that respects AppConfig.enableLogging
      // ignore: avoid_print
      print(message);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌─────────────────────────────────────────────────────')
      ..writeln('│ 📤 REQUEST')
      ..writeln('│ ${options.method} ${options.uri}');
    if (logHeaders && options.headers.isNotEmpty) {
      buffer.writeln('│ Headers: ${options.headers}');
    }
    if (logData && options.data != null) {
      buffer.writeln('│ Body: ${options.data}');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    _log(buffer.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌─────────────────────────────────────────────────────')
      ..writeln('│ 📥 RESPONSE')
      ..writeln('│ ${response.statusCode} ${response.requestOptions.uri}');
    if (logData) {
      buffer.writeln('│ Data: ${response.data}');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    _log(buffer.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌─────────────────────────────────────────────────────')
      ..writeln('│ ❌ ERROR')
      ..writeln('│ ${err.requestOptions.method} ${err.requestOptions.uri}')
      ..writeln('│ Message: ${err.message}');
    if (err.response != null) {
      buffer.writeln('│ Status: ${err.response?.statusCode}');
      if (logData) {
        buffer.writeln('│ Data: ${err.response?.data}');
      }
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    _log(buffer.toString());
    handler.next(err);
  }
}

