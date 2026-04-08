import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SendMoneyState extends Equatable {
  const SendMoneyState();
  @override
  List<Object?> get props => [];
}

class SendMoneyInitState extends SendMoneyState {
  const SendMoneyInitState();
}

class SendMoneyLoadingState extends SendMoneyState {
  const SendMoneyLoadingState();
}

class SendMoneySuccessState extends SendMoneyState {
  final SendMoneyEntity entity;
  const SendMoneySuccessState({required this.entity});
  @override
  List<Object> get props => [entity];
}

class SendMoneyValidationFailedState extends SendMoneyState {
  final String? accountNoError;
  final String? amountError;
  final bool validAccount;
  final bool validAmount;
  const SendMoneyValidationFailedState({this.accountNoError, this.amountError, this.validAccount = false, this.validAmount = false});

  @override
  List<Object> get props => [accountNoError ?? '', amountError ?? '', validAccount, validAmount];
}

class SendMoneyErrorState extends SendMoneyState {
  final String message;
  const SendMoneyErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
