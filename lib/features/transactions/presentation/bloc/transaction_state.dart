import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction_entity.dart';

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

class TransactionEmpty extends TransactionState {
  const TransactionEmpty();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  final bool hasNextPage;
  final int currentPage;
  final int totalCount;
  final bool isPaginating;
  final String? paginationError;

  const TransactionLoaded({
    required this.transactions,
    required this.hasNextPage,
    required this.currentPage,
    required this.totalCount,
    this.isPaginating = false,
    this.paginationError,
  });

  TransactionLoaded copyWith({
    List<TransactionEntity>? transactions,
    bool? hasNextPage,
    int? currentPage,
    int? totalCount,
    bool? isPaginating,
    String? paginationError,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
      isPaginating: isPaginating ?? this.isPaginating,
      paginationError: paginationError ?? this.paginationError,
    );
  }

  @override
  List<Object?> get props => [transactions, hasNextPage, currentPage, isPaginating, paginationError];
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
