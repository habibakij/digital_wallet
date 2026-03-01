import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<AuthEntity, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    // Validate inputs before hitting API
    if (params.email.isEmpty) {
      return const Left(ValidationFailure(message: 'Email is required'));
    }
    if (params.password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }
    return await _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
