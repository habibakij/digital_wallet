import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/send_money/data/sources/send_money_remote_datasource.dart';
import 'package:digital_wallet/features/send_money/domain/entities/transfer_entity.dart';
import 'package:digital_wallet/features/send_money/domain/repository/send_money_repository.dart';

class SendMoneyRepositoryImpl implements SendMoneyRepository {
  final SendMoneyRemoteDataSource _remoteDataSource;

  SendMoneyRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TransferEntity>> sendMoney({
    required String receiverAccount,
    required double amount,
    String? note,
  }) async {
    try {
      final result = await _remoteDataSource.sendMoney(
        receiverAccount: receiverAccount,
        amount: amount,
        note: note,
      );
      return Right(result);
    } on InsufficientBalanceFailure catch (e) {
      return Left(e);
    } on ValidationFailure catch (e) {
      return Left(e);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
