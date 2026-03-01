import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/helper/formatters.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/bloc/transaction_event.dart';
import '../../../transactions/presentation/bloc/transaction_state.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

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
      backgroundColor: AppTheme.backgroundColor,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, dashState) {
          if (dashState is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dashState is DashboardError) {
            return _buildError(dashState.message);
          }
          if (dashState is DashboardLoaded) {
            return _buildContent(dashState.user);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(UserEntity user) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const DashboardLoadRequested());
        context.read<TransactionBloc>().add(const RefreshTransactions());
      },
      color: AppTheme.primaryColor,
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(user),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildTransactionHeader(),
              ]),
            ),
          ),
          _buildTransactionList(),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(UserEntity user) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildBalanceCard(user),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          onPressed: () => _showProfileMenu(),
        ),
        const SizedBox(width: 8),
      ],
      title: const Text(
        'DigitalWallet',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBalanceCard(UserEntity user) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hello, ${user.name.split(' ').first} 👋',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (user.isKycVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppTheme.accentColor, width: 0.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified,
                              size: 12, color: AppTheme.accentColor),
                          SizedBox(width: 4),
                          Text(
                            'KYC Verified',
                            style: TextStyle(
                                color: AppTheme.accentColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Balance card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available Balance',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () => setState(
                              () => _balanceVisible = !_balanceVisible),
                          child: Icon(
                            _balanceVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _balanceVisible
                          ? Text(
                              CurrencyFormatter.format(user.balance),
                              key: const ValueKey('visible'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            )
                          : const Text(
                              '৳ ••••••',
                              key: ValueKey('hidden'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Account: ${user.accountNumber}',
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.send_rounded,
          label: 'Send',
          color: const Color(0xFF4CAF50),
          onTap: () => Navigator.of(context).pushNamed('/send-money').then((_) {
            context.read<DashboardBloc>().add(const DashboardLoadRequested());
          }),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.add_rounded,
          label: 'Top Up',
          color: const Color(0xFF2196F3),
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.history_rounded,
          label: 'History',
          color: const Color(0xFF9C27B0),
          onTap: () => Navigator.of(context).pushNamed('/transactions'),
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.more_horiz_rounded,
          label: 'More',
          color: const Color(0xFFFF9800),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed('/transactions'),
          child: const Text(
            'See All',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => const _TransactionSkeleton(),
              childCount: 4,
            ),
          );
        }
        if (state is TransactionEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: _EmptyTransactions(),
            ),
          );
        }
        if (state is TransactionLoaded) {
          final recent = state.transactions.take(5).toList();
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => TransactionTile(
                  transaction: recent[index],
                ),
                childCount: recent.length,
              ),
            ),
          );
        }
        if (state is TransactionError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(state.message,
                  style: const TextStyle(color: AppTheme.errorColor)),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 48),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context
                .read<DashboardBloc>()
                .add(const DashboardLoadRequested()),
            child: const Text('Retry'),
          ),
        ],
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
            const Text('Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorColor),
              title: const Text('Logout',
                  style: TextStyle(color: AppTheme.errorColor)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(const LogoutRequested());
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

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.dividerColor, width: 0.5),
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
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionSkeleton extends StatelessWidget {
  const _TransactionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 120, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                Container(height: 10, width: 80, color: Colors.grey.shade100),
              ],
            ),
          ),
          Container(height: 14, width: 60, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long_outlined,
            size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        const Text(
          'No transactions yet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your transaction history will appear here',
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
