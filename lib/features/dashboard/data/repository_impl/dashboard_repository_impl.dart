import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/dashboard/data/sources/dashboard_remote_data_source.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource _dashboardRemoteDataSource;
  DashboardRepositoryImpl(this._dashboardRemoteDataSource);

  @override
  Future<Either<Failure, CurrentUserEntity>> getCurrentUser() async {
    try {
      final user = await _dashboardRemoteDataSource.getCurrentUser();
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
