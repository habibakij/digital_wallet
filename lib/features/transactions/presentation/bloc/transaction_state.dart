import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactionList;
  const TransactionLoaded(this.transactionList);

  @override
  List<Object?> get props => [transactionList];
}

class TransactionEmpty extends TransactionState {
  const TransactionEmpty();
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
