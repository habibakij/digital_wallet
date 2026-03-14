import 'dart:async';

import 'package:digital_wallet/core/service/local_storage_service.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_in_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_out_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_event.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _loginUseCase;
  final SignOutUseCase _logoutUseCase;
  late LocalStorageService localStorageService;

  SignInBloc({required SignInUseCase loginUseCase, required SignOutUseCase logoutUseCase})
      : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(const InitialState()) {
    on<EmailChanged>(_onEmailChangeRequest);
    on<PasswordChanged>(_onPasswordChangeRequest);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onEmailChangeRequest(EmailChanged event, Emitter<SignInState> emit) {
    String emailValidationError = InputValidator.validateEmail(event.email) ?? '';
    if (emailValidationError.isNotEmpty) {
      emit(ValidationFailedState(emailError: emailValidationError, validEmail: false));
    } else if (emailValidationError.isEmpty) {
      emit(ValidationFailedState(emailError: emailValidationError, validEmail: true));
    }
  }

  FutureOr<void> _onPasswordChangeRequest(PasswordChanged event, Emitter<SignInState> emit) {
    String passwordValidationError = InputValidator.validatePassword(event.password) ?? '';
    if (passwordValidationError.isNotEmpty) {
      emit(ValidationFailedState(passwordError: passwordValidationError, validPassword: false));
    } else if (passwordValidationError.isEmpty) {
      emit(ValidationFailedState(emailError: passwordValidationError, validPassword: true));
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<SignInState> emit) async {
    emit(const LoadingState());
    //final result = await _loginUseCase(LoginParams(email: event.email, password: event.password));
    final result = await _loginUseCase(const SignInParams(email: "john@mail.com", password: "changeme"));
    result.fold(
      (failure) => emit(SignInErrorState(errorMessage: failure.message)),
      (auth) => emit(const AuthenticatedState()),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<SignInState> emit) async {
    emit(const LoadingState());
    await _logoutUseCase(const NoParams());
    emit(const UnauthenticatedState());
  }
}
