import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/presentation/widget/balance_card.dart';
import 'package:digital_wallet/features/dashboard/presentation/widget/quick_actions.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final CurrentUserEntity currentUser;
  const DashboardHeader({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: MediaQuery.of(context).padding.top),
          child: Row(
            children: [
              Text(
                'Digital Wallet',
                style: AppTextStyles.title(color: AppColors.white70),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: CircleAvatar(
                  radius: 16.0,
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: NetworkImage(currentUser.avatar ?? ''),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        BalanceCard(currentUser: currentUser),
        const SizedBox(height: 12),
        const QuickActions(),
      ],
    );
  }
}
