import 'package:digital_wallet/core/constants/app_constants.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'features/splash/presentation/bloc/splash_cubit.dart';
import 'injection/injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SplashCubit>()),
        BlocProvider<SignInBloc>(create: (_) => sl<SignInBloc>()),
        BlocProvider<DashboardBloc>(create: (_) => sl<DashboardBloc>()),
        BlocProvider<TransactionBloc>(create: (_) => sl<TransactionBloc>()),
      ],
      child: MaterialApp.router(
        scaffoldMessengerKey: AppConstants.scaffoldMessengerKey,
        title: 'Digital Wallet',
        debugShowCheckedModeBanner: false,
        theme: const AppTheme(TextTheme()).light(),
        darkTheme: const AppTheme(TextTheme()).dark(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
