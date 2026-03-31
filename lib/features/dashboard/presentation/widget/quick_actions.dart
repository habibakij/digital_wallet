import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/utils/widget/icon_button.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 8.0,
        children: [
          CustomIconButton(
            icon: Icons.send_rounded,
            label: 'Send',
            iconColor: AppColors.green,
            onTap: () {
              context.goNamed(AppRoutes.sendMoney, extra: context.read<DashboardBloc>().state is DashboardLoaded ? (context.read<DashboardBloc>().state as DashboardLoaded).user : null);
            },
          ),
          CustomIconButton(
            icon: Icons.add_rounded,
            label: 'Top Up',
            iconColor: AppColors.primaryColor,
            onTap: () {},
          ),
          CustomIconButton(
            icon: Icons.history_rounded,
            label: 'History',
            iconColor: const Color(0xFF9C27B0),
            onTap: () => Navigator.of(context).pushNamed('/transactions'),
          ),
          CustomIconButton(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            iconColor: const Color(0xFFFF9800),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
