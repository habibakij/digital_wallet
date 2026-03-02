import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int? userId;
  final int? id;
  final String? title;
  final bool? completed;

  const TransactionEntity({this.userId, this.id, this.title, this.completed});

  @override
  List<Object?> get props => [userId, id, title, completed];
}
