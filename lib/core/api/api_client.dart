import 'dart:io';

import 'package:digital_wallet/core/constants/api_endpoints.dart';
import 'package:digital_wallet/core/constants/app_constants.dart';
import 'package:digital_wallet/core/error/failures.dart';
import 'package:digital_wallet/core/utils/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    _dio = Dio(_buildBaseOptions());
    _setupInterceptors();
  }

  BaseOptions _buildBaseOptions() {
    return BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: AppConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Platform': Platform.isAndroid ? 'android' : 'ios',
        'X-App-Version': '1.0.0',
      },
      validateStatus: (status) => status != null && status < 500,
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _AuthInterceptor(_tokenStorage, _dio),
      _RetryInterceptor(_dio),
      _ErrorInterceptor(),
      // Only in debug
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return await _dio.put<T>(path, data: data, options: options);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return await _dio.patch<T>(path, data: data, options: options);
  }
}

// ─── Auth Interceptor ────────────────────────────────────────────────────────
class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  _AuthInterceptor(this._tokenStorage, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login/refresh endpoints
    if (options.path == ApiEndpoints.login || options.path == ApiEndpoints.refreshToken) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && err.requestOptions.path != ApiEndpoints.refreshToken) {
      if (_isRefreshing) {
        _pendingRequests.add(err.requestOptions);
        return;
      }

      _isRefreshing = true;
      try {
        final refreshToken = await _tokenStorage.getRefreshToken();
        if (refreshToken == null) throw const UnauthorizedFailure();

        final response = await _dio.post(ApiEndpoints.refreshToken, data: {
          'refresh_token': refreshToken,
        });

        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await _tokenStorage.saveAccessToken(newAccessToken);
        await _tokenStorage.saveRefreshToken(newRefreshToken);

        // Retry all pending requests
        for (final req in _pendingRequests) {
          req.headers['Authorization'] = 'Bearer $newAccessToken';
          await _dio.fetch(req);
        }
        _pendingRequests.clear();

        // Retry original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retried = await _dio.fetch(err.requestOptions);
        return handler.resolve(retried);
      } catch (_) {
        await _tokenStorage.clearAll();
        handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
      return;
    }
    handler.next(err);
  }
}

// ─── Retry Interceptor ───────────────────────────────────────────────────────
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  static const int _maxRetries = AppConstants.maxRetryAttempts;

  _RetryInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    final isNetworkError = err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.connectionError;

    if (isNetworkError && retryCount < _maxRetries) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        final response = await _dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}

// ─── Error Interceptor ───────────────────────────────────────────────────────
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DioException mappedError;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        mappedError = err.copyWith(
          message: 'Connection timed out. Please try again.',
        );
        break;
      case DioExceptionType.connectionError:
        mappedError = err.copyWith(
          message: 'No internet connection.',
        );
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data?['message'] ?? err.response?.data?['error'] ?? 'Something went wrong';
        mappedError = err.copyWith(message: message.toString());
        break;
      default:
        mappedError = err;
    }

    handler.next(mappedError);
  }
}
