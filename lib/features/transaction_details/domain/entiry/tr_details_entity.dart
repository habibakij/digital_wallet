class TrDetailsEntity {
  final String id;
  final double amount;
  final double fee;
  final String fromAccount;
  final String toAccount;
  final DateTime date;
  final String status;
  final String? note;
  final bool isCredit;

  TrDetailsEntity({
    required this.id,
    required this.amount,
    required this.fee,
    required this.fromAccount,
    required this.toAccount,
    required this.date,
    required this.status,
    required this.isCredit,
    this.note,
  });
}
