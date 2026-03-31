import 'package:bloc/bloc.dart';
import 'package:digital_wallet/features/send_money/domain/use_case/send_money_use_case.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_event.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_state.dart';

class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  final SendMoneyUseCase _sendMoneyUseCase;

  SendMoneyBloc(this._sendMoneyUseCase) : super(const SendMoneyInitial()) {
    on<SendMoneyRequested>(_onSendMoneyRequested);
    on<SendMoneyReset>(_onReset);
  }

  Future<void> _onSendMoneyRequested(SendMoneyRequested event, Emitter<SendMoneyState> emit) async {
    emit(const SendMoneyLoading());

    final result = await _sendMoneyUseCase(
      SendMoneyParams(
        receiverAccount: event.receiverAccount,
        amount: event.amount,
        currentBalance: event.currentBalance,
        note: event.note,
      ),
    );
    result.fold(
      (failure) => emit(SendMoneyError(message: failure.message)),
      (transfer) => emit(SendMoneySuccess(transfer: transfer)),
    );
  }

  void _onReset(SendMoneyReset event, Emitter<SendMoneyState> emit) {
    emit(const SendMoneyInitial());
  }
}
