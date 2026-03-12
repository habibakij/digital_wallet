import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/features/transactions/data/model/transaction_model.dart';
import 'package:dio/dio.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getData();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient _apiClient;
  TransactionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TransactionModel>> getData() async {
    try {
      final response = await _apiClient.get("https://jsonplaceholder.typicode.com/todos");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList.map((x) => TransactionModel.fromJson(x)).toList();
      } else if (response.statusCode == 422) {
        throw ValidationFailure(
          message: (response.data as Map?)?['message']?.toString() ?? 'Validation failed',
        );
      } else if (response.statusCode == 402) {
        throw const InsufficientBalanceFailure();
      } else {
        throw ServerException(
          message: (response.data as Map?)?['message']?.toString() ?? 'Transfer failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Network exception_handler',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
