import 'package:digital_wallet/features/transactions/data/model/transaction_model.dart';
import 'package:digital_wallet/features/transactions/data/sources/transaction_remote_datasource.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TransactionModel>> getData() async {
    return await _remoteDataSource.getData();
  }

  // @override
  // Future<Either<Failure, List<TransactionEntity>>> getData() async {
  //   try {
  //     final dataList = await _remoteDataSource.getData();
  //     return Right(dataList);
  //   } on AuthException catch (e) {
  //     return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
  //   } on NetworkException {
  //     return const Left(NetworkFailure());
  //   } catch (e) {
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }
}
