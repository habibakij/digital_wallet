import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () => context.goNamed(AppRoutes.transactions),
          child: Text(
            'See All',
            style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
