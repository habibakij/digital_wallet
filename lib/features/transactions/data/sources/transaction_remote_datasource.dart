import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/features/transactions/data/model/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactionListData();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient _apiClient;
  TransactionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TransactionModel>> getTransactionListData() async {
    final response = await _apiClient.get(ApiEndpoints.transactionList, customBaseUrl: ApiEndpoints.baseUrlV2);
    final List data = response.data;
    final result = data.map((json) => TransactionModel.fromJson(json)).toList();
    return result;
  }
}
