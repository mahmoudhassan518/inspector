import 'package:shared_preferences/shared_preferences.dart';

import 'package:inspector_network/inspector_network.dart';

/// SharedPreferences implementation of TokenProvider
class TokenProviderImpl implements TokenProvider {
  final SharedPreferences _prefs;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  TokenProviderImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await _prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  @override
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }
}
