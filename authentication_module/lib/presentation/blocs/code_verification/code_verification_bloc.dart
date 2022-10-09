import 'dart:async';

import 'package:authentication_module/domain/domain.dart';
import 'package:example_dependencies/example_dependencies.dart';

import 'code_verification_event.dart';
import 'code_verification_state.dart';

///CodeVerificationBloc
class CodeVerificationBloc
    extends THBaseBloc<CodeVerificationEvent, CodeVerificationState> {
  ///Constructor
  CodeVerificationBloc(this._verifyCodeUseCase)
      : super(const CodeVerificationState(_duration)) {
    _ticker = const Ticker();
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<ResendCodeVerificationEvent>(_onResend);
    on<CodeVerificationSubmitEvent>(_onSubmit);
  }

  static const int _duration = 10;
  StreamSubscription<int>? _tickerSubscription;
  late final Ticker _ticker;
  final VerifyCodeUseCase _verifyCodeUseCase;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<CodeVerificationState> emit) {
    emit(state.copyWith(duration: _duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: _duration)
        .listen((int duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<CodeVerificationState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }

  void _onResend(
      ResendCodeVerificationEvent event, Emitter<CodeVerificationState> emit) {
    add(const TimerStarted());
  }

  void _onSubmit(CodeVerificationSubmitEvent event,
      Emitter<CodeVerificationState> emit) async {
    if (event.pin.length == 6) {
      showLoading();//Show loading

      final Either<Failure, bool> failureOrVerified =
          await _verifyCodeUseCase.call(CodeVerificationParams(
              verificationID: event.verificationID, code: event.pin));

      failureOrVerified.fold(
          (Failure failure) =>
              showError(message: failure.message ?? tr('unknown')),
        (bool verified) => GetIt.I.get<AppBloc>().add(
            const AuthenticationStatusChangedEvent(isLoggedIn: true)),
      );
      hideLoading();//Hide loading
    }
  }
}


///Ticker
class Ticker {
  ///Constructor
  const Ticker();

  ///Tick
  Stream<int> tick({required int ticks}) {
    return Stream<int>.periodic(
        const Duration(seconds: 1), (int x) => ticks - x - 1).take(ticks);
  }
}
