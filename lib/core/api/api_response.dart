// lib/core/api/api_response.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../error/failures.dart';

class ApiResponse {
  static Either<Failure, T> handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return Right(fromJson(data));
      } else if (response.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      } else if (response.statusCode == 422) {
        final message = _extractMessage(response.data);
        return Left(ValidationFailure(message: message));
      } else {
        final message = _extractMessage(response.data);
        return Left(ServerFailure(
          message: message,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to parse response: $e'));
    }
  }

  static Either<Failure, T> handleDioError<T>(DioException e) {
    if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.connectionTimeout) {
      return Left(NetworkFailure(message: e.message ?? 'No internet connection'));
    }
    if (e.response?.statusCode == 401) {
      return const Left(UnauthorizedFailure());
    }
    final message = e.message ?? 'Something went wrong';
    return Left(ServerFailure(
      message: message,
      statusCode: e.response?.statusCode,
    ));
  }

  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString() ?? 'An error occurred';
    }
    return 'An error occurred';
  }
}
