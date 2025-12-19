/// Abstract error model interface
abstract class ErrorModel {
  String? get message;
  String? get code;
  int? get statusCode;
}
