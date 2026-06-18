import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/common_app_bar.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_bloc.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_event.dart';
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_state.dart';
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
  final List<TextEditingController> otpController = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String get _otp => otpController.map((e) => e.text).join();

  @override
  void initState() {
    super.initState();
    context.read<OtpVerificationBloc>().add(StartOtpTimerEvent());
  }

  @override
  void dispose() {
    for (var c in otpController) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      context.read<OtpVerificationBloc>().add(OtpVerificationInitEvent(otp: _otp));
    }
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
            _showSuccessDialog(widget.sendMoneyEntity);
          } else if (state is OtpVerificationFailState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Verification Code",
                  style: AppTextStyles.title(),
                ),
                const SizedBox(height: 8),
                Text(
                  "Input your 6 digit number that was sent to your mobile",
                  style: AppTextStyles.regular(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 30),
                _buildOtpFields(),
                const SizedBox(height: 20),
                BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                  builder: (context, state) {
                    int seconds = 0;
                    if (state is OtpCountdownState) {
                      seconds = state.seconds;
                    }
                    if (seconds <= 0) {
                      return TextButton(
                        onPressed: () {
                          context.read<OtpVerificationBloc>().add(ResendOtpEvent());
                        },
                        child: const Text("Resend OTP"),
                      );
                    }
                    return Text(
                      "Resend in ${seconds}s",
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
                const Spacer(),
                BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                  builder: (context, state) {
                    final isLoading = state is OtpVerificationLoadingState;
                    return AppButton(
                      title: 'Verify',
                      onPressed: _onVerify,
                      textStyle: AppTextStyles.buttonStyle(fontSize: 18),
                      isLoading: isLoading,
                      height: 52,
                      borderRadius: 14,
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: AppButton(
                    backgroundColor: AppColors.white,
                    title: 'Cancel',
                    textStyle: AppTextStyles.buttonStyle(fontSize: 18, color: AppColors.primaryColor),
                    onPressed: _onVerify,
                    height: 52,
                    borderRadius: 14,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            controller: otpController[index],
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
          //context.read<DashboardBloc>().add(DashboardBalanceUpdated(newBalance: state.entity.newBalance));
          //context.read<SendMoneyBloc>().add(const SendMoneyReset());
        },
        onSendAnother: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
