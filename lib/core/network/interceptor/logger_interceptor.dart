import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Wraps [PrettyDioLogger] so it only runs in debug builds.
///
/// The [assert] block is stripped entirely in release/profile mode by the Dart
/// compiler, so no logging overhead reaches production.
@lazySingleton
class LoggerInterceptor extends Interceptor {
  late final PrettyDioLogger? _logger;

  LoggerInterceptor() {
    PrettyDioLogger? instance;
    assert(() {
      instance = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: false,
        maxWidth: 120,
      );
      return true;
    }());
    _logger = instance;
  }
}
