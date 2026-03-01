import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';

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
  final UserEntity user;
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
