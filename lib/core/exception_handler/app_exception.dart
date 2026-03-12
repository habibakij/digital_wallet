/// Base class for all application exceptions.
sealed class AppException implements Exception {
  final String message;
  const AppException({required this.message});

  @override
  String toString() => message;
}

/// Thrown when a network-level error occurs (connectivity, timeout, TLS).
class NetworkException extends AppException {
  const NetworkException({required super.message});
}

/// Thrown when a server responds with a non-2xx status (except auth/validation).
class ServerException extends AppException {
  final int? statusCode;
  const ServerException({required super.message, this.statusCode});
}

/// Thrown on 401 / 403 / session-expired situations.
class AuthException extends AppException {
  final int? statusCode;
  const AuthException({required super.message, this.statusCode});
}

/// Thrown on 422 Unprocessable Entity with field-level validation details.
class ValidationException extends AppException {
  final int? statusCode;
  final Map<String, List<String>>? errors;
  const ValidationException({required super.message, this.statusCode, this.errors});
}

/// Thrown when the request was explicitly cancelled.
class RequestCancelledException extends AppException {
  const RequestCancelledException() : super(message: 'Request was cancelled.');
}

/// Thrown when JSON parsing / mapping fails.
class DataParsingException extends AppException {
  final Object? cause;
  const DataParsingException({super.message = 'Failed to parse server response.', this.cause});
}

/// Fallback for everything else.
class UnknownException extends AppException {
  const UnknownException({super.message = 'An unexpected error occurred.'});
}
