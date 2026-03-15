class ServerException implements Exception {
  final String message;
  final int? code;

  const ServerException(this.message, {this.code});
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);
}
