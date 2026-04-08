import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionHeader extends StatelessWidget {
  final bool isTransactionPage;
  const TransactionHeader({super.key, this.isTransactionPage = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: AppTextStyles.regular(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            isTransactionPage
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => context.pushNamed(AppRoutes.transactions),
                    child: Text(
                      'See all',
                      style: AppTextStyles.regular(fontWeight: FontWeight.w600),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
