import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionRetry extends StatelessWidget {
  final String? message;
  final VoidCallback? onTab;
  const TransactionRetry({super.key, this.message, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: AppColors.errorColor, size: 48),
        const SizedBox(height: 16),
        Text(message ?? '', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onTab,
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
        ),
      ],
    );
  }
}
