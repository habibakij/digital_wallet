import 'package:digital_wallet/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wallet/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:digital_wallet/features/transactions/presentation/pages/transaction_list_page.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'custom_transition.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.SPLASH_SCREEN,
      name: AppRoutes.SPLASH_SCREEN,
      pageBuilder: (context, state) => customTransition(state: state, child: const LoginPage()),
    ),
    GoRoute(
      path: AppRoutes.SIGNIN_SCREEN,
      name: AppRoutes.SIGNIN_SCREEN,
      pageBuilder: (context, state) => customTransition(state: state, child: const LoginPage()),
    ),
    GoRoute(
      path: AppRoutes.DASHBOARD_SCREEN,
      name: AppRoutes.DASHBOARD_SCREEN,
      pageBuilder: (context, state) => customTransition(state: state, child: const DashboardPage()),
    ),
    // GoRoute(
    //   path: AppRoutes.SEND_MONEY_SCREEN,
    //   name: AppRoutes.SEND_MONEY_SCREEN,
    //   pageBuilder: (context, state) => customTransition(state: state, child: const SendMoneyPage(currentUser: )),
    // ),
    GoRoute(
      path: AppRoutes.TRANSECTION_SCREEN,
      name: AppRoutes.TRANSECTION_SCREEN,
      pageBuilder: (context, state) => customTransition(state: state, child: const TransactionListPage()),
    ),
  ],
);
