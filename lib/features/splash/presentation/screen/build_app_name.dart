import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class BuildAppName extends StatelessWidget {
  const BuildAppName({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Digital Wallet',
      style: AppTextStyles.title(fontSize: 38.0, color: AppColors.white, fontWeight: FontWeight.w800),
    );
  }
}
