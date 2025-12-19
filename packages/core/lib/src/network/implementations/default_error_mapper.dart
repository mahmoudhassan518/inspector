import 'default_error_model.dart';
import '../interfaces/error_mapper.dart';
import '../exceptions/network_exception.dart';
import '../exceptions/business_exception.dart';

/// Default implementation of ErrorMapper
class DefaultErrorMapper extends ErrorMapper<DefaultErrorModel> {
  @override
  DefaultErrorModel parseErrorResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      return DefaultErrorModel.fromJson(response);
    }
    return DefaultErrorModel(
      message: response?.toString() ?? 'Unknown error',
    );
  }

  @override
  NetworkException mapToException(DefaultErrorModel errorModel, {int? statusCode}) {
    final effectiveStatusCode = statusCode ?? errorModel.statusCode;

    // If API returned a custom error code, create BusinessException
    if (errorModel.code != null && errorModel.code!.isNotEmpty) {
      return BusinessException(
        errorCode: errorModel.code!,
        message: errorModel.message,
        statusCode: effectiveStatusCode,
      );
    }

    // Default status code mapping
    if (effectiveStatusCode == null) {
      return NetworkException(
        message: errorModel.message,
        code: errorModel.code,
      );
    }

    return switch (effectiveStatusCode) {
      400 => BadRequestException(
          message: errorModel.message,
          code: errorModel.code,
          statusCode: effectiveStatusCode,
        ),
      401 => UnauthorizedException(
          message: errorModel.message,
          code: errorModel.code,
        ),
      403 => ForbiddenException(
          message: errorModel.message,
          code: errorModel.code,
        ),
      404 => NotFoundException(
          message: errorModel.message,
          code: errorModel.code,
        ),
      >= 500 => ServerException(
          message: errorModel.message,
          code: errorModel.code,
          statusCode: effectiveStatusCode,
        ),
      _ => NetworkException(
          message: errorModel.message,
          code: errorModel.code,
          statusCode: effectiveStatusCode,
        ),
    };
  }
}
