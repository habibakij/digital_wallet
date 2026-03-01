import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';

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
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
