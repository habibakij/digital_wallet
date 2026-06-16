import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/entities/otp_verification_entity.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/repository/otp_verification_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OtpVerificationUseCase extends UseCase<OtpVerificationEntity, OtpParams> {
  final OtpVerificationRepository _repository;
  OtpVerificationUseCase(this._repository);

  @override
  Future<Either<Failure, OtpVerificationEntity>> call(OtpParams params) {
    return _repository.verificationOtp(params);
  }
}

class OtpParams {
  final String otp;
  OtpParams({required this.otp});
}
