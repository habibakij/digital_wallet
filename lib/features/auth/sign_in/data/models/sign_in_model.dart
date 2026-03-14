import 'package:digital_wallet/features/auth/sign_in/domain/entities/sign_in_entity.dart';

class SignInModel extends SignInEntity {
  const SignInModel({super.accessToken, super.refreshToken, super.expiresAt});

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'].toString()) : DateTime.now().add(const Duration(hours: 24)),
    );
  }
}
