
import 'package:th_core/th_core.dart';

import '../../../domain/domain.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStatusChangedEvent extends AppEvent {
  const AuthenticationStatusChangedEvent({this.user}) : super();
  final User? user;

  @override
  List<Object?> get props => [user];
}
