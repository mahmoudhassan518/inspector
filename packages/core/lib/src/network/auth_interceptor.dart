import 'package:dio/dio.dart';

import 'token_provider.dart';
import 'auth_header_provider.dart';

/// Default Bearer token header provider
class _DefaultBearerHeaderProvider implements AuthHeaderProvider {
  @override
  Map<String, String> buildAuthHeaders(String accessToken) {
    return {'Authorization': 'Bearer $accessToken'};
  }
}

/// Auth interceptor for adding authorization headers
/// and handling token refresh
class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;
  final AuthHeaderProvider _headerProvider;
  final Future<bool> Function(String refreshToken)? _onRefreshToken;
  final Future<void> Function()? _onUnauthorized;

  AuthInterceptor({
    required TokenProvider tokenProvider,
    AuthHeaderProvider? headerProvider,
    Future<bool> Function(String refreshToken)? onRefreshToken,
    Future<void> Function()? onUnauthorized,
  })  : _tokenProvider = tokenProvider,
        _headerProvider = headerProvider ?? _DefaultBearerHeaderProvider(),
        _onRefreshToken = onRefreshToken,
        _onUnauthorized = onUnauthorized;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.getAccessToken();
    if (token != null) {
      final headers = _headerProvider.buildAuthHeaders(token);
      options.headers.addAll(headers);
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_onRefreshToken != null) {
        final refreshToken = await _tokenProvider.getRefreshToken();
        if (refreshToken != null) {
          final success = await _onRefreshToken!(refreshToken);
          if (success) {
            // Retry the original request with new token
            final token = await _tokenProvider.getAccessToken();
            if (token != null) {
              final headers = _headerProvider.buildAuthHeaders(token);
              err.requestOptions.headers.addAll(headers);
              try {
                final dio = Dio();
                final response = await dio.fetch(err.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(err);
              }
            }
          }
        }
      }
      // No refresh or refresh failed
      await _tokenProvider.clearTokens();
      _onUnauthorized?.call();
    }
    handler.next(err);
  }
}
