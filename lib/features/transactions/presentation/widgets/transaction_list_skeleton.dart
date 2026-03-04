import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_colors.dart';

class TransactionSkeleton extends StatelessWidget {
  const TransactionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AppColors.greyShade200, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 120, color: AppColors.greyShade200),
                const SizedBox(height: 8),
                Container(height: 10, width: 80, color: AppColors.greyShade100),
              ],
            ),
          ),
          Container(height: 14, width: 60, color: AppColors.greyShade200),
        ],
      ),
    );
  }
}
