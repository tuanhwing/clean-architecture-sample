
abstract class THException implements Exception {
  THException({this.code, this.message});
  final String? code;
  final String? message;
}

class THServerException extends THException {
  THServerException({String? code, String? message}) : super(code: code, message: message);
}

class THInternalException extends THException {
  THInternalException({String? code, String? message}) : super(code: code, message: message);
}