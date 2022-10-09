
import 'package:th_core/th_core.dart';

///Abstract class phone verification event
abstract class CodeVerificationEvent extends Equatable {
  ///Constructor
  const CodeVerificationEvent();

  @override

  List<Object?> get props => <Object?>[];
}

///TimerStarted
class TimerStarted extends CodeVerificationEvent {
  ///Constructor
  const TimerStarted();
}

///TimerTicked
class TimerTicked extends CodeVerificationEvent {
  ///Constructor
  const TimerTicked({required this.duration});

  ///duration
  final int duration;
}

///ResendCodeVerificationEvent
class ResendCodeVerificationEvent extends CodeVerificationEvent {
  ///Constructor
  const ResendCodeVerificationEvent() : super();
}

///Submit form event
class CodeVerificationSubmitEvent extends CodeVerificationEvent {
  ///Constructor
  const CodeVerificationSubmitEvent(
      {required this.pin, required this.verificationID})
      : super();

  ///Value of pin code
  final String pin;
  ///verificationID
  final String verificationID;
}
