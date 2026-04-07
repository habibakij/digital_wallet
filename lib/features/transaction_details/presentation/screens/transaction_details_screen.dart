import 'package:digital_wallet/core/utils/widget/app_button.dart';
import 'package:digital_wallet/features/transaction_details/data/model/tr_details_model.dart';
import 'package:digital_wallet/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatelessWidget {
  final TrDetailsModel tx;
  const TransactionDetailsPage({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Transaction Details"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTopCard(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  title: "Transaction Info",
                  children: [
                    _buildTile("Transaction ID", tx.id, copy: true),
                    _buildTile("Date", _formatDateTime(tx.date)),
                    _buildTile("Status", tx.status),
                  ],
                ),
                _buildSection(
                  title: "Account Info",
                  children: [
                    _buildTile("From", _mask(tx.fromAccount)),
                    _buildTile("To", _mask(tx.toAccount)),
                  ],
                ),
                _buildSection(
                  title: "Payment Info",
                  children: [
                    _buildTile("Amount", _formatCurrency(tx.amount)),
                    _buildTile("Fee", _formatCurrency(tx.fee)),
                    _buildTile(
                      "Total",
                      _formatCurrency(tx.amount + tx.fee),
                      isBold: true,
                    ),
                  ],
                ),
                if (tx.note != null && tx.note!.isNotEmpty)
                  _buildSection(
                    title: "Note",
                    children: [
                      _buildTile("Message", tx.note!),
                    ],
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: AppButton(
        title: 'Download Receipt',
        height: 52,
        borderRadius: 14,
        onPressed: () {},
      ),
    );
  }

  Widget _buildTopCard() {
    final isCredit = tx.isCredit;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              //color: _statusColor(tx.status).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(tx.status as TransactionStatus),
              //color: _statusColor(tx.status),
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "${isCredit ? "+" : "-"}${_formatCurrency(tx.amount)}",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tx.status,
            style: TextStyle(
              //color: _statusColor(tx.status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          ...children,
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTile(String title, String value, {bool isBold = false, bool copy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w500),
              ),
              if (copy)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.copy, size: 16),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_BD', symbol: '৳').format(amount);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat("dd MMM yyyy, hh:mm a").format(date);
  }

  String _mask(String acc) {
    if (acc.length < 4) return acc;
    return "**** **** ${acc.substring(acc.length - 4)}";
  }

  Color _statusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
    }
  }

  IconData _statusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.success:
        return Icons.check;
      case TransactionStatus.pending:
        return Icons.access_time;
      case TransactionStatus.failed:
        return Icons.close;
    }
  }
}
