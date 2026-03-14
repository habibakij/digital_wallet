import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardUseCase {
  final DashboardRepository _repository;
  DashboardUseCase(this._repository);

  Future<CurrentUserEntity> getCurrentUser() async {
    final result = _repository.getCurrentUser();
    return result;
  }
}
