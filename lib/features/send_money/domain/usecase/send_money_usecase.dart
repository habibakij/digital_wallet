import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error_handler/failures.dart';
import '../../../../core/use_case/usecase.dart';
import '../entities/transfer_entity.dart';
import '../repository/send_money_repository.dart';

class SendMoneyUseCase extends UseCase<TransferEntity, SendMoneyParams> {
  final SendMoneyRepository _repository;

  SendMoneyUseCase(this._repository);

  @override
  Future<Either<Failure, TransferEntity>> call(SendMoneyParams params) async {
    // Domain-level validations
    if (params.receiverAccount.isEmpty) {
      return const Left(
          ValidationFailure(message: 'Receiver account is required'));
    }
    if (params.amount <= 0) {
      return const Left(
          ValidationFailure(message: 'Amount must be greater than 0'));
    }
    if (params.amount > 50000) {
      return const Left(
          ValidationFailure(message: 'Amount cannot exceed ৳ 50,000'));
    }
    if (params.amount > params.currentBalance) {
      return const Left(InsufficientBalanceFailure());
    }

    return await _repository.sendMoney(
      receiverAccount: params.receiverAccount,
      amount: params.amount,
      note: params.note,
    );
  }
}

class SendMoneyParams extends Equatable {
  final String receiverAccount;
  final double amount;
  final double currentBalance;
  final String? note;

  const SendMoneyParams({
    required this.receiverAccount,
    required this.amount,
    required this.currentBalance,
    this.note,
  });

  @override
  List<Object?> get props => [receiverAccount, amount, currentBalance, note];
}
