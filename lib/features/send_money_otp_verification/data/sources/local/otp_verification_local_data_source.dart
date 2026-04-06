import 'package:digital_wallet/features/send_money_otp_verification/data/model/otp_verification_model.dart';

abstract class OtpVerificationLocalDataSource {
  Future<OtpVerificationModel> otpVerification();
}

class OtpVerificationLocalDataSourceImpl implements OtpVerificationLocalDataSource {
  @override
  Future<OtpVerificationModel> otpVerification() {
    return Future.delayed(const Duration(seconds: 2), () {
      return const OtpVerificationModel(
        otp: "001122",
        transactionId: "1234567890",
        message: "System generated OTP for the transaction id 1234567890",
      );
    });
  }
}
