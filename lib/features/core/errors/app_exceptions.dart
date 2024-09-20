class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.stackTrace});
}

class ServerException extends AppException {
  ServerException({required super.message, super.stackTrace});
}

class CacheException extends AppException {
  CacheException({required super.message, super.stackTrace});
}
