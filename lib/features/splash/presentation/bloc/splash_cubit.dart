import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'splash_state.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial()) {
    startSplash();
  }

  void startSplash() {
    Future.delayed(const Duration(seconds: 3), () {
      emit(SplashEnd());
    });
  }
}
