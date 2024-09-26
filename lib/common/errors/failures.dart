abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  Failure({required this.message, this.stackTrace});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.stackTrace});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.stackTrace});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.stackTrace});
}

class EmailAlreadyInUseFailure extends Failure {
  EmailAlreadyInUseFailure({super.message = 'Email already in use'});
}

class WrongPasswordFailure extends Failure {
  WrongPasswordFailure({super.message = 'Wrong password'});
}

class UserNotFoundFailure extends Failure {
  UserNotFoundFailure({super.message = 'User not found'});
}

class TooManyRequestsFailure extends Failure {
  TooManyRequestsFailure({super.message = 'Too many requests'});
}

class UnknownFailure extends Failure {
  UnknownFailure({super.message = 'An unknown error occurred'});
}
