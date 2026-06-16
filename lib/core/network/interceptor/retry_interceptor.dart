import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

const int _maxRetries = 3;

/// Retries failed requests with exponential backoff for:
/// - Connection / send / receive timeouts
/// - Server errors (5xx), except 501 Not Implemented
///
/// Retry delays: 1s → 2s → 4s (2^retryCount seconds).
/// Tracks retry count in [RequestOptions.extra] to survive interceptor hops.

@lazySingleton
class RetryInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;
  RetryInterceptor(this._dio);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }
    final retryCount = (err.requestOptions.extra['retryCount'] ?? 0) as int;
    if (retryCount >= _maxRetries) {
      return handler.next(err);
    }
    err.requestOptions.extra['retryCount'] = retryCount + 1;
    final delay = Duration(seconds: 1 << retryCount); // 1s, 2s, 4s
    await Future.delayed(delay);

    try {
      return handler.resolve(await _retry(err.requestOptions));
    } catch (e) {
      // If retry itself throws, fall through to next handler.
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException error) {
    final status = error.response?.statusCode ?? 0;
    return error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.sendTimeout || (status >= 500 && status != 501);
  }

  Future<Response> _retry(RequestOptions requestOptions) {
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(method: requestOptions.method, headers: requestOptions.headers, extra: requestOptions.extra),
    );
  }
}
