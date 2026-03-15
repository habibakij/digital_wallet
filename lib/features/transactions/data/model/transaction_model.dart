import 'package:digital_wallet/features/transactions/domain/entity/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.userId,
    super.id,
    super.title,
    super.completed,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      completed: json['completed'] ?? false,
    );
  }
}
