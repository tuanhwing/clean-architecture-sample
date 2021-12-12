
import 'package:th_core/th_core.dart';

///abstract [THPageState] used to build loading/error/init state
abstract class THPageState extends Equatable {
  ///Constructor
  const THPageState();

  @override
  List<Object?> get props => <Object?>[];
}

///[THNone] represents first or normal state
class THNone extends THPageState {}

/// [THPageLoading] represents loading state
class THLoading extends THPageState {}

/// [THError] represents error state
class THError extends THPageState {
  ///Constructor
  const THError(this.message) : super();

  ///Message
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
