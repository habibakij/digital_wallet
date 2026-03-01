import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection/injection.dart';
import 'core/navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _globalProviders(),
      child: MaterialApp.router(
        title: 'Digital Wallet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }

  /// Only truly global BLoCs belong here.
  /// [AuthBloc] is global because auth state can change from any screen.
  List<BlocProvider> _globalProviders() {
    return [
      BlocProvider<AuthBloc>(
        create: (_) => sl<AuthBloc>(),
      ),
    ];
  }
}
