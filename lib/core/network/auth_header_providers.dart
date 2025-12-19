import 'package:inspector_core/inspector_core.dart';

/// Bearer token header provider implementation
class BearerAuthHeaderProvider implements AuthHeaderProvider {
  @override
  Map<String, String> buildAuthHeaders(String accessToken) {
    return {'Authorization': 'Bearer $accessToken'};
  }
}

/// API Key header provider implementation
class ApiKeyAuthHeaderProvider implements AuthHeaderProvider {
  final String headerName;

  ApiKeyAuthHeaderProvider({this.headerName = 'X-API-Key'});

  @override
  Map<String, String> buildAuthHeaders(String accessToken) {
    return {headerName: accessToken};
  }
}
