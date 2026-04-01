import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/utils/widget/snack_bar.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuickActionHandler {
  QuickActionHandler._();

  static void handle(BuildContext context, String label) {
    switch (label) {
      case 'Send Money':
        _navigateToSendMoney(context);
        return;
      case 'Fund Transfer':
      case 'Add Funds':
      case 'Balance Inquiry':
      case 'Top Up':
      case 'Mini Statement':
      case 'Bill Payments':
      case 'Scan QR':
        AppSnackBar.warning("Coming Soon,\nThis feature is under development and will be available in a future update.");
        return;
      default:
        AppSnackBar.warning("Ohh no we are absolutely sorry,\nFixing very soon");
        return;
    }
  }

  static void _navigateToSendMoney(BuildContext context) {
    final state = context.read<DashboardBloc>().state;
    final user = state is DashboardLoaded ? state.user : null;
    context.goNamed(AppRoutes.sendMoney, extra: user);
  }
}
