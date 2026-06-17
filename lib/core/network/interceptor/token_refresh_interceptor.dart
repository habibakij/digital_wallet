import 'dart:async';

import 'package:digital_wallet/core/exception_handler/exception_message.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/core/network/environment/api_environment.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

class _PendingRequest {
  final RequestOptions options;
  final Completer<Response> completer;

  _PendingRequest(this.options, this.completer);
}

/// Handles 401 Unauthorized responses by:
/// 1. Attempting a silent token refresh.
/// 2. Retrying all queued requests with the new token if refresh succeeds.
/// 3. Forcing a logout and clearing storage if refresh fails.
///
/// Uses a flag [_isRefreshing] to ensure only one refresh happens at a time.
/// Subsequent 401s while refreshing are queued and resolved together.

@lazySingleton
class TokenRefreshInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final ApiEnvironment _environment;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingQueue = [];

  TokenRefreshInterceptor(this._storage, this._environment);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    if (status != 401) {
      return handler.next(err);
    }

    // Another refresh is already in progress — queue this request.
    if (_isRefreshing) {
      final completer = Completer<Response>();
      _pendingQueue.add(_PendingRequest(err.requestOptions, completer));
      try {
        return handler.resolve(await completer.future);
      } catch (e) {
        return handler.next(err);
      }
    }
    _isRefreshing = true;

    try {
      final refreshed = await _refreshAccessToken();
      if (refreshed) {
        // Resolve all queued requests with the new token.
        for (final pending in _pendingQueue) {
          try {
            pending.completer.complete(await _retry(pending.options));
          } catch (e) {
            pending.completer.completeError(e);
          }
        }
        _pendingQueue.clear();
        return handler.resolve(await _retry(err.requestOptions));
      } else {
        _pendingQueue.clear();
        await _forceLogout();
        return handler.next(_wrapException(err, AppExceptionMessages.sessionExpired));
      }
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      // Use a fresh Dio to avoid triggering this interceptor recursively.
      final authDio = Dio(BaseOptions(baseUrl: _environment.baseUrl));
      final response = await authDio.post(ApiEndpoints.refreshToken, data: {'refreshToken': refreshToken});

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['accessToken'] as String?;
        final newRefresh = response.data['refreshToken'] as String? ?? refreshToken;

        if (newAccessToken == null) return false;
        await _storage.saveAccessToken(newAccessToken);
        await _storage.saveRefreshToken(newRefresh);
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await _storage.getAccessToken();
    final retryDio = Dio(BaseOptions(baseUrl: _environment.baseUrl));
    return retryDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        extra: requestOptions.extra,
      ),
    );
  }

  Future<void> _forceLogout() async {
    await _storage.clearAll();
    // Emit logout event if you have an AuthEventBus:
    // sl<AuthEventBus>().emit(LogoutRequested());
  }

  DioException _wrapException(DioException original, String message) {
    return DioException(requestOptions: original.requestOptions, response: original.response, type: original.type, message: message);
  }
}
