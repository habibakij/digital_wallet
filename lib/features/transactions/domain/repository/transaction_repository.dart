import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactionListData();
}
