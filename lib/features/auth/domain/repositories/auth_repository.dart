import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/failures.dart';
import 'package:digital_wallet/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({required String email, required String password});

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<bool> isAuthenticated();
}
