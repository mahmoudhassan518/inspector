import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:inspector/features/auth/data/model/user_response.dart';

/// Local data source for authentication
/// Handles caching user data and tokens
class AuthLocalDataSource {
  static const _keyUser = 'cached_user';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  final SharedPreferences _prefs;

  AuthLocalDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  /// Cache user data
  Future<void> cacheUser(UserResponse user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  /// Get cached user
  Future<UserResponse?> getCachedUser() async {
    final jsonString = _prefs.getString(_keyUser);
    if (jsonString == null) return null;
    return UserResponse.fromJson(jsonDecode(jsonString));
  }

  /// Clear cached user data
  Future<void> clearCache() async {
    await _prefs.remove(_keyUser);
  }

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_keyAccessToken, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return _prefs.getString(_keyAccessToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_keyRefreshToken, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_keyRefreshToken);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyRefreshToken);
  }

  /// Check if user is logged in (has valid token)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
