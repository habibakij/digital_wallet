import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  @override
  List<Object?> get props => [];
}

class InitialState extends SignInState {
  const InitialState();
}

class LoadingState extends SignInState {
  const LoadingState();
}

class AuthenticatedState extends SignInState {
  const AuthenticatedState();

  @override
  List<Object> get props => [];
}

class UnauthenticatedState extends SignInState {
  const UnauthenticatedState();
}

class ValidationFailedState extends SignInState {
  final String? emailError;
  final String? passwordError;
  final bool validEmail;
  final bool validPassword;

  const ValidationFailedState({this.emailError, this.passwordError, this.validEmail = false, this.validPassword = false});

  @override
  List<Object> get props => [emailError ?? '', passwordError ?? '', validEmail, validPassword];
}

class SignInErrorState extends SignInState {
  final String errorMessage;
  const SignInErrorState({this.errorMessage = ''});

  @override
  List<Object> get props => [errorMessage];
}
