import 'package:digital_wallet/features/transaction_details/data/model/tr_details_model.dart';
import 'package:injectable/injectable.dart';

abstract class TrDetailsRemoteDataSource {
  Future<TrDetailsModel> getTransactionDetailsData();
}

@LazySingleton(as: TrDetailsRemoteDataSource)
class TrDetailsRemoteDataSourceImpl implements TrDetailsRemoteDataSource {
  @override
  Future<TrDetailsModel> getTransactionDetailsData() async {
    await Future.delayed(const Duration(seconds: 2));
    var data = {
      "id": "123456789",
      "amount": "\$450.00",
      "fee": "\$40.00",
      "fromAccount": "456789123",
      "toAccount": "123456789",
      "date": "2024-06-01",
      "status": "Completed",
      "note": "ABC Store payment",
      "isCredit": false,
    };
    return TrDetailsModel.fromJson(data);
  }
}
