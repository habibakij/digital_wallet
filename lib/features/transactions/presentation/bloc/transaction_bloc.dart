import 'dart:async';

import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  TransactionBloc(this._repository) : super(const TransactionInitial()) {
    on<FetchTransactions>(_onFetchTransactions);
    //on<RefreshTransactions>(_onRefreshTransactions);
    //on<LoadMoreTransactions>(_onLoadMoreTransactions);
  }

  FutureOr<void> _onFetchTransactions(FetchTransactions event, Emitter<TransactionState> emit) async {
    emit(const TransactionLoading());
    final result = await _repository.getData();
    if (result.isEmpty) {
      emit(const TransactionError(message: "failure.message"));
    } else {
      List<TransactionEntity> dataList = [];
      for (var i in result) {
        dataList.add(TransactionEntity(userId: i.userId, id: i.id, title: i.title, completed: i.completed));
      }
      emit(TransactionLoaded(dataList));
      print("check_data_len: ${dataList.length}");
    }
  }

  FutureOr<void> _onRefreshTransactions(RefreshTransactions event, Emitter<TransactionState> emit) {}
}
