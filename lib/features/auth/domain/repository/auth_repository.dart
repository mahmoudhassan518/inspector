import 'package:inspector/features/auth/domain/model/user_entity.dart';

/// Abstract auth repository - defines contract for data layer
abstract class AuthRepository {
  /// Login with email and password
  Future<UserEntity> login(String email, String password);

  /// Register new user
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current logged in user
  Future<UserEntity?> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
