import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OtpTimerCubit extends Cubit<int> {
  OtpTimerCubit() : super(60);
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    emit(60);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state > 0) {
          emit(state - 1);
        } else {
          timer.cancel();
        }
      },
    );
  }

  void restartTimer() => startTimer();

  bool get canResend => state == 0;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
