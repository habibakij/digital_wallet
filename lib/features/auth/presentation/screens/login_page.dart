import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/core/utils/widget/app_text_field.dart';
import 'package:digital_wallet/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:digital_wallet/features/auth/presentation/bloc/auth_event.dart';
import 'package:digital_wallet/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      context.read<AuthBloc>().add(LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.pushReplacementNamed(AppRoutes.dashboard);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildLoginForm(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Digital Wallet',
              style: AppTextStyles.title(fontSize: 28, color: AppColors.white),
            ),
            const SizedBox(height: 6),
            Text(
              'Secure. Fast. Reliable.',
              style: AppTextStyles.regular(color: AppColors.white.withValues(alpha: 0.7), letterSpacing: 3.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Welcome back',
              style: AppTextStyles.title(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              'Sign in to your account',
              style: AppTextStyles.regular(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            CommonTextField(
              controller: _emailController,
              labelText: 'Email address',
              hintText: 'you@example.com',
              inputTextStyle: AppTextStyles.regular(color: AppColors.textSecondary),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: InputValidator.validateEmail,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
            ),
            CommonTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: '••••••••',
              obscureText: _obscurePassword,
              inputTextStyle: AppTextStyles.regular(color: AppColors.textSecondary),
              prefixIcon: Icons.lock_outline_rounded,
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
                    style: AppTextStyles.regular(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLoginButton(state),
            const SizedBox(height: 16),
            _buildSecurityNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthState state) {
    final isLoading = state is AuthLoading;
    return ElevatedButton(
      onPressed: isLoading ? null : _onLogin,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: AppColors.primaryColor,
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
            )
          : Text(
              'Sign In',
              style: AppTextStyles.buttonStyle(fontSize: 18),
            ),
    );
  }

  Widget _buildSecurityNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.security, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          '256-bit SSL encrypted connection',
          style: AppTextStyles.regular(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 12),
        ),
      ],
    );
  }
}
