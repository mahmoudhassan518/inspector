/// Available application environments
enum Environment {
  /// Development - Local development with full logging
  dev,

  /// Quality Assurance - Testing environment
  qa,

  /// Staging - Pre-production testing
  staging,

  /// Production - Live environment
  prod,
}

/// Extension for environment utilities
extension EnvironmentExtension on Environment {
  /// Returns the environment name in uppercase
  String get displayName => name.toUpperCase();

  /// Check if this is a development environment (dev or qa)
  bool get isDevEnvironment => this == Environment.dev || this == Environment.qa;

  /// Check if this is a production-like environment (staging or prod)
  bool get isProdLike => this == Environment.staging || this == Environment.prod;
}
