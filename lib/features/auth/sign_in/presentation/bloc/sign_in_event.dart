import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignInEvent {
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object> get props => [];
}

class PasswordChanged extends SignInEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [];
}

class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}

class LoginRequested extends SignInEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends SignInEvent {
  const LogoutRequested();
}
