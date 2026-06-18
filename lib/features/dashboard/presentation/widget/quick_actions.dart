import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/utils/widget/icon_button.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/handler/quick_action_handler.dart';
import 'package:digital_wallet/features/dashboard/presentation/widget/quick_more_actions_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: 84,
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final item = context.read<DashboardBloc>().quickMenuList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CustomIconButton(
                      icon: item.icon,
                      label: item.label,
                      iconColor: item.color,
                      onTap: () => QuickActionHandler.handle(context, item.label),
                    ),
                  );
                },
              ),
            ),
            CustomIconButton(
              icon: Icons.more_horiz_rounded,
              label: "More",
              iconColor: AppColors.orangeColor,
              onTap: () => _showMoreOptions(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      builder: (_) => const QuickMoreActionsSheet(),
    );
  }
}
