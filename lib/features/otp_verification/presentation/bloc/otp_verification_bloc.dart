import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:digital_wallet/features/otp_verification/domain/use_case/otp_verification_use_case.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_event.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final OtpVerificationUseCase _otpVerificationUseCase;

  OtpVerificationBloc(this._otpVerificationUseCase) : super(const OtpVerificationInitState(seconds: 60)) {
    on<OtpVerificationInitEvent>(_onOtpVerification);
    on<StartOtpTimerEvent>(_onStartTimer);
    on<OtpTimerTickEvent>(_onTick);
    on<ResendOtpEvent>(_onResendOtp);
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

  Timer? _timer;
  FutureOr<void> _onStartTimer(StartOtpTimerEvent event, Emitter<OtpVerificationState> emit) {
    _timer?.cancel();
    int seconds = 60;
    emit(OtpCountdownState(seconds));
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        seconds--;
        add(OtpTimerTickEvent(seconds));
        if (seconds <= 0) {
          timer.cancel();
        }
      },
    );
  }

  FutureOr<void> _onTick(OtpTimerTickEvent event, Emitter<OtpVerificationState> emit) {
    emit(OtpCountdownState(event.seconds));
  }

  FutureOr<void> _onResendOtp(ResendOtpEvent event, Emitter<OtpVerificationState> emit) async {
    add(StartOtpTimerEvent());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
