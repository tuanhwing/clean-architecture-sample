
import 'package:th_core/th_core.dart';

///abstract [THPageState] used to build loading/error/init state
abstract class THPageState extends Equatable {
  ///Constructor
  const THPageState();

  @override
  List<Object?> get props => <Object?>[];
}

///[THInitialState] represents first or normal state
class THInitialState extends THPageState {}

/// [THFetchInProgressState] represents fetch in progress state
class THFetchInProgressState extends THPageState {}

/// [THFetchSuccessState] represents fetch successful state
class THFetchSuccessState extends THPageState {}

/// [THFetchFailureState] represents fetch failure state
class THFetchFailureState extends THPageState {
  ///Constructor
  const THFetchFailureState({this.errorMessage, this.titleButton}) : super();

  ///Message
  final String? errorMessage;
  ///Title button
  final String? titleButton;

  @override
  List<Object?> get props => <Object?>[errorMessage, titleButton];
}

/// [THShowErrorOverlayState] represents error state
class THShowErrorOverlayState extends THPageState {
  ///Constructor
  const THShowErrorOverlayState(this.message) : super();

  ///Message
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// [THShowLoadingState] represents loading state
class THShowLoadingOverlayState extends THPageState {}
