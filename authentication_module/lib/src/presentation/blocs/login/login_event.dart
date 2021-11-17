
import 'package:th_core/th_core.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override

  List<Object?> get props => [];
}

class LoginSubmitEvent extends LoginEvent {
  const LoginSubmitEvent() : super();
}

class UserNameChangedEvent extends LoginEvent {
  const UserNameChangedEvent(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordChangedEvent extends LoginEvent {
  const PasswordChangedEvent(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}
