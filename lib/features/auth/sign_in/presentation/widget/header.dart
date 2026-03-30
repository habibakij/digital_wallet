import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/features/splash/presentation/widgets/build_app_name.dart';
import 'package:digital_wallet/features/splash/presentation/widgets/build_tag_name.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet_rounded, size: 40, color: AppColors.white),
            ),
            const SizedBox(height: 16),
            const BuildAppName(),
            const SizedBox(height: 6),
            const BuildTagName(),
          ],
        ),
      ),
    );
  }
}
