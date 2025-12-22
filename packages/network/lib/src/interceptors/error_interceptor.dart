import 'package:dio/dio.dart';

import '../interfaces/error_model.dart';
import '../interfaces/error_mapper.dart';
import '../exceptions/network_exception.dart';


/// Error interceptor for mapping Dio errors to NetworkExceptions
/// Skips 401 errors - those are handled by AuthInterceptor
class ErrorInterceptor extends Interceptor {
  final ErrorMapper<ErrorModel> _errorMapper;

  ErrorInterceptor({required ErrorMapper<ErrorModel> errorMapper})
      : _errorMapper = errorMapper;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Skip 401 - let AuthInterceptor handle it
    if (_isUnauthorizedError(err)) {
      return handler.next(err);
    }

    final exception = _mapDioError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
        stackTrace: err.stackTrace,
      ),
    );
  }

  /// Check if error is 401 (from status code or error body via ErrorMapper)
  bool _isUnauthorizedError(DioException e) {
    // Check status code
    if (e.response?.statusCode == 401) {
      return true;
    }

    // Check error body using ErrorMapper (single source of truth)
    final data = e.response?.data;
    if (data != null) {
      final errorModel = _errorMapper.parseErrorResponse(data);
      if (errorModel.statusCode == 401 || errorModel.code == '401') {
        return true;
      }
    }

    return false;
  }

  NetworkException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return NoInternetException(
          originalError: e,
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Request timed out',
          originalError: e,
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(e);
      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled',
          originalError: e,
          stackTrace: e.stackTrace,
        );
      default:
        return NetworkException(
          message: e.message ?? 'Unknown network error',
          originalError: e,
          stackTrace: e.stackTrace,
        );
    }
  }

  NetworkException _handleBadResponse(DioException e) {
    final response = e.response;
    if (response?.data != null) {
      final errorModel = _errorMapper.parseErrorResponse(response!.data);
      return _errorMapper.mapToException(
        errorModel,
        statusCode: response.statusCode,
      );
    }

    return NetworkException(
      message: e.message ?? 'Server error',
      statusCode: response?.statusCode,
      originalError: e,
      stackTrace: e.stackTrace,
    );
  }
}
