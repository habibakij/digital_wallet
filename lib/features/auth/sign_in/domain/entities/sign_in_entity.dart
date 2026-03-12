import 'package:digital_wallet/features/auth/sign_in/domain/entities/user_entity.dart';

class SignInEntity {
  final String? accessToken;
  final String? refreshToken;
  final UserEntity? user;
  final DateTime? expiresAt;

  const SignInEntity({this.accessToken, this.refreshToken, this.user, this.expiresAt});
}
