
import 'dart:ui';

import 'package:th_core/th_core.dart';

import 'app_event.dart';
import 'app_state.dart';

///AppBloc
class AppBloc extends THBaseBloc<AppEvent, AppState> {
  ///Constructor
  AppBloc() : super(const AppState()) {
    on<AuthenticationStatusChangedEvent>(_onAuthenticationStatusChanged);
    on<UserProfileUpdatedEvent>(_onUserInfoChanged);
    on<AppInitialEvent>(_onAppInitial);
  }

  ///Get list of locale
  List<Locale> get locales =>
      state.languages.map((String e) => Locale(e)).toList();

  ///Authentication status changed
  void _onAuthenticationStatusChanged(
      AuthenticationStatusChangedEvent event, Emitter<AppState> emit) {
    emit(AppState(user: event.user, isLoggedIn: event.isLoggedIn));
  }

  ///User info update
  void _onUserInfoChanged(
      UserProfileUpdatedEvent event, Emitter<AppState> emit) {
    emit(AppState(user: event.user, isLoggedIn: state.isLoggedIn));
  }

  ///App initial
  void _onAppInitial(
      AppInitialEvent event, Emitter<AppState> emit) {
    emit(AppState(isLoggedIn: event.isLoggedIn));
  }
}
