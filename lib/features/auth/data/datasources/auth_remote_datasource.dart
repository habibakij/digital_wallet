import 'package:digital_wallet/core/error_handler/server_exception.dart';
import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:digital_wallet/core/utils/token_storage.dart';
import 'package:digital_wallet/features/auth/data/models/auth_model.dart';
import 'package:digital_wallet/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  AuthRemoteDataSourceImpl(this._apiClient, this._tokenStorage);

  @override
  Future<AuthModel> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        pData: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final auth = AuthModel.fromJson(response.data as Map<String, dynamic>);

        // Securely persist tokens
        await _tokenStorage.saveAccessToken(auth.accessToken);
        await _tokenStorage.saveRefreshToken(auth.refreshToken);
        await _tokenStorage.saveUserId(auth.user.id);
        return auth;
      } else if (response.statusCode == 401) {
        throw const AuthException(
          message: 'Invalid email or password',
          statusCode: 401,
        );
      } else {
        final msg = (response.data as Map?)?['message'] ?? 'Login failed';
        throw AuthException(
          message: msg.toString(),
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw AuthException(
        message: e.message ?? 'Network error_handler during login',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } finally {
      // Always clear tokens even if API call fails
      await _tokenStorage.clearAll();
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw const ServerException(message: 'Failed to fetch user profile');
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Failed to fetch profile',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
