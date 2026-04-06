import 'package:digital_wallet/core/constants/asset_manager.dart';
import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/app_text_field.dart';
import 'package:digital_wallet/core/utils/widget/common_app_bar.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_bloc.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_event.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_state.dart';
import 'package:digital_wallet/features/send_money/presentation/widget/balance_summary.dart';
import 'package:digital_wallet/features/send_money/presentation/widget/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SendMoneyScreen extends StatefulWidget {
  final CurrentUserEntity currentUser;

  const SendMoneyScreen({super.key, required this.currentUser});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  double _enteredAmount = 0;

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      context.read<SendMoneyBloc>().add(
            SendMoneyRequested(
              receiverAccount: _accountController.text.trim(),
              amount: double.parse(_amountController.text),
              currentBalance: widget.currentUser.balance ?? 0,
              note: _noteController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: "Send Money",
        titleStyle: AppTextStyles.title(color: AppColors.white),
        onLeadingTab: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(AppRoutes.dashboard);
          }
        },
      ),
      body: BlocConsumer<SendMoneyBloc, SendMoneyState>(
        listener: (context, state) {
          if (state is SendMoneySuccess) {
            _showSuccessDialog(state);
          } else if (state is SendMoneyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: AppColors.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SendMoneyLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BalanceSummary(balance: widget.currentUser.balance ?? 0),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Recipient Details'),
                  CommonTextField(
                    controller: _accountController,
                    hintText: 'Enter account number',
                    inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.person_outline),
                    autofillHints: const [AutofillHints.name],
                    validator: InputValidator.validateAccountNumber,
                  ),
                  const SizedBox(height: 4),
                  _buildSectionTitle('Transfer Amount'),
                  CommonTextField(
                    controller: _amountController,
                    hintText: '৳ 0.00',
                    inputTextStyle: AppTextStyles.title(fontSize: 22, color: AppColors.textPrimary),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    prefixIcon: Padding(padding: const EdgeInsets.all(16.0), child: Image.asset(tkSign, width: 10, height: 10)),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        'Max ৳50,000',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                      ),
                    ),
                    autofillHints: const [AutofillHints.name],
                    onChanged: (value) => _enteredAmount = double.tryParse(value) ?? 0,
                  ),
                  _buildAmountHint(),
                  const SizedBox(height: 12),
                  _buildSectionTitle('Note (Optional)'),
                  CommonTextField(
                    controller: _noteController,
                    hintText: 'e.g. Rent payment, Birthday gift...',
                    inputTextStyle: AppTextStyles.regular(color: AppColors.textPrimary),
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.notes),
                    autofillHints: const [AutofillHints.name],
                    maxLength: 100,
                  ),
                  _buildQuickAmounts(),
                  const SizedBox(height: 34),
                  AppButton(
                    title: 'Send Money',
                    onPressed: _onSend,
                    textStyle: AppTextStyles.buttonStyle(fontSize: 18),
                    isLoading: isLoading,
                    height: 52,
                    borderRadius: 14,
                    prefixIcon: Icons.send_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityNote(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.title(fontSize: 14, color: AppColors.textPrimary, letterSpacing: 0.3),
    );
  }

  Widget _buildAmountHint() {
    if (_enteredAmount <= 0) return const SizedBox.shrink();
    final remaining = widget.currentUser.balance ?? 0 - _enteredAmount;
    final isInsufficient = remaining < 0;
    return Text(
      isInsufficient ? 'Insufficient balance' : 'Remaining: ${CurrencyFormatter.formatSimple(remaining)}',
      style: AppTextStyles.regular(
        fontSize: 12,
        color: isInsufficient ? AppColors.errorColor : AppColors.errorColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildQuickAmounts() {
    final amounts = [500.0, 1000.0, 2000.0, 5000.0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Quick Select'),
        const SizedBox(height: 12),
        Row(
          children: amounts.map((amount) {
            final selected = _enteredAmount == amount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _enteredAmount = amount;
                      _amountController.text = amount.toStringAsFixed(0);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryColor : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primaryColor : AppColors.dividerColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '৳${amount.toStringAsFixed(0)}',
                      style: AppTextStyles.regular(
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSecurityNote() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_outlined, size: 14, color: AppColors.greyShade500),
          const SizedBox(width: 6),
          Text(
            'End-to-end encrypted transfer',
            style: AppTextStyles.regular(fontSize: 12, color: AppColors.greyShade500),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(SendMoneySuccess state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        transfer: state.transfer,
        onDone: () {
          Navigator.of(context).pop(); // close dialog
          // Update dashboard balance
          context.read<DashboardBloc>().add(DashboardBalanceUpdated(newBalance: state.transfer.newBalance));
          // Reset send money state
          context.read<SendMoneyBloc>().add(const SendMoneyReset());
          Navigator.of(context).pop(); // go back to dashboard
        },
        onSendAnother: () {
          Navigator.of(context).pop(); // close dialog
          context.read<SendMoneyBloc>().add(const SendMoneyReset());
          _formKey.currentState?.reset();
          _accountController.clear();
          _amountController.clear();
          _noteController.clear();
          setState(() => _enteredAmount = 0);
        },
      ),
    );
  }
}
