abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  Failure({required this.message, this.stackTrace});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.stackTrace});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.stackTrace});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.stackTrace});
}
