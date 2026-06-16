import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DashboardUseCase extends UseCase<CurrentUserEntity, NoParams> {
  final DashboardRepository _repository;
  DashboardUseCase(this._repository);

  @override
  Future<Either<Failure, CurrentUserEntity>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
