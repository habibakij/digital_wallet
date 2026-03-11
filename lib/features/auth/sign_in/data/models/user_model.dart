import 'package:digital_wallet/features/auth/sign_in/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.phoneNumber,
    super.accountNumber,
    super.balance,
    super.avatarUrl,
    super.isKycVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      accountNumber: json['account_number']?.toString() ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: json['avatar_url']?.toString(),
      isKycVerified: json['is_kyc_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'account_number': accountNumber,
      'balance': balance,
      'avatar_url': avatarUrl,
      'is_kyc_verified': isKycVerified,
    };
  }
}
