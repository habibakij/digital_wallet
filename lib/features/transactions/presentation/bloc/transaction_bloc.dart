import 'dart:async';

import 'package:digital_wallet/features/transactions/domain/use_cases/transaction_use_case.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionUseCase _transactionUseCase;
  TransactionBloc(this._transactionUseCase) : super(const TransactionInitial()) {
    on<FetchTransactions>(_onFetchTransactions);
  }

  FutureOr<void> _onFetchTransactions(FetchTransactions event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    final result = await _transactionUseCase.getTransactionList();
    if (result.isNotEmpty) {
      emit(TransactionLoaded(result));
    } else {
      emit(const TransactionError(message: "Transaction loading failed. Tap 'Retry' to try again."));
    }
  }

  FutureOr<void> _onRefreshTransactions(RefreshTransactions event, Emitter<TransactionState> emit) {}
}
