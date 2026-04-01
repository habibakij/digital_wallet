import 'package:digital_wallet/features/transaction_details/data/sources/tr_details_remote_source.dart';
import 'package:digital_wallet/features/transaction_details/domain/entiry/tr_details_entity.dart';
import 'package:digital_wallet/features/transaction_details/domain/repository/tr_details_repository.dart';

class TrDetailsRepositoryImpl implements TrDetailsRepository {
  final TrDetailsRemoteDataSource _remoteDataSource;
  TrDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<TrDetailsEntity> getTransactionDetailsData() {
    return _remoteDataSource.getTransactionDetailsData();
  }
}
