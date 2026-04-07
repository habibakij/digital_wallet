import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SendMoneyState extends Equatable {
  const SendMoneyState();
  @override
  List<Object?> get props => [];
}

class SendMoneyInitial extends SendMoneyState {
  const SendMoneyInitial();
}

class SendMoneyLoading extends SendMoneyState {
  const SendMoneyLoading();
}

class SendMoneySuccess extends SendMoneyState {
  final SendMoneyEntity entity;
  const SendMoneySuccess({required this.entity});
  @override
  List<Object> get props => [entity];
}

class SendMoneyError extends SendMoneyState {
  final String message;
  const SendMoneyError({required this.message});
  @override
  List<Object> get props => [message];
}
