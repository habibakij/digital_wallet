import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:digital_wallet/core/exception_handler/exception_message.dart';
import 'package:digital_wallet/core/network/interceptor/connectivity_interceptor.dart';
import 'package:digital_wallet/core/network/interceptor/custom_baseurl_interceptor.dart';
import 'package:digital_wallet/core/network/interceptor/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'environment/api_environment.dart';
import 'interceptor/auth_interceptor.dart';
import 'interceptor/logger_interceptor.dart';
import 'interceptor/response_interceptor.dart';
import 'interceptor/token_refresh_interceptor.dart';

@lazySingleton
class ApiClient {
  late final Dio _dio;
  final Map<String, Future<Response>> _inDuplicateRequests = HashMap();

  ApiClient(
    ApiEnvironment environment,
    LoggerInterceptor loggerInterceptor,
    ConnectivityInterceptor connectivityInterceptor,
    AuthInterceptor authInterceptor,
    ResponseInterceptor responseInterceptor,
    TokenRefreshInterceptor tokenRefreshInterceptor,
    RetryInterceptor retryInterceptor,
    CustomBaseUrlInterceptor customBaseUrlInterceptor,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: environment.baseUrl,
        connectTimeout: environment.connectTimeout,
        receiveTimeout: environment.receiveTimeout,
        sendTimeout: environment.sendTimeout,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        // We handle status codes manually in ResponseInterceptor.
        validateStatus: (_) => true,
      ),
    );

    _dio.interceptors.addAll([
      loggerInterceptor, // 1. Log everything (debug only)
      connectivityInterceptor, // 2. Reject immediately if offline
      authInterceptor, // 3. Inject Bearer token
      responseInterceptor, // 4. Convert 4xx → DioException
      tokenRefreshInterceptor, // 5. Handle 401 + queue + refresh
      retryInterceptor, // 6. Exponential backoff for timeouts/5xx
      customBaseUrlInterceptor, // 7. Per-request baseUrl override
    ]);
  }

  /// GET with optional request deduplication. Deduplication prevents sending the same request multiple times
  /// Pass [deduplicate: false] to bypass (e.g. polling endpoints).

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters, CancelToken? cancelToken, bool deduplicate = true, String? customBaseUrl}) async {
    final extraOptions = Options(extra: customBaseUrl != null ? {'customBaseUrl': customBaseUrl} : null);
    final key = _requestKey('GET', endpoint, queryParameters);

    if (deduplicate && _inDuplicateRequests.containsKey(key)) {
      return _inDuplicateRequests[key]!;
    }
    final future = _dio
        .get(
          endpoint,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: extraOptions,
        )
        .catchError((e) => throw _mapException(e));

    if (deduplicate) {
      _inDuplicateRequests[key] = future;
      future.whenComplete(() => _inDuplicateRequests.remove(key));
    }
    return future;
  }

  /// POST request.
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  /// PUT request.
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  /// PATCH request.
  Future<Response> patch(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  /// DELETE request.
  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  // Connectivity stream
  Stream<bool> get internetStatusStream => Connectivity().onConnectivityChanged.map((result) => !result.contains(ConnectivityResult.none));

  // Internal helpers
  Dio getDio() => _dio;

  String _requestKey(String method, String endpoint, Map<String, dynamic>? params) {
    final sortedParams = params != null ? (params.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((e) => '${e.key}=${e.value}').join('&') : '';
    return '$method:$endpoint?$sortedParams';
  }

  // Exception
  static AppException _mapException(dynamic error) {
    if (error is AppException) return error;
    if (error is DioException) return _mapDioException(error);
    if (error is SocketException) {
      return const NetworkException(message: AppExceptionMessages.noInternet);
    }
    if (error is TimeoutException) {
      return const NetworkException(
        message: AppExceptionMessages.requestTimeout,
      );
    }
    return UnknownException(message: error.toString());
  }

  static AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return const NetworkException(message: AppExceptionMessages.noInternet);
      case DioExceptionType.connectionTimeout:
        return const NetworkException(
          message: AppExceptionMessages.connectionTimeout,
        );
      case DioExceptionType.sendTimeout:
        return const NetworkException(
          message: AppExceptionMessages.sendTimeout,
        );
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: AppExceptionMessages.receiveTimeout,
        );
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: AppExceptionMessages.badCertificate,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: error.message ?? AppExceptionMessages.internalServerError,
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.unknown:
        return UnknownException(
          message: error.message ?? AppExceptionMessages.unknown,
        );
    }
  }
}

