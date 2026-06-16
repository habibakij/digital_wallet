import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/features/send_money/data/model/send_money_model.dart';
import 'package:injectable/injectable.dart';

abstract class SendMoneyRemoteDataSource {
  Future<SendMoneyModel> sendMoney({required String receiverAccount, required double amount, String? note});
}

@LazySingleton(as: SendMoneyRemoteDataSource)
class SendMoneyRemoteDataSourceImpl implements SendMoneyRemoteDataSource {
  final ApiClient _apiClient;
  SendMoneyRemoteDataSourceImpl(this._apiClient);

  @override
  Future<SendMoneyModel> sendMoney({required String receiverAccount, required double amount, String? note}) async {
    /*return await _apiClient.post(
      ApiEndpoints.sendMoney,
      queryParameters: {"title": receiverAccount, "body": note, "userId": amount.toInt()},
    ).then((response) {
      final data = response.data;
      return TransferModel.fromJson(data);
    }).catchError((error) {
      throw Exception(error.toString());
    });*/
    return Future.delayed(const Duration(seconds: 2), () {
      var data = {
        "otp": "001122",
        "transaction_id": "1234567890",
        "reference_number": "REF123456",
        "receiver_name": "Abdullah Al Mamun",
        "receiver_account": receiverAccount,
        "amount": amount,
        "new_balance": 1000.0 - amount,
        "note": note,
        "timestamp": DateTime.now().toIso8601String(),
      };
      return SendMoneyModel.fromJson(data);
    });
  }
}
