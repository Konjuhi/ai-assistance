class ServerExceptionn implements Exception {
  final String message;
  ServerExceptionn({this.message = 'Server Exception'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Exception'});
}

// Add other custom exceptions as needed
