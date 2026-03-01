// lib/features/transactions/presentation/bloc/transaction_bloc.dart
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  int _currentPage = 1;
  bool _isFetching = false;

  TransactionBloc(this._repository) : super(const TransactionInitial()) {
    on<FetchTransactions>(_onFetchTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<LoadMoreTransactions>(_onLoadMoreTransactions);
  }

  Future<void> _onFetchTransactions(
    FetchTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;
    _currentPage = 1;
    emit(const TransactionLoading());
    await _fetchPage(1, emit, replace: true);
    _isFetching = false;
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;
    _currentPage = 1;
    await _fetchPage(1, emit, replace: true);
    _isFetching = false;
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    final current = state;
    if (_isFetching || current is! TransactionLoaded || !current.hasNextPage) {
      return;
    }

    _isFetching = true;
    emit(current.copyWith(isPaginating: true));
    await _fetchPage(_currentPage + 1, emit, existingItems: current.transactions);
    _isFetching = false;
  }

  Future<void> _fetchPage(
    int page,
    Emitter<TransactionState> emit, {
    bool replace = false,
    List<TransactionEntity> existingItems = const [],
  }) async {
    final result = await _repository.getTransactions(
      page: page,
      pageSize: AppConstants.transactionPageSize,
    );

    result.fold(
      (failure) {
        if (replace) {
          emit(TransactionError(message: failure.message));
        } else {
          // Keep existing data on pagination error
          emit(TransactionLoaded(
            transactions: existingItems,
            hasNextPage: false,
            currentPage: _currentPage,
            totalCount: existingItems.length,
            isPaginating: false,
            paginationError: failure.message,
          ));
        }
      },
      (paginated) {
        _currentPage = page;
        final allItems = replace ? paginated.transactions : [...existingItems, ...paginated.transactions];

        if (allItems.isEmpty && replace) {
          emit(const TransactionEmpty());
          return;
        }

        emit(TransactionLoaded(
          transactions: allItems,
          hasNextPage: paginated.hasNextPage,
          currentPage: paginated.currentPage,
          totalCount: paginated.totalCount,
          isPaginating: false,
        ));
      },
    );
  }
}
