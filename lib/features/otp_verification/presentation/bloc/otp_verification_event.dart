import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();
  @override
  List<Object?> get props => [];
}

class OtpVerificationInitEvent extends OtpVerificationEvent {
  final String otp;
  const OtpVerificationInitEvent({required this.otp});

  @override
  List<Object?> get props => [otp];
}

class StartOtpTimerEvent extends OtpVerificationEvent {}

class OtpTimerTickEvent extends OtpVerificationEvent {
  final int seconds;
  const OtpTimerTickEvent(this.seconds);
}

class ResendOtpEvent extends OtpVerificationEvent {}
