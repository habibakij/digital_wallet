import 'package:equatable/equatable.dart';

class TransferEntity extends Equatable {
  final String transactionId;
  final String referenceNumber;
  final String receiverName;
  final String receiverAccount;
  final double amount;
  final double newBalance;
  final String? note;
  final DateTime timestamp;

  const TransferEntity({
    required this.transactionId,
    required this.referenceNumber,
    required this.receiverName,
    required this.receiverAccount,
    required this.amount,
    required this.newBalance,
    this.note,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [transactionId, referenceNumber];
}
