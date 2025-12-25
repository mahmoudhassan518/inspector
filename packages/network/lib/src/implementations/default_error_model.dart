import 'package:inspector_network/src/interfaces/error_model.dart';


/// Default error model implementation
class DefaultErrorModel implements ErrorModel {
  @override
  final String? message;

  @override
  final String? code;

  @override
  final int? statusCode;

  const DefaultErrorModel({
    this.message,
    this.code,
    this.statusCode,
  });

  factory DefaultErrorModel.fromJson(Map<String, dynamic> json) {
    return DefaultErrorModel(
      message: json['message'] as String? ?? 
               json['error'] as String? ?? 
               'Unknown error',
      code: json['code'] as String? ?? json['error_code'] as String?,
      statusCode: json['status_code'] as int? ?? json['statusCode'] as int?,
    );
  }
}
