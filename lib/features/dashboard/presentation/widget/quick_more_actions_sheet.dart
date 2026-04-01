import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/icon_button.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/handler/quick_action_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickMoreActionsSheet extends StatelessWidget {
  const QuickMoreActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'More Options',
              style: AppTextStyles.title(color: AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: context.read<DashboardBloc>().quickMenuList.length,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final item = context.read<DashboardBloc>().quickMenuList[index];
              return CustomIconButton(
                icon: item.icon,
                label: item.label,
                iconColor: item.color,
                onTap: () {
                  Navigator.pop(context);
                  QuickActionHandler.handle(context, item.label);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
