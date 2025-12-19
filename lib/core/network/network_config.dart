/// Network configuration for DI
class NetworkConfig {
  /// Base URL for API requests
  final String baseUrl;

  /// Enable logging interceptor (request/response logging)
  final bool enableLogging;

  /// Enable auth interceptor (token management)
  final bool enableAuth;

  /// Connection timeout in seconds
  final int connectTimeoutSeconds;

  /// Receive timeout in seconds
  final int receiveTimeoutSeconds;

  /// Send timeout in seconds
  final int sendTimeoutSeconds;

  const NetworkConfig({
    required this.baseUrl,
    this.enableLogging = true,
    this.enableAuth = true,
    this.connectTimeoutSeconds = 30,
    this.receiveTimeoutSeconds = 30,
    this.sendTimeoutSeconds = 30,
  });
}
