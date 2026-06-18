import 'package:digital_wallet/core/constants/asset_manager.dart';
import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/core/utils/widget/app_text_field.dart';
import 'package:digital_wallet/core/utils/widget/common_app_bar.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_bloc.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_event.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_state.dart';
import 'package:digital_wallet/features/send_money/presentation/widget/balance_summary.dart';
import 'package:digital_wallet/features/send_money/presentation/widget/security_text.dart';
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
  final ValueNotifier<double> _enteredAmount = ValueNotifier(0.0);

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SendMoneyBloc>().add(
            SendMoneyRequestEvent(
              receiverAcc: _accountController.text.trim(),
              amount: double.parse(_amountController.value.text),
              currBalance: widget.currentUser.balance ?? 0,
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
            context.pushNamed(AppRoutes.dashboard);
          }
        },
      ),
      body: BlocConsumer<SendMoneyBloc, SendMoneyState>(
        listener: (context, state) {
          if (state is SendMoneySuccessState) {
            context.pushNamed(AppRoutes.otpVerification, extra: state.entity);
          } else if (state is SendMoneyErrorState) {
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
          final bloc = context.read<SendMoneyBloc>();
          final isLoading = state is SendMoneyLoadingState;
          if (state is SendMoneyValidationFailedState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: _buildForm(bloc, state, isLoading),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: _buildForm(bloc, state, isLoading),
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

  Widget _buildForm(SendMoneyBloc bloc, SendMoneyState state, bool isLoading) {
    return Column(
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
          onChanged: (value) => bloc.add(AccountNoChangedEvent(value)),
          errorText: state is SendMoneyValidationFailedState
              ? state.validAccount
                  ? null
                  : state.accountNoError
              : null,
          validator: InputValidator.validateAccountNumber,
        ),
        const SizedBox(height: 4),
        _buildSectionTitle('Transfer Amount'),
        CommonTextField(
          controller: _amountController,
          hintText: '৳ 0.00',
          inputTextStyle: AppTextStyles.title(fontSize: 22, color: AppColors.textPrimary),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          prefixIcon: Padding(padding: const EdgeInsets.all(16.0), child: Image.asset(tkSign, width: 10, height: 10)),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              'Max ৳50,000',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withValues(alpha: 0.7)),
            ),
          ),
          autofillHints: const [AutofillHints.name],
          onChanged: (value) {
            _enteredAmount.value = double.tryParse(value) ?? 0;
            bloc.add(AmountChangedEvent(value));
          },
          errorText: state is SendMoneyValidationFailedState
              ? state.validAmount
                  ? null
                  : state.amountError
              : null,
          validator: InputValidator.validateAmount,
        ),
        ValueListenableBuilder(
          valueListenable: _enteredAmount,
          builder: (context, visible, _) {
            final remaining = widget.currentUser.balance! - _enteredAmount.value;
            final isInsufficient = remaining <= 0;
            debugPrint("check_balance: ${widget.currentUser.balance} - ${_enteredAmount.value} == $remaining");
            return _enteredAmount.value <= 0
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      isInsufficient ? 'Insufficient balance' : 'Remaining: ${CurrencyFormatter.formatSimple(remaining)}',
                      style: AppTextStyles.regular(
                        fontSize: 12,
                        color: isInsufficient ? AppColors.errorColor : AppColors.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
          },
        ),
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
          needToValidator: false,
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
        const SecurityText(),
      ],
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
            final selected = _enteredAmount.value == amount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    _enteredAmount.value = amount;
                    _amountController.text = amount.toStringAsFixed(0);
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
}
