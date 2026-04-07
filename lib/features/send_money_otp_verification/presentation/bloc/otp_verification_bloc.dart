import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:digital_wallet/core/utils/widget/snack_bar.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/use_case/otp_verification_use_case.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/bloc/otp_verification_event.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/bloc/otp_verification_state.dart';
import 'package:flutter/cupertino.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final OtpVerificationUseCase _otpVerificationUseCase;

  OtpVerificationBloc(this._otpVerificationUseCase) : super(const OtpVerificationInitState()) {
    on<OtpVerificationInitEvent>(_onOtpVerification);
  }

  FutureOr<void> _onOtpVerification(OtpVerificationInitEvent event, Emitter<OtpVerificationState> emit) async {
    emit(const OtpVerificationLoadingState());
    var otpParams = OtpParams(otp: event.otp);
    final result = await _otpVerificationUseCase.call(otpParams);
    result.fold((error) {
      emit(OtpVerificationFailState(message: error.message));
    }, (entity) {
      debugPrint("input: ${event.otp} and server: ${entity.otp}");
      if (event.otp == entity.otp) {
        emit(OtpVerificationSuccessState(entity.message ?? ''));
      } else {
        emit(const OtpVerificationFailState(message: "Invalid otp"));
      }
    });
  }

  String otp = '';
  int seconds = 60;
  bool isLoading = false;
  Timer? _timer;
  void startTimer() {
    seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        seconds--;
      }
    });
  }

  void resendOtp() {
    startTimer();
  }

  Future<void> verifyOtp() async {
    if (otp.length < 6) {
      AppSnackBar.warning("length of otp should be 6 digits");
      return;
    }
    isLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading = false;
  }
}
