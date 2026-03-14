import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/features/auth/sign_in/data/sources/sign_in_remote_datasource.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/entities/sign_in_entity.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/repositories/sign_in_repository.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInRemoteDatasource _remoteDataSource;
  final SecureStorageService _secureStorageService;
  SignInRepositoryImpl(this._remoteDataSource, this._secureStorageService);

  @override
  Future<Either<Failure, SignInEntity>> signIn({required String email, required String password}) async {
    try {
      final auth = await _remoteDataSource.signIn(email: email, password: password);
      return Right(auth);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (_) {
      // Even if remote logout fails, clear local tokens
      await _secureStorageService.clearAll();
      return const Right(null);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _secureStorageService.hasValidSession();
  }
}
