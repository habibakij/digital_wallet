import 'package:digital_wallet/core/use_case/use_case.dart';
import 'package:digital_wallet/core/utils/helper/service/local_storage_service.dart';
import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';
import 'package:digital_wallet/features/auth/domain/use_cases/login_use_case.dart';
import 'package:digital_wallet/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  late LocalStorageService localStorageService;

  AuthBloc({required LoginUseCase loginUseCase, required LogoutUseCase logoutUseCase})
      : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (auth) => emit(AuthAuthenticated(user: auth.user ?? const UserEntity())),
    );
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await _logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }
}
