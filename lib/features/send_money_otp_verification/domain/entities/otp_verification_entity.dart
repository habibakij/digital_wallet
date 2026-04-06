import 'package:equatable/equatable.dart';

class OtpVerificationEntity extends Equatable {
  final String? otp;
  final String? transactionId;
  final String? message;

  const OtpVerificationEntity({this.otp, this.transactionId, this.message});

  @override
  List<Object?> get props => [otp, transactionId];
}
