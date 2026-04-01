import 'package:digital_wallet/features/transaction_details/domain/entiry/tr_details_entity.dart';

class TrDetailsModel extends TrDetailsEntity {
  TrDetailsModel({
    required super.id,
    required super.amount,
    required super.fee,
    required super.fromAccount,
    required super.toAccount,
    required super.date,
    required super.status,
    super.note,
    required super.isCredit,
  });

  factory TrDetailsModel.fromJson(Map<String, dynamic> json) {
    return TrDetailsModel(
      id: json['id']?.toString() ?? '',
      amount: json['amount'] ?? 0,
      fee: json['fee'] ?? 0,
      fromAccount: json['fromAccount']?.toString() ?? '',
      toAccount: json['toAccount']?.toString() ?? '',
      date: json['date'] ?? 0,
      status: json['status']?.toString() ?? '',
      note: json['note']?.toString(),
      isCredit: json['isCredit'] ?? false,
    );
  }
}
