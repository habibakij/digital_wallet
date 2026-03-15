import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';

class TransactionUseCase {
  final TransactionRepository _repository;
  TransactionUseCase(this._repository);

  Future<List<TransactionEntity>> getTransactionList() {
    return _repository.getTransactionListData();
  }
}
