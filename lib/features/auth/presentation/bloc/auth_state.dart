import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class InitialState extends AuthState {
  const InitialState();
}

class LoadingState extends AuthState {
  const LoadingState();
}

class AuthenticatedState extends AuthState {
  final UserEntity user;
  const AuthenticatedState({required this.user});

  @override
  List<Object> get props => [user];
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class AuthError extends AuthState {
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;
  final bool isValid;
  final bool isSuccess;

  const AuthError({
    this.emailError,
    this.passwordError,
    this.errorMessage,
    this.isValid = false,
    this.isSuccess = false,
  });

  @override
  List<Object> get props => [emailError ?? '', passwordError ?? '', isValid, isSuccess];
}
