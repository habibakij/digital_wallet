import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';

abstract class SendMoneyRepository {
  Future<Either<Failure, SendMoneyEntity>> sendMoney({required String receiverAccount, required double amount, String? note});
}
