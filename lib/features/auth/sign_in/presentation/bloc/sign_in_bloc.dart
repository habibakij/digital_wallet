import 'dart:async';

import 'package:digital_wallet/core/service/local_storage_service.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_in_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_event.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _loginUseCase;
  late LocalStorageService localStorageService;

  SignInBloc({required SignInUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const SignInState()) {
    on<EmailChanged>(_emailChange);
    on<PasswordChanged>(_passwordChange);
    on<SignInSubmitted>(_submitRequest);
  }

  void _emailChange(EmailChanged event, Emitter<SignInState> emit) {
    final error = InputValidator.validateEmail(event.email) ?? '';
    emit(state.copyWith(
      email: event.email,
      emailTouched: true,
      emailError: error,
      clearEmailError: error.isNotEmpty ? false : true,
    ));
  }

  void _passwordChange(PasswordChanged event, Emitter<SignInState> emit) {
    final error = InputValidator.validatePassword(event.password) ?? '';
    emit(state.copyWith(
      password: event.password,
      passwordTouched: true,
      passwordError: error,
      clearPasswordError: error.isNotEmpty ? false : true,
    ));
  }

  Future<void> _submitRequest(SignInSubmitted event, Emitter<SignInState> emit) async {
    final emailError = InputValidator.validateEmail(state.email);
    final passwordError = InputValidator.validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        emailTouched: true,
        passwordTouched: true,
      ));
      return;
    }
    emit(state.copyWith(status: FormStatus.submitting));

    //final result = await _loginUseCase(SignInParams(email: state.email, password: state.password));
    final result = await _loginUseCase(const SignInParams(email: "john@mail.com", password: "changeme"));
    result.fold(
      (failure) => emit(state.copyWith(status: FormStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: FormStatus.success, clearErrorMessage: true)),
    );
  }
}
