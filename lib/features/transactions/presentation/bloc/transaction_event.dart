import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object> get props => [];
}

class FetchTransactions extends TransactionEvent {
  const FetchTransactions();
}

class RefreshTransactions extends TransactionEvent {
  const RefreshTransactions();
}

class LoadMoreTransactions extends TransactionEvent {
  const LoadMoreTransactions();
}
