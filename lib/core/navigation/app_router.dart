import 'package:digital_wallet/core/error_handler/route_exception.dart';
import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';
import 'package:digital_wallet/features/auth/presentation/screens/login_page.dart';
import 'package:digital_wallet/features/auth/presentation/screens/splash_screen.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/screens/dashboard_page.dart';
import 'package:digital_wallet/features/send_money/presentation/screens/send_money_page.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/screens/transaction_list_page.dart';
import 'package:digital_wallet/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        path: AppRoutes.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) => customTransition(state: state, child: const LoginPage()),
      ),
      /*GoRoute(
        path: AppRoutes.dashboard,
        name: AppRoutes.dashboard,
        pageBuilder: (context, state) => customTransition(state: state, child: const DashboardPage()),
      ),*/
      GoRoute(
        path: AppRoutes.transactions,
        name: AppRoutes.transactions,
        pageBuilder: (context, state) => customTransition(state: state, child: const TransactionListPage()),
      ),
      GoRoute(
        path: AppRoutes.sendMoney,
        name: AppRoutes.sendMoney,
        pageBuilder: (context, state) {
          final user = state.extra as UserEntity;
          return customTransition(state: state, child: SendMoneyPage(currentUser: user));
        },
      ),
      ShellRoute(
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
      ),
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
