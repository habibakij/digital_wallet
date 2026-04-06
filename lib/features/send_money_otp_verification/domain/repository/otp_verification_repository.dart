import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/entities/otp_verification_entity.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/use_case/otp_verification_use_case.dart';

abstract class OtpVerificationRepository {
  Future<Either<Failure, OtpVerificationEntity>> verificationOtp(OtpParams params);
}
