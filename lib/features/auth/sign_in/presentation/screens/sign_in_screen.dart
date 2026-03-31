import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/app_text_field.dart';
import 'package:digital_wallet/core/utils/widget/debug_widget.dart';
import 'package:digital_wallet/core/utils/widget/snack_bar.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_event.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_state.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/footer_security_text.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/header.dart';
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
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_rememberMe) {
        context.read<SignInBloc>().localStorageService.saveEmail(_emailController.text);
      }
      context.read<SignInBloc>().add(
            LoginRequested(email: _emailController.text.trim(), password: _passwordController.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildLoginForm(BuildContext context, SignInState state, SignInBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Welcome back', style: AppTextStyles.title(fontSize: 24)),
                kDebugMode ? const DebugWidget() : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 4),
            Text('Sign in to your account', style: AppTextStyles.regular(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            CommonTextField(
              controller: _emailController,
              labelText: 'Email address',
              hintText: 'you@example.com',
              inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              validator: InputValidator.validateEmail,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              onChanged: (value) => bloc.add(EmailChanged(value)),
              errorText: state is ValidationFailedState
                  ? state.validEmail
                      ? null
                      : state.emailError
                  : null,
            ),
            CommonTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: '••••••••',
              obscureText: _obscurePassword,
              inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: InputValidator.validatePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onChanged: (value) => bloc.add(PasswordChanged(value)),
              errorText: state is ValidationFailedState
                  ? state.validPassword
                      ? null
                      : state.passwordError
                  : null,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                      activeColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    Text('Remember me', style: AppTextStyles.hintStyle(color: AppColors.textSecondary)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.regular(color: AppColors.primaryColor, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              title: 'Sign In',
              onPressed: state is LoadingState ? null : _onLogin,
              textStyle: AppTextStyles.buttonStyle(fontSize: 18),
              isLoading: state is LoadingState,
              height: 52,
              borderRadius: 14,
            ),
            const SizedBox(height: 8),
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
                      style: AppTextStyles.regular(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()..onTap = () => context.goNamed(AppRoutes.signUp),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const FooterSecurityText(),
          ],
        ),
      ),
    );
  }
}
