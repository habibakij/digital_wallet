import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();
  @override
  List<Object?> get props => [];
}

class VerifyOtpEvent extends OtpVerificationEvent {
  final String otp;
  const VerifyOtpEvent({required this.otp});

  @override
  List<Object?> get props => [otp];
}

class ResendOtpEvent extends OtpVerificationEvent {
  final String otp;
  const ResendOtpEvent({required this.otp});

  @override
  List<Object?> get props => [otp];
}
