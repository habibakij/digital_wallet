import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/utils/widget/error_retry_widget.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:digital_wallet/features/dashboard/presentation/widget/dashboard_header.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/empty_transaction.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_header.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_list_skeleton.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _loadData({onlyDashboardRefresh = false, onlyFetchTransactionList = false}) {
    if (onlyDashboardRefresh && onlyFetchTransactionList) {
      context.read<DashboardBloc>().add(const DashboardLoadRequested());
      context.read<TransactionBloc>().add(const FetchTransactions());
    } else if (onlyDashboardRefresh && !onlyFetchTransactionList) {
      context.read<DashboardBloc>().add(const DashboardLoadRequested());
    } else if (!onlyDashboardRefresh && onlyFetchTransactionList) {
      context.read<TransactionBloc>().add(const FetchTransactions());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(onlyDashboardRefresh: true, onlyFetchTransactionList: true);
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
                if (dashState is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.white));
                } else if (dashState is DashboardError) {
                  return ErrorRetryWidget(
                    message: dashState.message,
                    onRetry: () => _loadData(onlyDashboardRefresh: true),
                  );
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
                    itemCount: 6,
                    itemBuilder: (context, index) => const TransactionSkeleton(),
                  );
                } else if (trState is TransactionEmpty) {
                  return EmptyTransactions(
                    onRetry: () => _loadData(onlyFetchTransactionList: true),
                  );
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
                                const EdgeInsets.symmetric(horizontal: 0.0).copyWith(bottom: 16.0),
                            itemCount: recent.length,
                            itemBuilder: (context, index) =>
                                TransactionItem(isCredit: index % 2 == 0),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (trState is TransactionError) {
                  return ErrorRetryWidget(
                    message: trState.message,
                    onRetry: () => _loadData(onlyFetchTransactionList: true),
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