/*class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;
  final Connectivity _connectivity = Connectivity();
  final Map<String, Future<Response>> _inDuplicateFRequests = HashMap();
  bool _isRefreshing = false;
  final List<PendingRequest> _pendingQueue = [];

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        validateStatus: (status) => true,
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    assert(() {
      _dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: false, responseBody: true, error: true, compact: false, maxWidth: 120),
      );
      return true;
    }());
    _dio.interceptors.add(InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
    _dio.interceptors.add(QueuedInterceptorsWrapper(onError: _onRetryError));

    _dio.interceptors.add(ConnectivityCheckInterceptor());
    _dio.interceptors.add(CustomBaseUrlInterceptor());
    _dio.interceptors.add(RetryInterceptor(_dio));
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
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

  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    final status = error.response?.statusCode;
    if (status == 401)) {
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _pendingQueue.add(PendingRequest(error.requestOptions, completer));
        return handler.resolve(await completer.future);
      }
      _isRefreshing = true;
      try {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          for (final pending in _pendingQueue) {
            try {
              pending.completer.complete(await _retry(pending.options));
            } catch (e) {
              pending.completer.completeError(e);
            }
          }
          _pendingQueue.clear();
          return handler.resolve(await _retry(error.requestOptions));
        } else {
          _pendingQueue.clear();
          await _forceLogout();
          return handler.next(_wrapException(error, AppExceptionMessages.sessionExpired));
        }
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(error);
  }

  Future<void> _onRetryError(DioException error, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(error)) {
      final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
      if (retryCount < 3) {
        error.requestOptions.extra['retryCount'] = retryCount + 1;
        final delay = Duration(seconds: 1 << retryCount);
        await Future.delayed(delay);
        try {
          return handler.resolve(await _retry(error.requestOptions));
        } catch (e) {
          e.toString();
        }
      }
    }
    return handler.next(error);
  }

  /// GET request with optional deduplication.
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters, CancelToken? cancelToken, bool deduplicate = true, String? customBaseUrl}) async {
    if (customBaseUrl != null) {
      final tempDio = Dio(
        BaseOptions(
          baseUrl: customBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      tempDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {

              final token = await sl<SecureStorageService>().getAccessToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }

            handler.next(options);
          },
        ),
      );
      return await tempDio.get(endpoint, queryParameters: queryParameters, cancelToken: cancelToken);
    }
    final key = _requestKey('GET', endpoint, queryParameters);
    if (deduplicate && _inDuplicateFRequests.containsKey(key)) {
      return _inDuplicateFRequests[key]!;
    }
    final future = _dio.get(endpoint, queryParameters: queryParameters, cancelToken: cancelToken).catchError((e) => throw _mapException(e));
    if (deduplicate) {
      _inDuplicateFRequests[key] = future;
      future.whenComplete(() => _inDuplicateFRequests.remove(key));
    }
    return future;
  }

  /// POST request.
  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, Options? options}) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }


  Stream<bool> get internetStatusStream => _connectivity.onConnectivityChanged.map((result) => !result.contains(ConnectivityResult.none));

  Future<Response> _retry(RequestOptions requestOptions) {
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        extra: requestOptions.extra,
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    final status = error.response?.statusCode ?? 0;
    return error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.sendTimeout || (status >= 500 && status != 501); // Don't retry "Not Implemented"
  }

  String _requestKey(String method, String endpoint, Map<String, dynamic>? params) {
    final sortedParams = params != null ? (params.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((e) => '${e.key}=${e.value}').join('&') : '';
    return '$method:$endpoint?$sortedParams';
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

  DioException _wrapException(DioException original, String message) {
    return DioException(
      requestOptions: original.requestOptions,
      response: original.response,
      type: original.type,
      message: message,
    );
  }

  Future<bool> _refreshAccessToken() async {
    try {
      final storage = sl<SecureStorageService>();
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      // Use a fresh Dio instance to avoid interceptor recursion
      final authDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
      final response = await authDio.post(ApiEndpoints.refreshToken, data: {'refreshToken': refreshToken});

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['accessToken'] as String?;
        final newRefresh = response.data['refreshToken'] as String? ?? refreshToken;
        if (newAccessToken == null) return false;
        await storage.saveAccessToken(newAccessToken);
        await storage.saveRefreshToken(newRefresh);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _forceLogout() async {
    await sl<SecureStorageService>().clearAll();
    //sl<AuthEventBus>().emit(LogoutRequested);
  }

  /// Maps any raw exception into a typed [AppException].
  static AppException _mapException(dynamic error) {
    if (error is AppException) return error; // already mapped

    if (error is DioException) {
      return _mapDioException(error);
    }

    if (error is SocketException) {
      return const NetworkException(message: AppExceptionMessages.noInternet);
    }

    if (error is TimeoutException) {
      return const NetworkException(message: AppExceptionMessages.requestTimeout);
    }

    return UnknownException(message: error.toString());
  }

  static AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        return const NetworkException(message: AppExceptionMessages.noInternet);

      case DioExceptionType.connectionTimeout:
        return const NetworkException(message: AppExceptionMessages.connectionTimeout);

      case DioExceptionType.sendTimeout:
        return const NetworkException(message: AppExceptionMessages.sendTimeout);

      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: AppExceptionMessages.receiveTimeout);

      case DioExceptionType.cancel:
        return const RequestCancelledException();

      case DioExceptionType.badCertificate:
        return const NetworkException(message: AppExceptionMessages.badCertificate);

      case DioExceptionType.unknown:
        return UnknownException(message: error.message ?? AppExceptionMessages.unknown);
    }
  }

  Dio getDio() => _dio;
}*/
