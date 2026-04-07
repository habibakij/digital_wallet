import 'package:digital_wallet/features/send_money/domain/entities/send_money_entity.dart';

class SendMoneyModel extends SendMoneyEntity {
  const SendMoneyModel({
    required super.otp,
    required super.transactionId,
    required super.referenceNumber,
    required super.receiverName,
    required super.receiverAccount,
    required super.amount,
    required super.newBalance,
    super.note,
    required super.timestamp,
  });

  factory SendMoneyModel.fromJson(Map<String, dynamic> json) {
    return SendMoneyModel(
      otp: json['otp']?.toString() ?? '',
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

  SendMoneyEntity toEntity() {
    return SendMoneyEntity(
      otp: otp,
      transactionId: transactionId,
      referenceNumber: referenceNumber,
      receiverName: receiverName,
      receiverAccount: receiverAccount,
      amount: amount,
      newBalance: newBalance,
      note: note,
      timestamp: timestamp,
    );
  }
}
