import 'package:digital_wallet/features/transactions/domain/entities/transaction_entity.dart';

class PaginatedTransactions {
  final List<TransactionEntity> transactions;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;

  const PaginatedTransactions({
    required this.transactions,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
  });
}
