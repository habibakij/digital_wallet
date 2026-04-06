import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/app_text_field.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/footer_security_text.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeTerms = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LoginHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Get New Experience", style: AppTextStyles.title(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      "Create your new wallet account",
                      style: AppTextStyles.regular(color: AppColors.grey),
                    ),
                    const SizedBox(height: 24),
                    CommonTextField(
                      controller: nameController,
                      labelText: 'Name',
                      hintText: 'Abdullah Aman',
                      inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_outline),
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      //onChanged: (value) => bloc.add(EmailChanged(value)),
                    ),
                    CommonTextField(
                      controller: emailController,
                      labelText: 'Email address',
                      hintText: 'you@example.com',
                      inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      //validator: InputValidator.validateEmail,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      //onChanged: (value) => bloc.add(EmailChanged(value)),
                    ),
                    CommonTextField(
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: '••••••••',
                      obscureText: obscurePassword,
                      inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                      //validator: InputValidator.validatePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      //onChanged: (value) => bloc.add(PasswordChanged(value)),
                    ),
                    CommonTextField(
                      controller: confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: '••••••••',
                      obscureText: obscureConfirmPassword,
                      inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                      ),
                      //validator: InputValidator.validatePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      //onChanged: (value) => bloc.add(PasswordChanged(value)),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20.0,
                          child: Checkbox(
                            value: agreeTerms,
                            onChanged: (value) => setState(() {
                              agreeTerms = value!;
                            }),
                          ),
                        ),
                        const Expanded(
                          child: Text("I agree with Terms & Conditions"),
                        )
                      ],
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      title: 'Sign Up',
                      onPressed: () {},
                      textStyle: AppTextStyles.buttonStyle(fontSize: 18),
                      height: 52,
                      borderRadius: 14,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            context.pushReplacementNamed(AppRoutes.signIn);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Color(0xff2F3E9E), fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    const FooterSecurityText(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
