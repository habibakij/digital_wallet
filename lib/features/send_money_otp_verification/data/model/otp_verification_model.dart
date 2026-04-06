import 'package:digital_wallet/features/send_money_otp_verification/domain/entities/otp_verification_entity.dart';

class OtpVerificationModel extends OtpVerificationEntity {
  const OtpVerificationModel({
    super.otp,
    super.transactionId,
    super.message,
  });

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationModel(
      otp: json['otp']?.toString() ?? '',
      transactionId: json['transaction_id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  OtpVerificationEntity toEntity() {
    return OtpVerificationEntity(
      otp: otp,
      transactionId: transactionId,
      message: message,
    );
  }
}
