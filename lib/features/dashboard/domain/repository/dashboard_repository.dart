import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, CurrentUserEntity>> getCurrentUser();
}
