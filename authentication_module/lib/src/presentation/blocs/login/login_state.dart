
import 'package:formz/formz.dart';
import 'package:th_core/th_core.dart';

import '../../../domain/email_input.dart';
import '../../../domain/data_input.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.email = const EmailInput.pure(),
    this.password = const DataInput.pure(),
  });

  final FormzStatus status;
  final EmailInput email;
  final DataInput password;

  LoginState copyWith({
    FormzStatus? status,
    EmailInput? email,
    DataInput? password
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password
    );
  }

  @override
  List<Object> get props => [status, email, password];
}

class LoginInProgressState extends LoginState {}

class LoginSuccessfulState extends LoginState {}
