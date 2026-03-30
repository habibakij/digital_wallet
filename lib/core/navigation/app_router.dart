import 'package:digital_wallet/core/exception_handler/route_exception.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/screens/sign_in_screen.dart';
import 'package:digital_wallet/features/auth/sign_up/presentation/screens/signup_screen.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/presentation/screens/dashboard_page.dart';
import 'package:digital_wallet/features/send_money/presentation/screens/send_money_page.dart';
import 'package:digital_wallet/features/splash/presentation/screen/splash_screen.dart';
import 'package:digital_wallet/features/transactions/presentation/screens/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'custom_transition.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // set false in production
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => customTransition(state: state, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRoutes.signIn,
        pageBuilder: (context, state) => customTransition(state: state, child: const SignInScreen()),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: AppRoutes.signUp,
        pageBuilder: (context, state) => customTransition(state: state, child: const SignUpScreen()),
      ),
      GoRoute(
        path: AppRoutes.transactions,
        name: AppRoutes.transactions,
        pageBuilder: (context, state) => customTransition(state: state, child: const TransactionListPage()),
      ),
      GoRoute(
        path: AppRoutes.sendMoney,
        name: AppRoutes.sendMoney,
        pageBuilder: (context, state) {
          final user = state.extra as CurrentUserEntity;
          return customTransition(state: state, child: SendMoneyPage(currentUser: user));
        },
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: AppRoutes.dashboard,
        pageBuilder: (context, state) => customTransition(state: state, child: const DashboardPage()),
      ),
      /*ShellRoute(
        builder: (context, state, child) => MultiBlocProvider(
          providers: [
            BlocProvider<DashboardBloc>.value(value: sl<DashboardBloc>()),
            BlocProvider<TransactionBloc>.value(value: sl<TransactionBloc>()),
          ],
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: AppRoutes.dashboard,
            pageBuilder: (context, state) => customTransition(state: state, child: const DashboardPage()),
          ),
        ],
      ),*/
      /*GoRoute(
        path: AppRoutes.sendMoney,
        name: AppRoutes.sendMoney,
        pageBuilder: (context, state) {
          final user = state.extra as UserEntity;
          return customTransition(
            state: state,
            child: BlocProvider<SendMoneyBloc>(create: (_) => sl<SendMoneyBloc>(), child: SendMoneyPage(currentUser: user)),
          );
        },
      ),*/
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: RouteException(error: state.error),
    ),
  );
}
