import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widgets/transaction_tile.dart';

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
    _scrollController.addListener(_onScroll);
    final state = context.read<TransactionBloc>().state;
    if (state is! TransactionLoaded) {
      context.read<TransactionBloc>().add(const FetchTransactions());
    }
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Transaction History'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.white12),
        ),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is TransactionEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your transactions will appear here once\nyou start sending or receiving money.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<TransactionBloc>().add(const FetchTransactions()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is TransactionLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionBloc>().add(const RefreshTransactions());
                // Wait for refresh to complete
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  _buildHeader(state),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: state.transactions.length + (state.isPaginating ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.transactions.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }
                        return TransactionTile(
                          transaction: state.transactions[index],
                        );
                      },
                    ),
                  ),
                  if (state.paginationError != null) _buildPaginationError(state.paginationError!),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(TransactionLoaded state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            '${state.totalCount} Transactions',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          if (!state.hasNextPage && state.transactions.isNotEmpty)
            Text(
              'Showing all',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaginationError(String error) {
    return Container(
      color: AppTheme.errorColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Failed to load more: $error',
              style: const TextStyle(fontSize: 12, color: AppTheme.errorColor),
            ),
          ),
          TextButton(
            onPressed: () => context.read<TransactionBloc>().add(const LoadMoreTransactions()),
            child: const Text('Retry', style: TextStyle(fontSize: 12, color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }
}
