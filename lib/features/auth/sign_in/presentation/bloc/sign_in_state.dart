import 'package:equatable/equatable.dart';

enum FormStatus { pure, submitting, success, failure }

class SignInState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isPasswordVisible;
  final FormStatus status;
  final String? errorMessage;
  final bool emailTouched;
  final bool passwordTouched;

  const SignInState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isPasswordVisible = false,
    this.status = FormStatus.pure,
    this.errorMessage,
    this.emailTouched = false,
    this.passwordTouched = false,
  });

  bool get isFormValid => emailError == null && passwordError == null && email.isNotEmpty && password.isNotEmpty;

  SignInState copyWith({
    String? email,
    String? password,
    String? emailError,
    bool clearEmailError = false,
    String? passwordError,
    bool clearPasswordError = false,
    bool? isPasswordVisible,
    FormStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? emailTouched,
    bool? passwordTouched,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      emailTouched: emailTouched ?? this.emailTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailError,
        passwordError,
        isPasswordVisible,
        status,
        errorMessage,
        emailTouched,
        passwordTouched,
      ];
}
