
import 'package:th_core/th_core.dart';

///Code verification state
class CodeVerificationState extends Equatable {
  ///Constructor
  const CodeVerificationState(this.duration);

  ///Count down value to resend verification code
  final int duration;

  ///Return new instance and copy all value not in params
  CodeVerificationState copyWith({
    int? duration,
  }) {
    return CodeVerificationState(
     duration ?? this.duration
    );
  }

  @override
  List<Object?> get props => <Object?>[duration];
}

///TimerRunInProgress
class TimerRunInProgress extends CodeVerificationState {
  ///Constructor
  const TimerRunInProgress(int duration) : super(duration);
}

///TimerRunComplete
class TimerRunComplete extends CodeVerificationState {
  ///Constructor
  const TimerRunComplete() : super(0);
}
