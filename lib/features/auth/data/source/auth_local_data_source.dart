import 'package:inspector/features/auth/data/model/user_response.dart';

/// Local data source for authentication
/// Handles caching user data and tokens
abstract class AuthLocalDataSource {
  /// Cache user data
  Future<void> cacheUser(UserResponse user);

  /// Get cached user
  Future<UserResponse?> getCachedUser();

  /// Clear cached user data
  Future<void> clearCache();

  /// Save access token
  Future<void> saveAccessToken(String token);

  /// Get access token
  Future<String?> getAccessToken();

  /// Save refresh token
  Future<void> saveRefreshToken(String token);

  /// Get refresh token
  Future<String?> getRefreshToken();

  /// Clear all tokens
  Future<void> clearTokens();

  /// Check if user is logged in (has valid token)
  Future<bool> isLoggedIn();
}
