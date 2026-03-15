import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';

class CurrentUserModel extends CurrentUserEntity {
  const CurrentUserModel({
    super.id,
    super.name,
    super.email,
    super.phoneNumber,
    super.accountNumber,
    super.balance,
    super.avatar,
    super.isKycVerified,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      accountNumber: json['account_number'] ?? '01234567890',
      balance: (json['balance'] as num?)?.toDouble() ?? 8454.0,
      avatar: json['avatar'] ?? 'https://www.shareicon.net/data/512x512/2016/09/15/829472_man_512x512.png',
      isKycVerified: json['is_kyc_verified'] ?? true,
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
      'avatar': avatar,
      'is_kyc_verified': isKycVerified,
    };
  }
}
