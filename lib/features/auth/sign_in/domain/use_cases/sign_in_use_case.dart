import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/entities/sign_in_entity.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SignInUseCase extends UseCase<SignInEntity, SignInParams> {
  final SignInRepository _signInRepository;
  SignInUseCase(this._signInRepository);

  @override
  Future<Either<Failure, SignInEntity>> call(SignInParams params) async {
    if (params.email.isEmpty) {
      return const Left(ValidationFailure(message: 'Email is required'));
    }
    if (params.password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }
    return await _signInRepository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
