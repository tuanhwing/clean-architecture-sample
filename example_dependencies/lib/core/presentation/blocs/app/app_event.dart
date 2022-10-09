
import 'package:th_core/th_core.dart';

import '../../../domain/domain.dart';

///AppEvent
abstract class AppEvent extends Equatable {
  ///Constructor
  const AppEvent();

  @override
  List<Object?> get props => <Object?>[];
}

///AuthenticationStatusChangedEvent
class AuthenticationStatusChangedEvent extends AppEvent {
  ///Constructor
  const AuthenticationStatusChangedEvent({this.user, this.isLoggedIn = false})
      : super();
  ///Instance of user
  final User? user;
  ///Flag to detect user is logged in or not
  final bool isLoggedIn;

  @override
  List<Object?> get props => <Object?>[user, isLoggedIn];
}

///UserProfileUpdatedEvent
class UserProfileUpdatedEvent extends AppEvent {
  ///Constructor
  const UserProfileUpdatedEvent({this.user})
      : super();
  ///Instance of user
  final User? user;

  @override
  List<Object?> get props => <Object?>[user];
}

///AppInitialEvent
class AppInitialEvent extends AppEvent {
  ///Constructor
  const AppInitialEvent({required this.isLoggedIn})
      : super();
  ///Whether user is logged in or not
  final bool isLoggedIn;

  @override
  List<Object?> get props => <Object?>[isLoggedIn];
}

///AppInitialEvent
class AppLanguageChangedEvent extends AppEvent {
  ///Constructor
  const AppLanguageChangedEvent({required this.isLoggedIn})
      : super();
  ///Whether user is logged in or not
  final bool isLoggedIn;

  @override
  List<Object?> get props => <Object?>[isLoggedIn];
}
