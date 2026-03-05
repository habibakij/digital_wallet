import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/failures.dart';
import 'package:digital_wallet/core/error_handler/server_exception.dart';
import 'package:digital_wallet/core/utils/helper/service/secure_storage_service.dart';
import 'package:digital_wallet/features/auth/data/sources/auth_remote_datasource.dart';
import 'package:digital_wallet/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';
import 'package:digital_wallet/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;
  AuthRepositoryImpl(this._remoteDataSource, this._secureStorageService);

  @override
  Future<Either<Failure, AuthEntity>> login({required String email, required String password}) async {
    try {
      final auth = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(auth);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Right(null);
    } catch (_) {
      // Even if remote logout fails, clear local tokens
      await _secureStorageService.clearAll();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _secureStorageService.hasValidSession();
  }
}
