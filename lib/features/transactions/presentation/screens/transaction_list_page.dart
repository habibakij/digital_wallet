import 'package:digital_wallet/core/navigation/app_routes.dart';
import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/widget/common_app_bar.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/empty_transaction.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_list_skeleton.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_retry.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const FetchTransactions());

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TransactionBloc>().add(const LoadMoreTransactions());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
          title: "Transaction History",
          titleStyle: AppTextStyles.title(color: AppColors.white),
          onLeadingTab: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed(AppRoutes.dashboard);
            }
          }),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 16.0),
              itemCount: 10,
              itemBuilder: (context, index) => const TransactionSkeleton(),
            );
          }
          if (state is TransactionEmpty) {
            return const EmptyTransactions();
          }
          if (state is TransactionError) {
            return TransactionRetry(
              message: state.message,
              onTab: () {
                context.read<TransactionBloc>().add(const FetchTransactions());
              },
            );
          }
          if (state is TransactionLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(const RefreshTransactions());
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppColors.primaryColor,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: state.transactionList.length,
                      itemBuilder: (context, index) {
                        if (index == state.transactionList.length - 1) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primaryColor, strokeWidth: 2),
                            ),
                          );
                        }
                        return TransactionTile(entity: state.transactionList[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
