
import 'package:th_core/th_core.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends THBaseBloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AuthenticationStatusChangedEvent>(_onAuthenticationStatusChanged);
  }

  ///Authentication status changed
  void _onAuthenticationStatusChanged(AuthenticationStatusChangedEvent event, Emitter<AppState> emit) {
    emit(AppState(user: event.user));
  }
}
