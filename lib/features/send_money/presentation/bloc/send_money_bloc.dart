import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:digital_wallet/core/utils/helper/validator.dart';
import 'package:digital_wallet/features/send_money/domain/use_case/send_money_use_case.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_event.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  final SendMoneyUseCase _sendMoneyUseCase;

  SendMoneyBloc(this._sendMoneyUseCase) : super(const SendMoneyInitState()) {
    on<AccountNoChangedEvent>(_onAccountChange);
    on<AmountChangedEvent>(_onAmountChange);
    on<SendMoneyRequestEvent>(_onSendMoneyRequested);
  }

  FutureOr<void> _onAccountChange(AccountNoChangedEvent event, Emitter<SendMoneyState> emit) {
    String accountNoValidationError = InputValidator.validateAccountNumber(event.accountNo) ?? '';
    if (accountNoValidationError.isNotEmpty) {
      emit(SendMoneyValidationFailedState(accountNoError: accountNoValidationError, validAccount: false));
    } else if (accountNoValidationError.isEmpty) {
      emit(SendMoneyValidationFailedState(accountNoError: accountNoValidationError, validAccount: true));
    }
  }

  FutureOr<void> _onAmountChange(AmountChangedEvent event, Emitter<SendMoneyState> emit) {
    String amountValidationError = InputValidator.validateAmount(event.amount) ?? '';
    if (amountValidationError.isNotEmpty) {
      emit(SendMoneyValidationFailedState(accountNoError: amountValidationError, validAmount: false));
    } else if (amountValidationError.isEmpty) {
      emit(SendMoneyValidationFailedState(accountNoError: amountValidationError, validAmount: true));
    }
  }

  Future<void> _onSendMoneyRequested(SendMoneyRequestEvent event, Emitter<SendMoneyState> emit) async {
    emit(const SendMoneyLoadingState());
    final result = await _sendMoneyUseCase(
      SendMoneyParams(receiverAccount: event.receiverAcc, amount: event.amount, currentBalance: event.currBalance, note: event.note),
    );
    result.fold(
      (failure) => emit(SendMoneyErrorState(message: failure.message)),
      (entity) => emit(SendMoneySuccessState(entity: entity)),
    );
  }
}
