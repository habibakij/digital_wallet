import 'package:digital_wallet/features/dashboard/domain/use_cases/dashboard_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCase _dashboardUseCase;
  double toolbarHeight = 0.0;

  DashboardBloc(this._dashboardUseCase) : super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardBalanceUpdated>(_onBalanceUpdated);
  }

  Future<void> _onLoadRequested(DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    final result = await _dashboardUseCase.getCurrentUser();
    emit(DashboardLoaded(user: result));
  }

  void _onBalanceUpdated(DashboardBalanceUpdated event, Emitter<DashboardState> emit) {
    emit(const DashboardLoading());
    final current = state;
    if (current is DashboardLoaded) {
      emit(DashboardLoaded(user: current.user.copyWith(balance: event.newBalance)));
    }
  }
}
