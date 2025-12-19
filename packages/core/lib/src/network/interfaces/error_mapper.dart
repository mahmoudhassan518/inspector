import 'package:inspector_core/inspector_core.dart';

/// Abstract error mapper interface
abstract class ErrorMapper<T extends ErrorModel> {
  /// Parse raw API error response to ErrorModel
  T parseErrorResponse(dynamic response);

  /// Convert ErrorModel to NetworkException
  NetworkException mapToException(T errorModel, {int? statusCode});
}
