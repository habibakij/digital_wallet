import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/features/auth/sign_in/data/models/sign_in_model.dart';

abstract class SignInRemoteDatasource {
  Future<SignInModel> signIn({required String email, required String password});
  Future<void> signOut();
}

class SignInRemoteDatasourceImpl implements SignInRemoteDatasource {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorageService;
  SignInRemoteDatasourceImpl(this._apiClient, this._secureStorageService);

  @override
  Future<SignInModel> signIn({required String email, required String password}) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      queryParameters: {'email': email, 'password': password},
    );
    final auth = SignInModel.fromJson(response.data as Map<String, dynamic>);
    await _secureStorageService.saveAccessToken(auth.accessToken ?? '');
    await _secureStorageService.saveRefreshToken(auth.refreshToken ?? '');
    return auth;
    /*return parseResponse(
      response,
      parser: (json) => SignInModel.fromJson(json),
      onSuccess: (user) async {
        await _secureStorageService.saveAccessToken(user.accessToken ?? '');
        await _secureStorageService.saveRefreshToken(user.refreshToken ?? '');
      },
    );*/
  }

  @override
  Future<void> signOut() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } finally {
      await _secureStorageService.clearAll();
    }
  }
}
