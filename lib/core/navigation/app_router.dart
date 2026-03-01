import 'package:digital_wallet/features/auth/domain/entities/user_entity.dart';
import 'package:digital_wallet/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wallet/features/auth/presentation/pages/splash_screen.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_bloc.dart';
import 'package:digital_wallet/features/send_money/presentation/pages/send_money_page.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/pages/transaction_list_page.dart';
import 'package:digital_wallet/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// final GoRouter appRouter = GoRouter(
//   routes: [
//     GoRoute(
//       path: AppRoutes.SPLASH_SCREEN,
//       name: AppRoutes.SPLASH_SCREEN,
//       pageBuilder: (context, state) => customTransition(state: state, child: const LoginPage()),
//     ),
//     GoRoute(
//       path: AppRoutes.SIGNIN_SCREEN,
//       name: AppRoutes.SIGNIN_SCREEN,
//       pageBuilder: (context, state) => customTransition(state: state, child: const LoginPage()),
//     ),
//     GoRoute(
//       path: AppRoutes.DASHBOARD_SCREEN,
//       name: AppRoutes.DASHBOARD_SCREEN,
//       pageBuilder: (context, state) => customTransition(state: state, child: const DashboardPage()),
//     ),
//     // GoRoute(
//     //   path: AppRoutes.SEND_MONEY_SCREEN,
//     //   name: AppRoutes.SEND_MONEY_SCREEN,
//     //   pageBuilder: (context, state) => customTransition(state: state, child: const SendMoneyPage(currentUser: )),
//     // ),
//     GoRoute(
//       path: AppRoutes.TRANSECTION_SCREEN,
//       name: AppRoutes.TRANSECTION_SCREEN,
//       pageBuilder: (context, state) => customTransition(state: state, child: const TransactionListPage()),
//     ),
//   ],
// );

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // set false in production
    initialLocation: AppRoutes.splash,
    routes: [
      // ── Splash ────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => _buildFadePage(
          state,
          const SplashScreen(),
        ),
      ),

      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        pageBuilder: (context, state) => _buildSlidePage(
          state,
          const LoginPage(),
        ),
      ),

      // ── Shell: routes that share DashboardBloc + TransactionBloc ──────────
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
            pageBuilder: (context, state) => _buildFadePage(
              state,
              const DashboardPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.transactions,
            name: AppRoutes.transactions,
            pageBuilder: (context, state) => _buildSlidePage(
              state,
              const TransactionListPage(),
            ),
          ),
        ],
      ),

      // ── Send Money (own BLoC scope) ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.sendMoney,
        name: AppRoutes.sendMoney,
        pageBuilder: (context, state) {
          final user = state.extra as UserEntity;
          return _buildSlidePage(
            state,
            BlocProvider<SendMoneyBloc>(
              create: (_) => sl<SendMoneyBloc>(),
              child: SendMoneyPage(currentUser: user),
            ),
          );
        },
      ),
    ],

    // ── Error page ────────────────────────────────────────────────────────────
    errorPageBuilder: (context, state) => MaterialPage(
      child: _RouterErrorPage(error: state.error),
    ),
  );

  // ── Page transition helpers ──────────────────────────────────────────────

  /// Fade transition — used for top-level screen switches (splash → login).
  static CustomTransitionPage _buildFadePage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  /// Slide-up transition — used for detail / sub-screens.
  static CustomTransitionPage _buildSlidePage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondary, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

// ── Internal error widget ─────────────────────────────────────────────────────
class _RouterErrorPage extends StatelessWidget {
  final Exception? error;
  const _RouterErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image_outlined,
                  size: 56, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Page not found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.goNamed(AppRoutes.splash),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
