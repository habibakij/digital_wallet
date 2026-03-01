import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/failures.dart';
import '../model/transfer_model.dart';

abstract class SendMoneyRemoteDataSource {
  Future<TransferModel> sendMoney({
    required String receiverAccount,
    required double amount,
    String? note,
  });
}

class SendMoneyRemoteDataSourceImpl implements SendMoneyRemoteDataSource {
  final ApiClient _apiClient;

  SendMoneyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<TransferModel> sendMoney({
    required String receiverAccount,
    required double amount,
    String? note,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendMoney,
        data: {
          'receiver_account': receiverAccount,
          'amount': amount,
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransferModel.fromJson(response.data as Map<String, dynamic>);
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
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
