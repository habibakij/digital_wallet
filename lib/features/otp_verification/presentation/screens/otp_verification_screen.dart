import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/app_helper.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/common_app_bar.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_bloc.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_event.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_state.dart';
import 'package:digital_wallet/features/otp_verification/presentation/cubit/otp_timer_cubit.dart';
import 'package:digital_wallet/features/otp_verification/presentation/widget/success_dialog.dart';
import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  final SendMoneyEntity sendMoneyEntity;
  const OtpVerificationScreen({super.key, required this.sendMoneyEntity});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String get _otp => _otpControllers.map((e) => e.text).join();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtpTimerCubit>().startTimer();
    });
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      context.read<OtpVerificationBloc>().add(VerifyOtpEvent(otp: _otp));
    }
  }

  void _resendOtp() {
    context.read<OtpVerificationBloc>().add(ResendOtpEvent(otp: _otp));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: "OTP Verification",
        titleStyle: AppTextStyles.title(color: AppColors.white),
        onLeadingTab: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(AppRoutes.dashboard);
          }
        },
      ),
      body: BlocListener<OtpVerificationBloc, OtpVerificationState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccessState) {
            _showSuccessDialog(
              widget.sendMoneyEntity,
            );
          }

          if (state is OtpVerificationFailState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is OtpResendSuccessState) {
            context.read<OtpTimerCubit>().restartTimer();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter Verification Code", style: AppTextStyles.title()),
              const SizedBox(height: 8),
              Text(
                "Input your 6 digit OTP sent to your mobile number",
                style: AppTextStyles.regular(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 30),

              /// OTP FIELD
              _buildOtpFields(),

              const SizedBox(height: 24),

              /// RESEND SECTION
              Center(
                child: BlocBuilder<OtpTimerCubit, int>(
                  builder: (context, seconds) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        seconds > 0
                            ? Text(
                                AppHelper().formatTimer(seconds),
                                style: AppTextStyles.regular(color: AppColors.primaryColor, fontWeight: FontWeight.w500),
                              )
                            : const SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Don't receive OTP code?",
                              style: AppTextStyles.regular(),
                            ),
                            const SizedBox(width: 6.0),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Resend Code",
                                  style: AppTextStyles.regular(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                                ),
                              ),
                              onTap: () => _resendOtp,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Spacer(),

              /// VERIFY BUTTON
              BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                builder: (context, state) {
                  return AppButton(
                    title: "Verify",
                    height: 52,
                    borderRadius: 14,
                    textStyle: AppTextStyles.buttonStyle(
                      fontSize: 18,
                    ),
                    isLoading: state is OtpVerificationLoadingState,
                    onPressed: _onVerify,
                  );
                },
              ),

              const SizedBox(height: 16),

              /// CANCEL BUTTON
              AppButton(
                title: "Cancel",
                height: 52,
                borderRadius: 14,
                backgroundColor: AppColors.white,
                textStyle: AppTextStyles.buttonStyle(fontSize: 18, color: AppColors.primaryColor),
                onPressed: () {
                  context.pop();
                },
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 45,
            child: TextField(
              controller: _otpControllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: AppTextStyles.regular(color: AppColors.primaryColor),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              },
            ),
          );
        }),
      ),
    );
  }

  void _showSuccessDialog(SendMoneyEntity entity) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        entity: entity,
        onDone: () {
          Navigator.of(context).pop();
        },
        onSendAnother: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
