import 'package:intl/intl.dart';

class AppHelper {
  static String formatTransaction(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today ${DateFormat('hh:mm a').format(date)}';
    if (diff.inDays == 1) return 'Yesterday ${DateFormat('hh:mm a').format(date)}';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);
  static String formatTime(DateTime date) => DateFormat('hh:mm a').format(date);

  String formatTimer(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$sec';
  }

  static final NumberFormat _formatter = NumberFormat.currency(symbol: '৳ ', decimalDigits: 2, locale: 'en_BD');

  static String format(double amount) => _formatter.format(amount);
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '৳ ${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '৳ ${(amount / 1000).toStringAsFixed(2)}K';
    }
    return format(amount);
  }

  static String formatSimple(double amount) {
    return '৳ ${amount.toStringAsFixed(2)}';
  }
}
