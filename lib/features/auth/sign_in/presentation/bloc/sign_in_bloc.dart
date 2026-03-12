import 'dart:async';

import 'package:digital_wallet/core/service/local_storage_service.dart';
import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/entities/user_entity.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/login_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/logout_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_event.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  late LocalStorageService localStorageService;

  SignInBloc({required LoginUseCase loginUseCase, required LogoutUseCase logoutUseCase})
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
    final result = await _loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(SignInErrorState(errorMessage: failure.message)),
      (auth) => emit(AuthenticatedState(user: auth.user ?? const UserEntity())),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<SignInState> emit) async {
    emit(const LoadingState());
    await _logoutUseCase(const NoParams());
    emit(const UnauthenticatedState());
  }
}
