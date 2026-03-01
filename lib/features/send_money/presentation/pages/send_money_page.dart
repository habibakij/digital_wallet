import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../bloc/send_money_bloc.dart';
import '../bloc/send_money_event.dart';
import '../bloc/send_money_state.dart';
import '../widget/success_dialog.dart';

class SendMoneyPage extends StatefulWidget {
  final UserEntity currentUser;

  const SendMoneyPage({super.key, required this.currentUser});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
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
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SendMoneyBloc>().add(SendMoneyRequested(
            receiverAccount: _accountController.text.trim(),
            amount: double.parse(_amountController.text),
            currentBalance: widget.currentUser.balance,
            note: _noteController.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Send Money')),
      body: BlocConsumer<SendMoneyBloc, SendMoneyState>(
        listener: (context, state) {
          if (state is SendMoneySuccess) {
            _showSuccessDialog(state);
          } else if (state is SendMoneyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: AppTheme.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                  _buildBalanceSummary(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Recipient Details'),
                  const SizedBox(height: 12),
                  _buildAccountField(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Transfer Amount'),
                  const SizedBox(height: 12),
                  _buildAmountField(),
                  const SizedBox(height: 4),
                  _buildAmountHint(),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Note (Optional)'),
                  const SizedBox(height: 12),
                  _buildNoteField(),
                  const SizedBox(height: 32),
                  _buildQuickAmounts(),
                  const SizedBox(height: 32),
                  _buildSendButton(isLoading),
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

  Widget _buildBalanceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              Text(
                CurrencyFormatter.format(widget.currentUser.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Icon(Icons.account_balance_wallet_outlined, color: Colors.white54, size: 36),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.textPrimary,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildAccountField() {
    return TextFormField(
      controller: _accountController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
      decoration: const InputDecoration(
        hintText: 'Enter account number',
        prefixIcon: Icon(Icons.person_outline, color: AppTheme.textSecondary),
        labelText: 'Receiver Account Number',
      ),
      validator: InputFormatters.validateAccountNumber,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppTheme.primaryColor,
      ),
      decoration: InputDecoration(
        hintText: '0.00',
        prefixText: '৳ ',
        prefixStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryColor,
        ),
        labelText: 'Amount',
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            'Max ৳50,000',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary.withValues(alpha: 0.7)),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      onChanged: (v) {
        setState(() => _enteredAmount = double.tryParse(v) ?? 0);
      },
      validator: (v) => InputFormatters.validateAmount(v, widget.currentUser.balance),
    );
  }

  Widget _buildAmountHint() {
    if (_enteredAmount <= 0) return const SizedBox.shrink();
    final remaining = widget.currentUser.balance - _enteredAmount;
    final isInsufficient = remaining < 0;
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        isInsufficient ? 'Insufficient balance' : 'Remaining: ${CurrencyFormatter.formatSimple(remaining)}',
        style: TextStyle(
          fontSize: 12,
          color: isInsufficient ? AppTheme.errorColor : AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteController,
      maxLength: 100,
      maxLines: 2,
      decoration: const InputDecoration(
        hintText: 'e.g. Rent payment, Birthday gift...',
        prefixIcon: Icon(Icons.notes_outlined, color: AppTheme.textSecondary),
        labelText: 'Note (optional)',
        counterText: '',
      ),
    );
  }

  Widget _buildQuickAmounts() {
    final amounts = [500.0, 1000.0, 2000.0, 5000.0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Select',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 10),
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
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? AppTheme.primaryColor : AppTheme.dividerColor,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '৳${amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppTheme.textPrimary,
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

  Widget _buildSendButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _onSend,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 18),
                SizedBox(width: 10),
                Text('Send Money', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              ],
            ),
    );
  }

  Widget _buildSecurityNote() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          Text(
            'End-to-end encrypted transfer',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
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
          context.read<DashboardBloc>().add(
                DashboardBalanceUpdated(newBalance: state.transfer.newBalance),
              );
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
