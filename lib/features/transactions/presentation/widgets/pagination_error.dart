import 'package:digital_wallet/core/theme/app_theme.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationError extends StatelessWidget {
  final String error;
  const PaginationError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.errorColor.withValues(alpha: 0.1),
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
