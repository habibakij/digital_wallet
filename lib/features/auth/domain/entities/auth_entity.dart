import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';

class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;
  final DateTime expiresAt;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });
}
