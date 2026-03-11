import 'package:digital_wallet/core/constants/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  SecureStorageService(this._secureStorage);

  // Android options for encrypted storage
  static const _androidOptions = AndroidOptions(encryptedSharedPreferences: true, resetOnError: true);

  static const _iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.accessTokenKey,
      value: token,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: token,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(
      key: AppConstants.accessTokenKey,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(
      key: AppConstants.refreshTokenKey,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(
      key: AppConstants.userIdKey,
      value: userId,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(
      key: AppConstants.userIdKey,
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll(
      aOptions: _androidOptions,
      iOptions: _iOSOptions,
    );
  }
}
