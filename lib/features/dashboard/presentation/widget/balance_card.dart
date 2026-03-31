import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final CurrentUserEntity currentUser;
  BalanceCard({super.key, required this.currentUser});

  final ValueNotifier<bool> _balanceVisible = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, ${currentUser.name?.split(' ').first} 👋',
                  style: AppTextStyles.regular(color: AppColors.greyShade300, fontSize: 16),
                ),
                const Spacer(),
                if (currentUser.isKycVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentColor, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, size: 12, color: AppColors.accentColor),
                        const SizedBox(width: 4),
                        Text(
                          'KYC Verified',
                          style: AppTextStyles.regular(color: AppColors.accentColor, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Balance',
                        style: AppTextStyles.regular(color: AppColors.whiteLiteColor),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _balanceVisible,
                        builder: (context, visible, _) {
                          return GestureDetector(
                            onTap: () {
                              _balanceVisible.value = !_balanceVisible.value;
                            },
                            child: Icon(
                              _balanceVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.whiteLiteColor,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 0),
                    child: ValueListenableBuilder(
                      valueListenable: _balanceVisible,
                      builder: (context, visible, _) {
                        return _balanceVisible.value
                            ? Text(
                                CurrencyFormatter.format(currentUser.balance ?? 0),
                                key: const ValueKey('visible'),
                                style: AppTextStyles.title(
                                  color: AppColors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              )
                            : Text(
                                '৳ ••••••••••••',
                                key: const ValueKey('hidden'),
                                style: AppTextStyles.title(color: AppColors.white, fontSize: 32, fontWeight: FontWeight.w700),
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.regular(color: AppColors.whiteLiteColor, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Account: ',
                          style: AppTextStyles.regular(color: AppColors.whiteLiteColor, fontSize: 12),
                        ),
                        TextSpan(
                          text: currentUser.accountNumber,
                          style: AppTextStyles.regular(color: AppColors.whiteLiteColor, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
