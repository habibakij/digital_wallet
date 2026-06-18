import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/otp_verification/data/model/otpParams.dart';
import 'package:digital_wallet/features/otp_verification/domain/entities/otp_verification_entity.dart';

abstract class OtpVerificationRepository {
  Future<Either<Failure, OtpVerificationEntity>> verificationOtp(OtpParams params);
}
