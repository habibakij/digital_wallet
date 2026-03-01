// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/token_storage.dart';
import 'features/auth/domain/entities/user_entity.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/send_money/presentation/bloc/send_money_bloc.dart';
import 'features/send_money/presentation/pages/send_money_page.dart';
import 'features/transactions/presentation/bloc/transaction_bloc.dart';
import 'features/transactions/presentation/pages/transaction_list_page.dart';
import 'injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation for fintech app security
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await configureDependencies();
  runApp(const DigitalWalletApp());
}

class DigitalWalletApp extends StatelessWidget {
  const DigitalWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => sl<DashboardBloc>()),
        BlocProvider<TransactionBloc>(create: (_) => sl<TransactionBloc>()),
      ],
      child: MaterialApp(
        title: 'Digital Wallet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const _SplashRouter());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<DashboardBloc>()),
              BlocProvider.value(value: sl<TransactionBloc>()),
            ],
            child: const DashboardPage(),
          ),
        );
      case '/send-money':
        final user = settings.arguments as UserEntity?;
        if (user == null) return null;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<SendMoneyBloc>(),
            child: SendMoneyPage(currentUser: user),
          ),
        );
      case '/transactions':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<TransactionBloc>(),
            child: const TransactionListPage(),
          ),
        );
      default:
        return null;
    }
  }
}

/// Checks auth state and routes accordingly
class _SplashRouter extends StatefulWidget {
  const _SplashRouter();

  @override
  State<_SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<_SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    final isAuthenticated = await sl.get<TokenStorage>().hasValidSession();
    if (!mounted) return;
    if (isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 72,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Digital Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Secure • Fast • Reliable',
                style: TextStyle(color: Colors.white60, fontSize: 14, letterSpacing: 2),
              ),
              SizedBox(height: 60),
              CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
            ],
          ),
        ),
      ),
    );
  }
}
