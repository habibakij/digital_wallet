import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.referenceNumber,
    required super.type,
    required super.status,
    required super.amount,
    required super.balanceAfter,
    super.senderName,
    super.senderAccount,
    super.receiverName,
    super.receiverAccount,
    super.note,
    required super.createdAt,
    super.failureReason,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      referenceNumber: json['reference_number']?.toString() ?? '',
      type: _parseType(json['type']?.toString()),
      status: _parseStatus(json['status']?.toString()),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      senderName: json['sender_name']?.toString(),
      senderAccount: json['sender_account']?.toString(),
      receiverName: json['receiver_name']?.toString(),
      receiverAccount: json['receiver_account']?.toString(),
      note: json['note']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now(),
      failureReason: json['failure_reason']?.toString(),
    );
  }

  static TransactionType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'send':
        return TransactionType.send;
      case 'receive':
        return TransactionType.receive;
      case 'top_up':
        return TransactionType.topUp;
      case 'withdrawal':
        return TransactionType.withdrawal;
      default:
        return TransactionType.send;
    }
  }

  static TransactionStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return TransactionStatus.completed;
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      case 'reversed':
        return TransactionStatus.reversed;
      default:
        return TransactionStatus.pending;
    }
  }
}
