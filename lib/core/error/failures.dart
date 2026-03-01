// lib/core/error/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection', super.statusCode});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Session expired. Please login again.', super.statusCode = 401});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class TransactionFailure extends Failure {
  const TransactionFailure({required super.message, super.statusCode});
}

class InsufficientBalanceFailure extends Failure {
  const InsufficientBalanceFailure({super.message = 'Insufficient balance'});
}

// lib/core/error/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({required this.message, this.statusCode});
}

class NetworkException implements Exception {
  const NetworkException();
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});
}
