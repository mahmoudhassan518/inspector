/// Header provider interface for customizing auth headers
abstract class AuthHeaderProvider {
  /// Build auth headers from access token
  /// Override to customize header format (Bearer, Basic, API-Key, etc.)
  /// Async to support fetching from async sources (DB, secure storage, etc.)
  Future<Map<String, String>> buildAuthHeaders(String accessToken);
}
