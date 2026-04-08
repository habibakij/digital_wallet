import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorRetryWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.red, size: 84),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.regular(fontSize: 16, color: AppColors.white)),
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
        ),
      ),
    );
  }
}
