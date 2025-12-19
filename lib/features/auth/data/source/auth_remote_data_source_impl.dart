import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/data/model/user_response.dart';
import 'package:inspector/features/auth/data/source/auth_remote_data_source.dart';

/// Implementation of [AuthRemoteDataSource] using NetworkClient
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkClient _networkClient;

  AuthRemoteDataSourceImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  @override
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

  @override
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

  @override
  Future<void> logout() async {
    await _networkClient.post<void>('/auth/logout');
  }

  @override
  Future<UserResponse> getCurrentUser() async {
    final response = await _networkClient.get<Map<String, dynamic>>('/auth/me');
    return UserResponse.fromJson(response);
  }
}
