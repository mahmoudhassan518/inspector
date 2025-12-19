import 'network_exception.dart';

/// Business exception with error code from API
class BusinessException extends NetworkException {
  final String errorCode;
  final dynamic data;

  const BusinessException({
    required this.errorCode,
    super.message,
    super.statusCode,
    this.data,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() => 'BusinessException: $errorCode - $message';
}
