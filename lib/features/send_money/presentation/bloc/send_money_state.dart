import 'package:equatable/equatable.dart';

import '../../domain/entities/transfer_entity.dart';

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
  final TransferEntity transfer;
  const SendMoneySuccess({required this.transfer});
  @override
  List<Object> get props => [transfer];
}

class SendMoneyError extends SendMoneyState {
  final String message;
  const SendMoneyError({required this.message});
  @override
  List<Object> get props => [message];
}
