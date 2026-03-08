import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';

class BuildTagName extends StatelessWidget {
  const BuildTagName({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Secure  •  Fast  •  Reliable',
      style: AppTextStyles.regular(color: AppColors.textSecondary, letterSpacing: 2.5),
    );
  }
}
