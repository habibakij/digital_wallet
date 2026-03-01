import 'package:equatable/equatable.dart';

abstract class SendMoneyEvent extends Equatable {
  const SendMoneyEvent();
  @override
  List<Object?> get props => [];
}

class SendMoneyRequested extends SendMoneyEvent {
  final String receiverAccount;
  final double amount;
  final double currentBalance;
  final String? note;

  const SendMoneyRequested({
    required this.receiverAccount,
    required this.amount,
    required this.currentBalance,
    this.note,
  });

  @override
  List<Object?> get props => [receiverAccount, amount, currentBalance, note];
}

class SendMoneyReset extends SendMoneyEvent {
  const SendMoneyReset();
}
