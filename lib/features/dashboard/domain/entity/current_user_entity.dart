import 'package:equatable/equatable.dart';

class CurrentUserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? accountNumber;
  final double? balance;
  final String? avatar;
  final bool isKycVerified;

  const CurrentUserEntity({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.accountNumber,
    this.balance,
    this.avatar,
    this.isKycVerified = false,
  });

  CurrentUserEntity copyWith({double? balance, String? avatar, bool? isKycVerified}) {
    return CurrentUserEntity(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      accountNumber: accountNumber,
      balance: balance ?? this.balance,
      avatar: avatar ?? this.avatar,
      isKycVerified: isKycVerified ?? this.isKycVerified,
    );
  }

  @override
  List<Object?> get props => [id, email, balance];
}
