import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/features/send_money_otp_verification/data/model/otp_verification_model.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/use_case/otp_verification_use_case.dart';

abstract class OtpVerificationRemoteDataSource {
  Future<OtpVerificationModel> otpVerification(OtpParams params);
}

class OtpVerificationRemoteDataSourceImpl implements OtpVerificationRemoteDataSource {
  final ApiClient _apiClient;
  OtpVerificationRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OtpVerificationModel> otpVerification(OtpParams params) async {
    /*return await _apiClient.post("otp/verification", data: {"otp": params.otp}).then((response){
      final data = response.data;
      return OtpVerificationModel.fromJson(data);
    }).catchError((error){
      throw Exception(error.toString());
    });*/
    return Future.delayed(const Duration(seconds: 2), () {
      var data = {
        "otp": "001122",
        "transactionId": "1234567890",
        "message": "OTP Verification successfully",
      };
      return OtpVerificationModel.fromJson(data);
    });
  }
}
