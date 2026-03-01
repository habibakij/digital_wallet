import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.logout();
  }
}
