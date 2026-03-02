import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/failures.dart';
import 'package:digital_wallet/core/use_case/usecase.dart';
import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';

class TransactionUseCase extends UseCase<TransactionEntity, NoParams> {
  final TransactionRepository _repository;
  TransactionUseCase(this._repository);

  @override
  Future<Either<Failure, TransactionEntity>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
