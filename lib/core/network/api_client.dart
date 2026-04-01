import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:digital_wallet/core/exception_handler/exception_message.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/core/utils/helper/pending_request.dart';
import 'package:digital_wallet/core/utils/widget/snack_bar.dart';
import 'package:digital_wallet/injection/injection.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
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
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => true,
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // 1. Logger (only in debug mode)
    assert(() {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: false,
          maxWidth: 120,
        ),
      );
      return true;
    }());
    // 2. Auth + connectivity + token-refresh interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onResponse: _onResponse, onError: _onError),
    );
    // 3. Retry with exponential back-off (network/server errors only)
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(onError: _onRetryError),
    );
  }

  Future<void> _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // (a) Connectivity gate
    if (!await hasInternetConnection()) {
      AppSnackBar.error("No internet connection, Please connect your internet and try again");
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: AppExceptionMessages.noInternet,
        ),
        true,
      );
    }
    // (b) Attach bearer token (skip for auth endpoints)
    if (!_isAuthEndpoint(options.path)) {
      final token = await sl<SecureStorageService>().getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    return handler.next(options);
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
    if (status == 401 && !_isAuthEndpoint(error.requestOptions.path)) {
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
          // Let it fall through to handler.next
        }
      }
    }
    return handler.next(error);
  }

  /// GET request with optional deduplication.
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deduplicate = true,
    String? customBaseUrl,
  }) async {
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
            if (!_isAuthEndpoint(options.path)) {
              final token = await sl<SecureStorageService>().getAccessToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
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
        data: jsonEncode(data),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  /// PUT request.
  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  /// DELETE request.
  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  /// PATCH request.
  Future<Response> patch(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _mapException(e);
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.none)) return false;
      final addresses = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
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

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') || path.contains('/auth/refresh') || path.contains('/auth/register');
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

      case DioExceptionType.badResponse:
        return _mapHttpStatus(error);

      case DioExceptionType.badCertificate:
        return const NetworkException(message: AppExceptionMessages.badCertificate);

      case DioExceptionType.unknown:
        return UnknownException(message: error.message ?? AppExceptionMessages.unknown);
    }
  }

  static AppException _mapHttpStatus(DioException error) {
    final status = error.response?.statusCode ?? 0;
    // Prefer the server's own message, fall back to a generic one
    final serverMsg = error.message;

    switch (status) {
      case 400:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.badRequest,
          statusCode: status,
        );
      case 401:
        return AuthException(
          message: serverMsg ?? AppExceptionMessages.unauthorized,
          statusCode: status,
        );
      case 403:
        return AuthException(
          message: serverMsg ?? AppExceptionMessages.forbidden,
          statusCode: status,
        );
      case 404:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.notFound,
          statusCode: status,
        );
      case 405:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.methodNotAllowed,
          statusCode: status,
        );
      case 408:
        return const NetworkException(message: AppExceptionMessages.requestTimeout);
      case 409:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.conflict,
          statusCode: status,
        );
      case 410:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.gone,
          statusCode: status,
        );
      case 413:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.payloadTooLarge,
          statusCode: status,
        );
      case 415:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.unsupportedMediaType,
          statusCode: status,
        );
      case 422:
        return ValidationException(
          message: serverMsg ?? AppExceptionMessages.unprocessableEntity,
          statusCode: status,
          errors: _extractValidationErrors(error.response),
        );
      case 429:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.tooManyRequests,
          statusCode: status,
        );
      case 500:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.internalServerError,
          statusCode: status,
        );
      case 502:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.badGateway,
          statusCode: status,
        );
      case 503:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.serviceUnavailable,
          statusCode: status,
        );
      case 504:
        return ServerException(
          message: serverMsg ?? AppExceptionMessages.gatewayTimeout,
          statusCode: status,
        );
      default:
        return ServerException(
          message: serverMsg ?? 'Unexpected error (HTTP $status)',
          statusCode: status,
        );
    }
  }

  static Map<String, List<String>>? _extractValidationErrors(Response? response) {
    try {
      final data = response?.data;
      if (data is Map && data['errors'] is Map) {
        return (data['errors'] as Map).map(
          (k, v) => MapEntry(
            k.toString(),
            v is List ? v.map((e) => e.toString()).toList() : [v.toString()],
          ),
        );
      }
    } catch (_) {}
    return null;
  }

  Dio getDio() => _dio;
}
