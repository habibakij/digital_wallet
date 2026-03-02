import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? accountNumber;
  final double? balance;
  final String? avatarUrl;
  final bool isKycVerified;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.accountNumber,
    this.balance,
    this.avatarUrl,
    this.isKycVerified = false,
  });

  UserEntity copyWith({double? balance, String? avatarUrl, bool? isKycVerified}) {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      accountNumber: accountNumber,
      balance: balance ?? this.balance,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isKycVerified: isKycVerified ?? this.isKycVerified,
    );
  }

  @override
  List<Object?> get props => [id, email, balance];
}
