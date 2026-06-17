import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/app_text_field.dart';
import 'package:digital_wallet/core/utils/widget/debug_widget.dart';
import 'package:digital_wallet/core/utils/widget/snack_bar.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_event.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_state.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/footer_security_text.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/header.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/password_strength_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _rememberMe = ValueNotifier(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_rememberMe.value) {
      context.read<SignInBloc>().localStorageService.saveEmail(_emailController.text);
    }
    context.read<SignInBloc>().add(const SignInSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            context.pushReplacementNamed(AppRoutes.dashboard);
          } else if (state.status == FormStatus.failure && state.errorMessage != null) {
            AppSnackBar.error(state.errorMessage ?? '');
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const LoginHeader(),
              _subHeader(),
              const SizedBox(height: 24),
              _buildLoginForm(),
              _rememberMeWidget(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );

    /*Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            context.pushReplacementNamed(AppRoutes.dashboard);
          } else if (state is SignInErrorState) {
            AppSnackBar.error(state.errorMessage);
          }
        },
        builder: (context, state) {
          final bloc = context.read<SignInBloc>();
          if (state is ValidationFailedState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const LoginHeader(),
                  _buildLoginForm(context, state, bloc),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const LoginHeader(),
                _buildLoginForm(context, state, bloc),
              ],
            ),
          );
        },
      ),
    );*/
  }

  Widget _subHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Welcome back', style: AppTextStyles.title(fontSize: 24)),
              kDebugMode ? const DebugWidget() : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to continue your journey',
            style: AppTextStyles.regular(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          final isSubmitting = state.status == FormStatus.submitting;
          final bloc = context.read<SignInBloc>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                controller: _emailController,
                labelText: 'Email address',
                hintText: 'you@example.com',
                inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enable: !isSubmitting,
                onChanged: (value) => bloc.add(EmailChanged(value)),
                errorText: state.emailTouched ? state.emailError : null,
              ),
              ValueListenableBuilder(
                valueListenable: _obscurePassword,
                builder: (BuildContext context, bool value, Widget? child) {
                  return CommonTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: '••••••••',
                    obscureText: _obscurePassword.value,
                    inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => _obscurePassword.value = !_obscurePassword.value,
                    ),
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    enable: !isSubmitting,
                    onChanged: (value) => bloc.add(PasswordChanged(value)),
                    errorText: state.passwordTouched ? state.passwordError : null,
                  );
                },
              ),
              if (state.password.isNotEmpty) PasswordStrengthIndicator(password: state.password),
            ],
          );
        },
      ),
    );
  }

  Widget _rememberMeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: _rememberMe,
                builder: (BuildContext context, bool value, Widget? child) {
                  return Checkbox(
                    value: _rememberMe.value,
                    onChanged: (v) => _rememberMe.value = v ?? false,
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  );
                },
              ),
              Text('Remember me', style: AppTextStyles.hintStyle(color: AppColors.textSecondary)),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.regular(
                  color: AppColors.primaryColor, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          final isSubmitting = state.status == FormStatus.submitting;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: AppButton(
              title: 'Sign In',
              onPressed: _onLogin,
              backgroundColor: isSubmitting
                  ? AppColors.primaryColor.withValues(alpha: 0.6)
                  : AppColors.primaryColor,
              textStyle: AppTextStyles.buttonStyle(fontSize: 18),
              isLoading: isSubmitting,
              height: 52,
              borderRadius: 14,
            ),

            /*ElevatedButton(
              onPressed: isSubmitting ? null : () => context.read<SignInBloc>().add(const SignInSubmitted()),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSubmitting ? AppTheme.primaryColor.withValues(alpha: 0.6) : AppTheme.primaryColor,
              ),
              child: isSubmitting
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
                  : const Text('Sign In'),
            ),*/
          );
        },
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Center(
            child: RichText(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 1,
              text: TextSpan(
                text: "Don't have an account? ",
                style: AppTextStyles.hintStyle(color: AppColors.textSecondary, fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                    text: "Sign Up",
                    style: AppTextStyles.regular(
                        color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.pushReplacementNamed(AppRoutes.signUp),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const FooterSecurityText(),
        ],
      ),
    );
  }
}
