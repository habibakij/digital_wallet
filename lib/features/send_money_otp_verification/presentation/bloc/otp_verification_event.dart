import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();
  @override
  List<Object?> get props => [];
}

class OtpVerificationInitEvent extends OtpVerificationEvent {
  final String? otp;
  const OtpVerificationInitEvent({this.otp});

  @override
  List<Object?> get props => [otp];
}
