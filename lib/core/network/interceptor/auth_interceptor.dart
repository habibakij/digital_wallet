import 'dart:async';

import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Injects the stored Bearer token into every outgoing request header.
@lazySingleton
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorageService _storage;

  AuthInterceptor(this._dio, this._storage);
  Completer<String>? _refreshCompleter;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }
    if (_refreshCompleter != null) {
      try {
        final newToken = await _refreshCompleter!.future;
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        return handler.resolve(await _dio.fetch(err.requestOptions));
      } catch (_) {
        return handler.next(err);
      }
    }
    _refreshCompleter = Completer<String>();

    try {
      final refreshToken = _storage.getRefreshToken();
      final res = await _dio.post(ApiEndpoints.refreshToken, data: {'refresh_token': refreshToken});
      final newAccess = res.data['access_token'] as String;
      final newRefresh = res.data['refresh_token'] as String;

      await _storage.saveAccessToken(newAccess);
      await _storage.saveRefreshToken(newRefresh);
      _refreshCompleter!.complete(newAccess);
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
      return handler.resolve(await _dio.fetch(err.requestOptions));
    } catch (err2) {
      _refreshCompleter!.completeError(err2); // unblock queued with error
      await _storage.clearAll();
      //Get.offAllNamed('/login');
      handler.reject(err);
    } finally {
      _refreshCompleter = null;
    }
  }
}
