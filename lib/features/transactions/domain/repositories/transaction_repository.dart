import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/paginated_transactions.dart';

abstract class TransactionRepository {
  Future<Either<Failure, PaginatedTransactions>> getTransactions({
    required int page,
    required int pageSize,
  });
}
