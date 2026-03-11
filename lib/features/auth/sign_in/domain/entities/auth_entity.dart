import 'package:digital_wallet/features/auth/sign_in/domain/entities/user_entity.dart';

class AuthEntity {
  final String? accessToken;
  final String? refreshToken;
  final UserEntity? user;
  final DateTime? expiresAt;

  const AuthEntity({this.accessToken, this.refreshToken, this.user, this.expiresAt});
}
