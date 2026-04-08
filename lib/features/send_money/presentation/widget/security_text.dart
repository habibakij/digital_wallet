import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class SecurityText extends StatelessWidget {
  const SecurityText({super.key});

  @override
  Widget build(BuildContext context) {
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
}
