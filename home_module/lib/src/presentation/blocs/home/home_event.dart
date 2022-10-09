
import 'package:th_core/th_core.dart';

///HomeEvent
abstract class HomeEvent extends Equatable {
  ///Constructor
  const HomeEvent();

  @override
  List<Object?> get props => <Object?>[];
}

///FetchProfileEvent
class FetchProfileEvent extends HomeEvent {
  ///Constructor
  const FetchProfileEvent();
}

///LogoutEvent
class LogoutEvent extends HomeEvent {
  ///Constructor
  const LogoutEvent();
}
