import 'package:dio/dio.dart';

/// Logging interceptor for Dio requests
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────────────────────');
    buffer.writeln('│ 📤 REQUEST');
    buffer.writeln('│ ${options.method} ${options.uri}');
    if (options.headers.isNotEmpty) {
      buffer.writeln('│ Headers: ${options.headers}');
    }
    if (options.data != null) {
      buffer.writeln('│ Body: ${options.data}');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    print(buffer.toString());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────────────────────');
    buffer.writeln('│ 📥 RESPONSE');
    buffer.writeln('│ ${response.statusCode} ${response.requestOptions.uri}');
    buffer.writeln('│ Data: ${response.data}');
    buffer.writeln('└─────────────────────────────────────────────────────');
    print(buffer.toString());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('');
    buffer.writeln('┌─────────────────────────────────────────────────────');
    buffer.writeln('│ ❌ ERROR');
    buffer.writeln('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
    buffer.writeln('│ Message: ${err.message}');
    if (err.response != null) {
      buffer.writeln('│ Status: ${err.response?.statusCode}');
      buffer.writeln('│ Data: ${err.response?.data}');
    }
    buffer.writeln('└─────────────────────────────────────────────────────');
    print(buffer.toString());
    handler.next(err);
  }
}
