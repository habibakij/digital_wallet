import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {
  final bool forceRefresh;
  const DashboardLoadRequested({this.forceRefresh = false});
}

class DashboardBalanceUpdated extends DashboardEvent {
  final double newBalance;
  const DashboardBalanceUpdated({required this.newBalance});
  @override
  List<Object> get props => [newBalance];
}
