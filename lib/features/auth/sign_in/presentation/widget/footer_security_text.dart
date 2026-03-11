import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class FooterSecurityText extends StatelessWidget {
  const FooterSecurityText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.security, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          '256-bit SSL encrypted connection',
          style: AppTextStyles.regular(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 12),
        ),
      ],
    );
  }
}
