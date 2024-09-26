sealed class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

class ServerException extends AppException {
  ServerException({required super.message, super.stackTrace});
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.stackTrace});
}

class CacheException extends AppException {
  CacheException({required super.message, super.stackTrace});
}

class EmailAlreadyInUseException extends AppException {
  EmailAlreadyInUseException({super.message = 'Email already in use'});
}

class WrongPasswordException extends AppException {
  WrongPasswordException({super.message = 'Wrong password'});
}

class UserNotFoundException extends AppException {
  UserNotFoundException({super.message = 'User not found'});
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException(
      {super.message = 'Too many requests, try again later'});
}

class UnknownException extends AppException {
  UnknownException({super.message = 'An unknown error occurred'});
}
