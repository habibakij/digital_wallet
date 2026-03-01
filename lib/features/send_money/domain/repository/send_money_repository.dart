import 'package:dartz/dartz.dart';

import '../../../../core/error_handler/failures.dart';
import '../entities/transfer_entity.dart';

abstract class SendMoneyRepository {
  Future<Either<Failure, TransferEntity>> sendMoney({
    required String receiverAccount,
    required double amount,
    String? note,
  });
}
