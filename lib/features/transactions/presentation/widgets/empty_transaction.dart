import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(
          'No transactions yet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your transaction history will appear here',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
