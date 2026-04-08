import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

class DashboardBalanceUpdated extends DashboardEvent {
  final double newBalance;
  const DashboardBalanceUpdated({required this.newBalance});
  @override
  List<Object> get props => [newBalance];
}
