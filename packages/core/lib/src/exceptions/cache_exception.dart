import 'app_exception.dart';

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Cache not found
class CacheNotFoundException extends CacheException {
  const CacheNotFoundException({
    super.message = 'Cache not found',
    super.code = 'CACHE_NOT_FOUND',
  });
}

/// Cache expired
class CacheExpiredException extends CacheException {
  const CacheExpiredException({
    super.message = 'Cache expired',
    super.code = 'CACHE_EXPIRED',
  });
}
