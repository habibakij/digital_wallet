import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/core/utils/widget/snack_bar.dart';
import 'package:digital_wallet/injection/injection.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio _dio;
  String? _accessToken;
  String? _refreshToken;
  final Connectivity _connectivity = Connectivity();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    _setupInterceptors();
  }

  /// setup interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: false,
        maxWidth: 90,
      ),
    );

    /// token refresh interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!await hasInternetConnection()) {
            AppSnackBar.error("No internet connection, Please connect your internet and try again");
            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                message: 'No internet connection',
              ),
            );
          }
          _accessToken = await sl<SecureStorageService>().getAccessToken();
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            if (await _refreshAccessToken()) {
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );

    /// Retry Interceptor with exponential backoff
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException error, handler) async {
          if (_shouldRetry(error)) {
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount < 3) {
              error.requestOptions.extra['retryCount'] = retryCount + 1;
              await Future.delayed(const Duration(seconds: 2));
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Retry failed request
  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(method: requestOptions.method, headers: requestOptions.headers);
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Should retry logic
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.sendTimeout || (error.response?.statusCode ?? 0) >= 500;
  }

  /// Check Internet Connection
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }
      // Additional check: try to reach a reliable endpoint
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// listen to internet connection changes
  Stream<bool> onInternetStatusChanged() {
    return _connectivity.onConnectivityChanged.map((result) {
      return !result.contains(ConnectivityResult.none);
    });
  }

  /// refresh token
  Future<bool> _refreshAccessToken() async {
    try {
      _refreshToken ??= await sl<SecureStorageService>().getRefreshToken();
      if (_refreshToken == null) return false;
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': _refreshToken},
        options: Options(
          headers: {'Authorization': null},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _accessToken = response.data['accessToken'];
        _refreshToken = response.data['refreshToken'] ?? _refreshToken;
        await sl<SecureStorageService>().saveAccessToken(_accessToken ?? '');
        await sl<SecureStorageService>().saveRefreshToken(_refreshToken ?? '');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Set Auth Tokens
  void setAuthTokens(String accessToken, {String? refreshToken}) {
    _accessToken = accessToken;
    if (refreshToken != null) _refreshToken = refreshToken;
  }

  /// Clear Auth Tokens
  void clearAuthTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  /// GET - JSON Response
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    String? customBaseUrl,
  }) async {
    try {
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
        if (_accessToken != null) {
          tempDio.options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        return await tempDio.get(endpoint, queryParameters: queryParameters, cancelToken: cancelToken);
      }
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// GET - Stream Response
  Future<Response> getStream(String endpoint, {Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(responseType: ResponseType.stream),
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// POST - JSON
  Future<Response> post(String endpoint, {Map<String, dynamic>? pData, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.post(
        endpoint,
        data: jsonEncode(pData),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// POST - Form Data (for files & images)
  Future<Response> postFormData(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, File> files,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      FormData formData = FormData.fromMap(fields);
      for (var entry in files.entries) {
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              entry.value.path,
              filename: entry.value.path.split('/').last,
            ),
          ),
        );
      }
      return await _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// PUT
  Future<Response> put(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// PATCH
  Future<Response> patch(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// DELETE
  Future<Response> delete(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken}) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// Download File
  Future<void> downloadFile(
    String endpoint, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _errorHandler(e);
    }
  }

  /// Error Handling
  static Exception _errorHandler(dynamic error) {
    String message = 'Unknown exception_handler occurred';
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          final errorMsg = error.response?.data['message'] ?? 'Request failed';
          message = 'Error $statusCode: $errorMsg';
          break;
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout. Please check your internet.';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Server took too long to respond.';
          break;
        case DioExceptionType.sendTimeout:
          message = 'Request timeout. Please try again.';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled.';
          break;
        case DioExceptionType.unknown:
          message = error.message ?? 'Something went wrong!';
          break;
        default:
          message = 'An unexpected error occurred.';
      }
    } else if (error is SocketException) {
      message = 'No internet connection.';
    }
    return Exception(message);
  }

  // Get Dio instance (if needed for custom operations)
  Dio getDio() => _dio;
}
