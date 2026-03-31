import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/core/theme/app_style.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final bool isCredit;
  const TransactionItem({super.key, this.isCredit = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isCredit ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      size: 16,
                      isCredit ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: isCredit ? AppColors.green : AppColors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${isCredit ? "+" : "-"}${_formatCurrency(45888.50)}",
                        style: AppTextStyles.regular(
                          fontWeight: FontWeight.bold,
                          color: isCredit ? AppColors.green : AppColors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Acc: ${_maskAccount("1000254545485")}",
                            style: AppTextStyles.regular(fontSize: 12),
                          ),
                          Text(
                            //DateFormat("dd MMM yyyy").format(DateTime.now()),
                            DateFormatter.formatTransaction(DateTime.now().subtract(Duration(days: isCredit ? 1 : 2))),
                            style: AppTextStyles.regular(fontSize: 12, color: AppColors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Txn ID: 454848585156",
                        style: AppTextStyles.regular(fontSize: 11, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 6.0,
            right: 16.0,
            child: isCredit ? _buildStatusChip(TransactionStatus.success) : _buildStatusChip(TransactionStatus.failed),
          ),
        ],
      ),
    );
  }

  String _maskAccount(String acc) {
    if (acc.length < 4) return acc;
    return "**** **** ${acc.substring(acc.length - 4)}";
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_BD',
      symbol: '৳',
      decimalDigits: 2,
    ).format(amount);
  }

  Widget _buildStatusChip(TransactionStatus status) {
    Color color;
    String text;
    switch (status) {
      case TransactionStatus.success:
        color = AppColors.green;
        text = "Success";
        break;
      case TransactionStatus.pending:
        color = AppColors.warningColor;
        text = "Pending";
        break;
      case TransactionStatus.failed:
        color = AppColors.red;
        text = "Failed";
        break;
    }
    return Container(
      height: 20.0,
      width: 74.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(8.0), bottomLeft: Radius.circular(4.0)),
      ),
      child: Text(
        text,
        style: AppTextStyles.regular(fontSize: 12, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

Map<String, List<TransactionModel>> groupTransactions(List<TransactionModel> list) {
  Map<String, List<TransactionModel>> grouped = {};
  for (var tx in list) {
    String key = _getDateGroup(tx.date);

    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }
    grouped[key]!.add(tx);
  }
  return grouped;
}

String _getDateGroup(DateTime date) {
  final now = DateTime.now();

  if (_isSameDay(date, now)) return "Today";
  if (_isSameDay(date, now.subtract(const Duration(days: 1)))) return "Yesterday";

  return DateFormat("dd MMM yyyy").format(date);
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Widget buildTransactionList(List<TransactionModel> transactions) {
  final grouped = groupTransactions(transactions);

  return ListView(
    children: grouped.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ...entry.value.map((tx) => const TransactionItem(isCredit: false)),
        ],
      );
    }).toList(),
  );
}

enum TransactionStatus { success, pending, failed }

class TransactionModel {
  final String id;
  final double amount;
  final String accountNo;
  final DateTime date;
  final bool isCredit;
  final TransactionStatus status;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.accountNo,
    required this.date,
    required this.isCredit,
    required this.status,
  });
}
