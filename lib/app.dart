import 'package:digital_wallet/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'injection/injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SplashCubit>()..startSplash()),
        BlocProvider<SignInBloc>(create: (_) => sl<SignInBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Digital Wallet',
        debugShowCheckedModeBanner: false,
        theme: const AppTheme(TextTheme()).light(),
        darkTheme: const AppTheme(TextTheme()).dark(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
