import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/error_handler/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
