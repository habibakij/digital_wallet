import 'package:equatable/equatable.dart';

abstract class SendMoneyEvent extends Equatable {
  const SendMoneyEvent();
  @override
  List<Object?> get props => [];
}

class SendMoneyRequestEvent extends SendMoneyEvent {
  final String receiverAcc;
  final double amount;
  final double currBalance;
  final String? note;

  const SendMoneyRequestEvent({required this.receiverAcc, required this.amount, required this.currBalance, this.note});

  @override
  List<Object?> get props => [receiverAcc, amount, currBalance, note];
}

class AccountNoChangedEvent extends SendMoneyEvent {
  final String accountNo;
  const AccountNoChangedEvent(this.accountNo);

  @override
  List<Object> get props => [];
}

class AmountChangedEvent extends SendMoneyEvent {
  final String amount;
  const AmountChangedEvent(this.amount);

  @override
  List<Object> get props => [];
}
