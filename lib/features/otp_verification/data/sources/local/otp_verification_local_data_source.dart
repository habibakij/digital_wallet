import 'package:digital_wallet/features/otp_verification/data/model/otp_verification_model.dart';
import 'package:digital_wallet/features/otp_verification/domain/use_case/otp_verification_use_case.dart';
import 'package:injectable/injectable.dart';

abstract class OtpVerificationLocalDataSource {
  Future<OtpVerificationModel> otpVerification(OtpParams params);
}

@LazySingleton(as: OtpVerificationLocalDataSource)
class OtpVerificationLocalDataSourceImpl implements OtpVerificationLocalDataSource {
  @override
  Future<OtpVerificationModel> otpVerification(params) {
    return Future.delayed(const Duration(seconds: 2), () {
      return const OtpVerificationModel(
        otp: "001122",
        transactionId: "1234567890",
        message: "System generated OTP for the transaction id 1234567890",
      );
    });
  }
}
