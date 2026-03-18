import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_event.dart';
import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/empty_transaction.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_header.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_list_skeleton.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_retry.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _balanceVisible = true;

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardLoadRequested());
    context.read<TransactionBloc>().add(const FetchTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, dashState) {
                final bloc = context.read<DashboardBloc>();
                if (dashState is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.white));
                } else if (dashState is DashboardError) {
                  return _buildError(bloc, dashState.message);
                } else if (dashState is DashboardLoaded) {
                  return _buildContent(bloc, dashState.user);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, trState) {
                if (trState is TransactionLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    itemCount: 10,
                    itemBuilder: (context, index) => const TransactionSkeleton(),
                  );
                } else if (trState is TransactionEmpty) {
                  return const EmptyTransactions();
                } else if (trState is TransactionLoaded) {
                  final recent = trState.transactionList.take(10).toList();
                  return Column(
                    children: [
                      const SizedBox(height: 12),
                      const TransactionHeader(),
                      Expanded(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(color: AppColors.backgroundColor),
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16.0),
                            itemCount: recent.length,
                            itemBuilder: (context, index) =>
                                TransactionTile(entity: trState.transactionList[index]),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (trState is TransactionError) {
                  return TransactionRetry(
                    message: trState.message,
                    onTab: () {
                      context.read<TransactionBloc>().add(const FetchTransactions());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DashboardBloc bloc, CurrentUserEntity user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0)
              .copyWith(top: MediaQuery.of(context).padding.top),
          child: Row(
            children: [
              Text(
                'Digital Wallet',
                style: AppTextStyles.title(color: AppColors.white70),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: CircleAvatar(
                  radius: 16.0,
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: NetworkImage(user.avatar ?? ''),
                ),
                onPressed: () => _showProfileMenu(),
              ),
            ],
          ),
        ),
        _buildBalanceCard(user),
        const SizedBox(height: 12),
        _horizontalQuickActions(),
      ],
    );
  }

  Widget _buildBalanceCard(CurrentUserEntity user) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, ${user.name?.split(' ').first} 👋',
                  style: AppTextStyles.regular(color: AppColors.greyShade300, fontSize: 16),
                ),
                const Spacer(),
                if (user.isKycVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentColor, width: 0.5),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified, size: 12, color: AppColors.accentColor),
                        SizedBox(width: 4),
                        Text(
                          'KYC Verified',
                          style: TextStyle(color: AppColors.accentColor, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.white.withValues(alpha: 0.2), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Balance',
                        style: AppTextStyles.regular(color: AppColors.whiteLiteColor),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                        child: Icon(
                          _balanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.whiteLiteColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    reverseDuration: const Duration(milliseconds: 0),
                    child: _balanceVisible
                        ? Text(
                            CurrencyFormatter.format(user.balance ?? 0),
                            key: const ValueKey('visible'),
                            style: AppTextStyles.title(
                              color: AppColors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          )
                        : Text(
                            '৳ ••••••••••••',
                            key: const ValueKey('hidden'),
                            style: AppTextStyles.title(
                              color: AppColors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.regular(color: AppColors.whiteLiteColor, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Account: ',
                          style:
                              AppTextStyles.regular(color: AppColors.whiteLiteColor, fontSize: 12),
                        ),
                        TextSpan(
                          text: user.accountNumber,
                          style: AppTextStyles.regular(
                              color: AppColors.whiteLiteColor, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 8.0,
        children: [
          _ActionButton(
            icon: Icons.send_rounded,
            label: 'Send',
            color: const Color(0xFF4CAF50),
            onTap: () {
              context.goNamed(AppRoutes.sendMoney);
            },
          ),
          _ActionButton(
            icon: Icons.add_rounded,
            label: 'Top Up',
            color: const Color(0xFF2196F3),
            onTap: () {},
          ),
          _ActionButton(
            icon: Icons.history_rounded,
            label: 'History',
            color: const Color(0xFF9C27B0),
            onTap: () => Navigator.of(context).pushNamed('/transactions'),
          ),
          _ActionButton(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            color: const Color(0xFFFF9800),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildError(DashboardBloc bloc, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.errorColor, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => bloc.add(const DashboardLoadRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Profile',
                style: AppTextStyles.regular(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            const Divider(color: AppColors.greyLite),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.errorColor),
              title: const Text('Logout', style: TextStyle(color: AppColors.errorColor)),
              onTap: () {
                Navigator.pop(context);
                context.read<SignInBloc>().add(const LogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.dividerColor, width: 0.5),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
