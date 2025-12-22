/// Abstract network client interface
abstract class NetworkClient {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });

  Future<T> post<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });

  Future<T> put<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });

  Future<T> patch<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });

  Future<T> delete<T>(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });
}
