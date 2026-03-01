import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/failures.dart';
import 'package:digital_wallet/features/transactions/domain/entities/paginated_transactions.dart';

abstract class TransactionRepository {
  Future<Either<Failure, PaginatedTransactions>> getTransactions({
    required int page,
    required int pageSize,
  });
}
