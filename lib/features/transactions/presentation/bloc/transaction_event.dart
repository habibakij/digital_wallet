import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object> get props => [];
}

class FetchTransactions extends TransactionEvent {
  final bool forceRefresh;
  const FetchTransactions({this.forceRefresh = false});
}

class RefreshTransactions extends TransactionEvent {
  const RefreshTransactions();
}

class LoadMoreTransactions extends TransactionEvent {
  const LoadMoreTransactions();
}
