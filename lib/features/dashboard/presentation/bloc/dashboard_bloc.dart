import 'package:digital_wallet/features/auth/sign_in/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AuthRepository _authRepository;

  DashboardBloc(this._authRepository) : super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardBalanceUpdated>(_onBalanceUpdated);
  }

  Future<void> _onLoadRequested(DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (user) => emit(DashboardLoaded(user: user)),
    );
  }

  void _onBalanceUpdated(DashboardBalanceUpdated event, Emitter<DashboardState> emit) {
    final current = state;
    if (current is DashboardLoaded) {
      emit(DashboardLoaded(user: current.user.copyWith(balance: event.newBalance)));
    }
  }
}
