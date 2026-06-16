import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SignOutUseCase extends UseCase<void, NoParams> {
  final SignInRepository _repository;
  SignOutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
