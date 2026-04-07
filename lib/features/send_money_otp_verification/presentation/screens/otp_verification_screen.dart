import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/bloc/otp_verification_bloc.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/bloc/otp_verification_event.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/bloc/otp_verification_state.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/widget/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        title: const Text("OTP Verification"),
        centerTitle: true,
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
                  "Enter the 6-digit code sent to your number",
                  style: AppTextStyles.regular(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 30),
                _buildOtpFields(),
                const SizedBox(height: 20),
                /*Center(
                  child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                    buildWhen: (prev, curr) => curr is OtpTimerState,
                    builder: (context, state) {
                      int seconds = 0;
                      if (state is OtpTimerState) {
                        seconds = state.seconds;
                      }
                      if (seconds == 0) {
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
                ),*/
                const Spacer(),
                BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                  builder: (context, state) {
                    final isLoading = state is OtpVerificationLoadingState;
                    return AppButton(
                      title: 'Verify & Send Money',
                      onPressed: _onVerify,
                      textStyle: AppTextStyles.buttonStyle(fontSize: 18),
                      isLoading: isLoading,
                      height: 52,
                      borderRadius: 14,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
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
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
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

/*
class _OtpVerificationPage extends StatelessWidget {
  const _OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        title: const Text("OTP Verification"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Verification Code",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We sent a 6-digit code to your registered number",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _OtpInputField(),
              const SizedBox(height: 20),
              Center(
                child: 1 == 1
                    ? TextButton(
                        onPressed: () {},
                        child: const Text("Resend OTP"),
                      )
                    : const Text(
                        "Resend in {controller.seconds.value}s",
                        style: TextStyle(color: Colors.grey),
                      ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: 1 == 1 ? null : () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: 1 == 1
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Verify & Send Money"),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              }
              String current = '';
              if (current.length > index) {
                current = current.substring(0, index);
              }
            },
          ),
        );
      }),
    );
  }
}
*/
