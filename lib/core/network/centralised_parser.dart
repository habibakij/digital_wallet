import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:dio/dio.dart';

Future<T> parseResponse<T>(
  Response response, {
  required T Function(Map<String, dynamic> json) parser,
  Future<void> Function(T result)? onSuccess,
}) async {
  try {
    final data = response.data;
    if (data == null) {
      throw const DataParsingException(message: 'Server returned an empty response.');
    }
    if (data is! Map<String, dynamic>) {
      throw DataParsingException(
        message: 'Unexpected response format (got ${data.runtimeType}, expected Map).',
      );
    }
    final result = parser(data);
    await onSuccess?.call(result);
    return result;
  } on DataParsingException {
    rethrow;
  } on AppException {
    rethrow;
  } on FormatException catch (e) {
    throw DataParsingException(
      message: 'Response parsing failed: invalid format.',
      cause: e,
    );
  } on TypeError catch (e) {
    throw DataParsingException(
      message: 'Response parsing failed: unexpected field type.',
      cause: e,
    );
  } catch (e) {
    throw DataParsingException(
      message: 'Response parsing failed: ${e.toString()}',
      cause: e,
    );
  }
}
