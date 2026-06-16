import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';
import 'package:digital_wallet/features/send_money/domain/repository/send_money_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SendMoneyUseCase extends UseCase<SendMoneyEntity, SendMoneyParams> {
  final SendMoneyRepository _repository;
  SendMoneyUseCase(this._repository);

  @override
  Future<Either<Failure, SendMoneyEntity>> call(SendMoneyParams params) async {
    if (params.receiverAccount.isEmpty) {
      return const Left(ValidationFailure(message: 'Receiver account is required'));
    }
    if (params.amount <= 0) {
      return const Left(ValidationFailure(message: 'Amount must be greater than 0'));
    }
    if (params.amount > 50000) {
      return const Left(ValidationFailure(message: 'Amount cannot exceed ৳ 50,000'));
    }
    if (params.amount > params.currentBalance) {
      return const Left(InsufficientBalanceFailure());
    }
    return await _repository.sendMoney(receiverAccount: params.receiverAccount, amount: params.amount, note: params.note);
  }
}

class SendMoneyParams extends Equatable {
  final String receiverAccount;
  final double amount;
  final double currentBalance;
  final String? note;

  const SendMoneyParams({required this.receiverAccount, required this.amount, required this.currentBalance, this.note});

  @override
  List<Object?> get props => [receiverAccount, amount, currentBalance, note];
}
