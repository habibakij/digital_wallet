import 'package:digital_wallet/features/auth/data/models/user_model.dart';

import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
    required super.expiresAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'].toString()) : DateTime.now().add(const Duration(hours: 24)),
    );
  }
}
