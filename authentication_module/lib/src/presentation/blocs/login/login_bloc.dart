import 'package:formz/formz.dart';
import 'package:th_core/th_core.dart';
import 'package:example_dependencies/example_dependencies.dart';

import 'login_event.dart';
import 'login_state.dart';
import '../../../domain/email_input.dart';
import '../../../domain/data_input.dart';
import '../../../domain/domain.dart';

class LoginBloc extends THBaseBloc<LoginEvent, LoginState> {
  LoginBloc(this._signInUseCase, this._fetchProfileUseCase)
      : super(const LoginState()) {
    on<LoginSubmitEvent>(_onSubmit);
    on<UserNameChangedEvent>(_onUserNameChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
  }

  final SignInUseCase _signInUseCase;
  final FetchProfileUseCase _fetchProfileUseCase;

  void _fetchProfile() async {
    final failureOrUser = await _fetchProfileUseCase.call(NoParams());
    failureOrUser.fold(
        (failure) => pageCubit.add(
            THShowErrorOverlayState(message: failure.message ?? tr("unknown"))), (user) {
      GetIt.I.get<AppBloc>().add(AuthenticationStatusChangedEvent(user: user));
      pageCubit.add(THInitialState());
    });
  }

  void _onSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    pageCubit.add(THShowLoadingOverlayState()); //Show loading

    final failureOrAuthenticated = await _signInUseCase.call(
        AuthenticationParams(
            email: state.email.value, password: state.password.value));
    failureOrAuthenticated.fold(
      (failure) => pageCubit
          .add(THShowErrorOverlayState(message: failure.message ?? tr("unknown"))),
      //Show error
      (signedIn) {
        _fetchProfile();
      },
    );
  }

  void _onUserNameChanged(
      UserNameChangedEvent event, Emitter<LoginState> emit) async {
    final email = EmailInput.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void _onPasswordChanged(
      PasswordChangedEvent event, Emitter<LoginState> emit) async {
    final password = DataInput.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    ));
  }
}
