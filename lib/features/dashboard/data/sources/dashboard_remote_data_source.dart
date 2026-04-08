import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/features/dashboard/data/model/current_user_model.dart';

abstract class DashboardRemoteDataSource {
  Future<CurrentUserModel> getCurrentUser();
}

class DashboardRemoteDataSourceImpl extends DashboardRemoteDataSource {
  final ApiClient _apiClient;
  DashboardRemoteDataSourceImpl(this._apiClient);

  @override
  Future<CurrentUserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.currentUser(2));
    var result = CurrentUserModel.fromJson(response.data);
    return result;
  }
}
