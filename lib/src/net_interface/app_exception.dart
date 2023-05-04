class AppException implements Exception {
  final dynamic _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
  Map toMap() {
    return _message;
  }
}

class FetchDataException extends AppException {
  FetchDataException(Map message)
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class ConflictDataException extends AppException {
  ConflictDataException(String message)
      : super(message, "");
}

class UnauthorisedException extends AppException {
  UnauthorisedException(Map message) : super(message, "");
}

class InvalidInputException extends AppException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}