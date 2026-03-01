import 'package:digital_wallet/core/error_handler/server_exception.dart';
import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

abstract class TransactionRemoteDataSource {
  Future<Map<String, dynamic>> getTransactions({
    required int page,
    required int pageSize,
  });
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient _apiClient;

  TransactionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getTransactions({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.transactions,
        queryParameters: {
          'page': page,
          'per_page': pageSize,
          'sort': 'created_at',
          'order': 'desc',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ServerException(
        message: 'Failed to fetch transactions',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network error_handler',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
