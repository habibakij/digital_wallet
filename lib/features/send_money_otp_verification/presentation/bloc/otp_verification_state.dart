import 'package:equatable/equatable.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();
  @override
  List<Object?> get props => [];
}

class OtpVerificationInitState extends OtpVerificationState {
  const OtpVerificationInitState();
}

class OtpVerificationLoadingState extends OtpVerificationState {
  const OtpVerificationLoadingState();
}

class OtpVerificationSuccessState extends OtpVerificationState {
  final String message;
  const OtpVerificationSuccessState(this.message);
  @override
  List<Object> get props => [];
}

class OtpVerificationFailState extends OtpVerificationState {
  final String message;
  const OtpVerificationFailState({required this.message});
  @override
  List<Object> get props => [message];
}
