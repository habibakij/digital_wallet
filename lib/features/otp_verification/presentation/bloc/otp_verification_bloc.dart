import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:digital_wallet/features/otp_verification/data/model/otpParams.dart';
import 'package:digital_wallet/features/otp_verification/domain/use_case/otp_resend_use_case.dart';
import 'package:digital_wallet/features/otp_verification/domain/use_case/otp_verification_use_case.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_event.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final OtpVerificationUseCase _otpVerificationUseCase;
  final OtpResendUseCase _otpResendUseCase;

  OtpVerificationBloc(this._otpVerificationUseCase, this._otpResendUseCase) : super(const OtpVerificationInitState()) {
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<OtpVerificationState> emit) async {
    emit(const OtpVerificationLoadingState());
    final result = await _otpVerificationUseCase(OtpParams(otp: event.otp));

    result.fold(
      (error) {
        emit(OtpVerificationFailState(message: error.message));
      },
      (entity) {
        if (entity.otp == event.otp) {
          emit(OtpVerificationSuccessState(entity.message ?? 'OTP Verified'));
        } else {
          emit(const OtpVerificationFailState(message: 'Invalid OTP'));
        }
      },
    );
  }

  Future<void> _onResendOtp(ResendOtpEvent event, Emitter<OtpVerificationState> emit) async {
    final result = await _otpResendUseCase(OtpParams(otp: event.otp));
    result.fold(
      (error) {
        emit(OtpVerificationFailState(message: error.message));
      },
      (entity) {
        emit(OtpResendSuccessState(entity.message ?? 'OTP Sent Successfully'));
      },
    );
  }
}
