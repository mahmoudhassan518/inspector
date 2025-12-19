import 'package:dio/dio.dart';

import '../interfaces/network_client.dart';
import '../exceptions/network_exception.dart';


/// Dio implementation of NetworkClient
/// Error handling is done via ErrorInterceptor
class DioNetworkClient implements NetworkClient {
  final Dio _dio;

  DioNetworkClient({required Dio dio}) : _dio = dio;

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<T> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => _dio.post(
        path,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<T> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => _dio.put(
        path,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<T> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => _dio.patch(
        path,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<T> delete<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _executeRequest(
      () => _dio.delete(
        path,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
      ),
    );
  }

  Future<T> _executeRequest<T>(Future<Response> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      // If error was already mapped by ErrorInterceptor, rethrow
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      // Otherwise wrap in generic NetworkException
      throw NetworkException(
        message: e.message ?? 'Network error',
        originalError: e,
        stackTrace: e.stackTrace,
      );
    }
  }
}
