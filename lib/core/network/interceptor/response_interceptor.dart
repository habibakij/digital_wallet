import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Converts any response with status >= 400 into a [DioException].
/// This lets [onError] handlers handle all error cases uniformly,
/// because Dio only calls onError for network-level failures by default.

@lazySingleton
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode ?? 0;
    if (status >= 400) {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: _extractServerMessage(response),
        ),
        true,
      );
    }
    return handler.next(response);
  }

  String _extractServerMessage(Response response) {
    try {
      final data = response.data;
      if (data is Map) {
        return (data['message'] ?? data['error'] ?? '').toString();
      }
    } catch (_) {}
    return '';
  }
}
