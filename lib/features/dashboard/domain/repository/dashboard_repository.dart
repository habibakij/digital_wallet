import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';

abstract class DashboardRepository {
  Future<CurrentUserEntity> getCurrentUser();
}
