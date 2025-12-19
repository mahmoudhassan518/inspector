/// Base network exception - all network errors extend this
class NetworkException implements Exception {
  final String? message;
  final String? code;
  final int? statusCode;
  final Object? originalError;
  final StackTrace? stackTrace;

  const NetworkException({
    this.message,
    this.code,
    this.statusCode,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'NetworkException: $message (code: $code, status: $statusCode)';
}

/// Server error (5xx)
class ServerException extends NetworkException {
  const ServerException({
    super.message,
    super.code,
    super.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

/// Unauthorized (401)
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    super.message,
    super.code,
    super.statusCode = 401,
    super.originalError,
    super.stackTrace,
  });
}

/// Forbidden (403)
class ForbiddenException extends NetworkException {
  const ForbiddenException({
    super.message,
    super.code,
    super.statusCode = 403,
    super.originalError,
    super.stackTrace,
  });
}

/// Not found (404)
class NotFoundException extends NetworkException {
  const NotFoundException({
    super.message,
    super.code,
    super.statusCode = 404,
    super.originalError,
    super.stackTrace,
  });
}

/// Bad request (400)
class BadRequestException extends NetworkException {
  const BadRequestException({
    super.message,
    super.code,
    super.statusCode = 400,
    super.originalError,
    super.stackTrace,
  });
}

/// Request timeout
class TimeoutException extends NetworkException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.code = 'TIMEOUT',
    super.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

/// No internet connection
class NoInternetException extends NetworkException {
  const NoInternetException({
    super.message = 'No internet connection',
    super.code = 'NO_INTERNET',
    super.originalError,
    super.stackTrace,
  });
}
