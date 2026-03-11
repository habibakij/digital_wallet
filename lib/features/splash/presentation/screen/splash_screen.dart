import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:digital_wallet/features/splash/presentation/screen/build_app_name.dart';
import 'package:digital_wallet/features/splash/presentation/screen/build_tag_name.dart';
import 'package:digital_wallet/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));
    _animController.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    if (!mounted) return;
    final isAuthenticated = await sl<SecureStorageService>().hasValidSession();
    if (!mounted) return;
    if (isAuthenticated) {
      context.goNamed(AppRoutes.dashboard);
    } else {
      context.goNamed(AppRoutes.signIn);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashEnd) {
            _checkAuthAndNavigate();
          }
        },
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 20),
                      const BuildAppName(),
                      const SizedBox(height: 8),
                      const BuildTagName(),
                      const SizedBox(height: 64),
                      _buildLoader(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.3), width: 1.5),
      ),
      child: const Icon(Icons.account_balance_wallet_rounded, size: 52, color: AppColors.white),
    );
  }

  Widget _buildLoader() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(color: AppColors.grey, strokeWidth: 2),
    );
  }
}
