// lib/features/transactions/presentation/widgets/transaction_tile.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildIcon(),
        title: Text(
          _buildTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              DateFormatter.formatTransaction(transaction.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            if (transaction.note != null && transaction.note!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  transaction.note!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.isCredit ? '+' : '-'}${CurrencyFormatter.formatSimple(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: transaction.isCredit
                    ? AppTheme.accentColor
                    : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (transaction.type) {
      case TransactionType.send:
        icon = Icons.arrow_upward_rounded;
        bgColor = const Color(0xFFFFEBEE);
        iconColor = const Color(0xFFE53935);
        break;
      case TransactionType.receive:
        icon = Icons.arrow_downward_rounded;
        bgColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF43A047);
        break;
      case TransactionType.topUp:
        icon = Icons.add_card_outlined;
        bgColor = const Color(0xFFE3F2FD);
        iconColor = const Color(0xFF1E88E5);
        break;
      case TransactionType.withdrawal:
        icon = Icons.account_balance_outlined;
        bgColor = const Color(0xFFFFF8E1);
        iconColor = const Color(0xFFFFB300);
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String label;

    switch (transaction.status) {
      case TransactionStatus.completed:
        color = AppTheme.accentColor;
        label = 'Completed';
        break;
      case TransactionStatus.pending:
        color = AppTheme.warningColor;
        label = 'Pending';
        break;
      case TransactionStatus.failed:
        color = AppTheme.errorColor;
        label = 'Failed';
        break;
      case TransactionStatus.reversed:
        color = AppTheme.textSecondary;
        label = 'Reversed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _buildTitle() {
    switch (transaction.type) {
      case TransactionType.send:
        return 'To ${transaction.receiverName ?? transaction.receiverAccount ?? 'Unknown'}';
      case TransactionType.receive:
        return 'From ${transaction.senderName ?? transaction.senderAccount ?? 'Unknown'}';
      case TransactionType.topUp:
        return 'Wallet Top Up';
      case TransactionType.withdrawal:
        return 'Bank Withdrawal';
    }
  }
}
