import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:inspector/features/auth/data/model/user_response.dart';
import 'package:inspector/features/auth/data/source/auth_local_data_source.dart';

/// SharedPreferences implementation of [AuthLocalDataSource]
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _keyUser = 'cached_user';
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> cacheUser(UserResponse user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  @override
  Future<UserResponse?> getCachedUser() async {
    final jsonString = _prefs.getString(_keyUser);
    if (jsonString == null) return null;
    return UserResponse.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_keyUser);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(_keyAccessToken, token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_keyAccessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(_keyRefreshToken, token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_keyRefreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyRefreshToken);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
