import 'package:digital_wallet/features/transactions/data/sources/transaction_remote_datasource.dart';
import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TransactionEntity>> getTransactionListData() {
    return _remoteDataSource.getTransactionListData();
  }
}
