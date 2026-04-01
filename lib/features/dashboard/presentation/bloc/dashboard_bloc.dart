import 'package:digital_wallet/core/theme/app_colors.dart';
import 'package:digital_wallet/features/dashboard/data/model/quick_action_model.dart';
import 'package:digital_wallet/features/dashboard/domain/use_cases/dashboard_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCase _dashboardUseCase;

  DashboardBloc(this._dashboardUseCase) : super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardBalanceUpdated>(_onBalanceUpdated);
  }

  Future<void> _onLoadRequested(DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    if (state is DashboardLoaded && !event.forceRefresh) {
      return;
    }
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

  final quickMenuList = [
    const QuickActionModel(icon: Icons.send_rounded, label: 'Send Money', subtitle: 'Transfer to Mobile Banking', color: AppColors.green),
    const QuickActionModel(icon: Icons.account_balance_rounded, label: 'Fund Transfer', subtitle: 'Transfer to anyone', color: AppColors.deepOrangeColor),
    const QuickActionModel(icon: Icons.add_rounded, label: 'Add Funds', subtitle: 'Add funds to wallet', color: AppColors.primaryColor),
    const QuickActionModel(icon: Icons.money_rounded, label: 'Balance Inquiry', subtitle: 'Add funds to wallet', color: AppColors.cardGradiantColor1),
    const QuickActionModel(icon: Icons.mobile_friendly_rounded, label: 'Top Up', subtitle: 'Add funds to wallet', color: AppColors.cyan),
    const QuickActionModel(icon: Icons.history_rounded, label: 'Mini Statement', subtitle: 'View past transactions', color: AppColors.purple),
    const QuickActionModel(icon: Icons.receipt_long_rounded, label: 'Bill Payments', subtitle: 'Utilities, subscriptions', color: AppColors.orangeColor),
    const QuickActionModel(icon: Icons.qr_code_rounded, label: 'Scan QR', subtitle: 'Pay via QR code', color: AppColors.accentColor),
  ];
}
