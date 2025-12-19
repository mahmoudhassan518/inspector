import 'package:inspector/features/auth/data/model/user_response.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Login with email and password
  /// Returns [UserResponse] with tokens
  Future<UserResponse> login(String email, String password);

  /// Register new user
  Future<UserResponse> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout (invalidate tokens on server)
  Future<void> logout();

  /// Get current user profile
  Future<UserResponse> getCurrentUser();
}
