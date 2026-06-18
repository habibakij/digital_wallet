import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/features/otp_verification/data/model/otpParams.dart';
import 'package:digital_wallet/features/otp_verification/data/model/otp_verification_model.dart';
import 'package:injectable/injectable.dart';

abstract class OtpVerificationRemoteDataSource {
  Future<OtpVerificationModel> otpVerification(OtpParams params);
}

@LazySingleton(as: OtpVerificationRemoteDataSource)
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
