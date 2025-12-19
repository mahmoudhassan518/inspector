import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/data/model/user_response.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  final NetworkClient _networkClient;

  AuthRemoteDataSource({required NetworkClient networkClient})
      : _networkClient = networkClient;

  /// Login with email and password
  Future<UserResponse> login(String email, String password) async {
    final response = await _networkClient.post<Map<String, dynamic>>(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    return UserResponse.fromJson(response);
  }

  /// Register new user
  Future<UserResponse> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _networkClient.post<Map<String, dynamic>>(
      '/auth/register',
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
    return UserResponse.fromJson(response);
  }

  /// Logout (invalidate tokens on server)
  Future<void> logout() async {
    await _networkClient.post<void>('/auth/logout');
  }

  /// Get current user profile
  Future<UserResponse> getCurrentUser() async {
    final response = await _networkClient.get<Map<String, dynamic>>('/auth/me');
    return UserResponse.fromJson(response);
  }
}
