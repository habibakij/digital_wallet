import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/app_helper.dart';
import 'package:flutter/material.dart';

class BalanceSummary extends StatelessWidget {
  final double balance;
  const BalanceSummary({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Balance', style: AppTextStyles.regular(color: AppColors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                AppHelper.format(balance),
                style: AppTextStyles.title(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const Icon(Icons.account_balance_wallet_outlined, color: Colors.white54, size: 44),
        ],
      ),
    );
  }
}
