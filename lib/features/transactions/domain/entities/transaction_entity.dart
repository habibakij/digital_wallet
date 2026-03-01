import 'package:equatable/equatable.dart';

enum TransactionType { send, receive, topUp, withdrawal }

enum TransactionStatus { pending, completed, failed, reversed }

class TransactionEntity extends Equatable {
  final String id;
  final String referenceNumber;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final double balanceAfter;
  final String? senderName;
  final String? senderAccount;
  final String? receiverName;
  final String? receiverAccount;
  final String? note;
  final DateTime createdAt;
  final String? failureReason;

  const TransactionEntity({
    required this.id,
    required this.referenceNumber,
    required this.type,
    required this.status,
    required this.amount,
    required this.balanceAfter,
    this.senderName,
    this.senderAccount,
    this.receiverName,
    this.receiverAccount,
    this.note,
    required this.createdAt,
    this.failureReason,
  });

  bool get isCredit => type == TransactionType.receive || type == TransactionType.topUp;

  bool get isDebit => type == TransactionType.send || type == TransactionType.withdrawal;

  @override
  List<Object?> get props => [id, referenceNumber, status];
}
