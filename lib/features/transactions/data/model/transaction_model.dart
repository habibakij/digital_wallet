import 'dart:convert';

// class TransactionModel extends TransactionEntity {
//   const TransactionModel({
//     super.userId,
//     super.id,
//     super.title,
//     super.completed,
//   });
//
//   factory TransactionModel.fromJson(Map<String, dynamic> json) {
//     return TransactionModel(
//       userId: json['userId'] ?? 0,
//       id: json['id'] ?? 0,
//       title: json['title']?.toString() ?? '',
//       completed: json['completed'] ?? false,
//     );
//   }
// }

List<TransactionModel> transactionModelFromJson(String str) => List<TransactionModel>.from(json.decode(str).map((x) => TransactionModel.fromJson(x)));

String transactionModelToJson(List<TransactionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionModel {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  TransactionModel({
    this.userId,
    this.id,
    this.title,
    this.completed,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
