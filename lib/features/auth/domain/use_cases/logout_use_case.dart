import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/failures.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.logout();
  }
}
