import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:flutter/material.dart';

class EmptyTransactions extends StatelessWidget {
  final VoidCallback onRetry;
  const EmptyTransactions({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(
          'No transactions yet',
          style: AppTextStyles.title(fontSize: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Text(
          'Your transaction history will appear here',
          style: AppTextStyles.regular(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 150,
          child: AppButton(
            title: 'Retry',
            onPressed: onRetry,
            backgroundColor: AppColors.whiteLiteColor,
            textStyle: AppTextStyles.buttonStyle(color: AppColors.textPrimary),
            height: 52,
            borderRadius: 14,
          ),
        ),
      ],
    );
  }
}
