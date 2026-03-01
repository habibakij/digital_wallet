import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/server_exception.dart';

import '../../../../core/error_handler/failures.dart';
import '../../domain/entities/paginated_transactions.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../model/transfer_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PaginatedTransactions>> getTransactions({
    required int page,
    required int pageSize,
  }) async {
    try {
      final data = await _remoteDataSource.getTransactions(
        page: page,
        pageSize: pageSize,
      );

      final items = (data['data'] as List? ?? []).map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList();

      final meta = data['meta'] as Map<String, dynamic>? ?? {};
      final totalCount = (meta['total'] as num?)?.toInt() ?? 0;
      final totalPages = (meta['last_page'] as num?)?.toInt() ?? 1;

      return Right(PaginatedTransactions(
        transactions: items,
        currentPage: page,
        totalPages: totalPages,
        totalCount: totalCount,
        hasNextPage: page < totalPages,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
