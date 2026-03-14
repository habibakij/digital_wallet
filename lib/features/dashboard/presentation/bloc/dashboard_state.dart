import 'package:digital_wallet/features/dashboard/domain/entity/current_user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final CurrentUserEntity user;
  const DashboardLoaded({required this.user});
  @override
  List<Object> get props => [user];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
  @override
  List<Object> get props => [message];
}
