import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class CustomBaseUrlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final customBase = options.extra['customBaseUrl'] as String?;
    if (customBase != null && customBase.isNotEmpty) {
      options.baseUrl = customBase;
    }
    handler.next(options);
  }
}
