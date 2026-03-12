import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/entities/sign_in_entity.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/entities/user_entity.dart';

abstract class SignInRepository {
  Future<Either<Failure, SignInEntity>> signIn({required String email, required String password});

  Future<void> logout();

  Future<UserEntity> getCurrentUser();

  Future<bool> isAuthenticated();
}
