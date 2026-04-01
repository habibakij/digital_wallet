import 'package:digital_wallet/features/transaction_details/domain/entiry/tr_details_entity.dart';

abstract class TrDetailsRepository {
  Future<TrDetailsEntity> getTransactionDetailsData();
}
