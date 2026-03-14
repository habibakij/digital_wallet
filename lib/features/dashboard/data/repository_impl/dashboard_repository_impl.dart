import 'package:digital_wallet/features/dashboard/data/sources/dashboard_remote_data_source.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardRemoteDataSource _dashboardRemoteDataSource;
  DashboardRepositoryImpl(this._dashboardRemoteDataSource);

  @override
  Future<CurrentUserEntity> getCurrentUser() {
    return _dashboardRemoteDataSource.getCurrentUser();
  }
}
