import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:digital_wallet/features/dashboard/presentation/widget/dashboard_header.dart';
import 'package:digital_wallet/features/dashboard/presentation/widget/error_retry_widget.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/empty_transaction.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_header.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_list_skeleton.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_retry.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  void _loadData({bool forceRefresh = false}) {
    context.read<DashboardBloc>().add(DashboardLoadRequested(forceRefresh: forceRefresh));
    context.read<TransactionBloc>().add(FetchTransactions(forceRefresh: forceRefresh));
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryLiteColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, dashState) {
                final bloc = context.read<DashboardBloc>();
                if (dashState is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.white));
                } else if (dashState is DashboardError) {
                  return ErrorRetryWidget(message: dashState.message, onRetry: () => bloc.add(const DashboardLoadRequested()));
                } else if (dashState is DashboardLoaded) {
                  return DashboardHeader(currentUser: dashState.user);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Expanded(
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
                            padding: const EdgeInsets.symmetric(horizontal: 0.0).copyWith(bottom: 16.0),
                            itemCount: recent.length,
                            itemBuilder: (context, index) => TransactionItem(isCredit: index % 2 == 0),
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
}
