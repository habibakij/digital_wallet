import '../../domain/entities/transfer_entity.dart';

class TransferModel extends TransferEntity {
  const TransferModel({
    required super.transactionId,
    required super.referenceNumber,
    required super.receiverName,
    required super.receiverAccount,
    required super.amount,
    required super.newBalance,
    super.note,
    required super.timestamp,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      transactionId: json['transaction_id']?.toString() ?? '',
      referenceNumber: json['reference_number']?.toString() ?? '',
      receiverName: json['receiver_name']?.toString() ?? '',
      receiverAccount: json['receiver_account']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      newBalance: (json['new_balance'] as num?)?.toDouble() ?? 0.0,
      note: json['note']?.toString(),
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'].toString()) : DateTime.now(),
    );
  }
}
