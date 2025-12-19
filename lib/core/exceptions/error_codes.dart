/// Common error codes shared across features
abstract class CommonErrorCodes {
  // Validation
  static const invalidInput = 'INVALID_INPUT';
  static const missingField = 'MISSING_FIELD';

  // Resources
  static const resourceNotFound = 'RESOURCE_NOT_FOUND';
  static const resourceAlreadyExists = 'RESOURCE_ALREADY_EXISTS';

  // General
  static const operationFailed = 'OPERATION_FAILED';
  static const permissionDenied = 'PERMISSION_DENIED';
}
