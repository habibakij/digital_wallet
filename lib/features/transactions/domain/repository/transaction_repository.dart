import 'package:digital_wallet/features/transactions/data/model/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getData();
}
