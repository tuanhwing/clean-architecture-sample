
import 'package:th_core/th_core.dart';
import 'package:example_dependencies/example_dependencies.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends THBaseBloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._logoutUseCase) : super(const SettingsState()) {
    on<LogoutEvent>(_onLogout);
  }

  final LogoutUseCase _logoutUseCase;

  void _onLogout(LogoutEvent event, Emitter<SettingsState> emit) async {
    pageCubit.add(THLoading());
    final failureOrLoggedOut = await _logoutUseCase.invoke(NoParams());
    failureOrLoggedOut.fold(
      (failure) => pageCubit.add(THError(failure.message ?? tr("unknown"))),//Show error
      (loggedOut) {
        GetIt.I.get<AppBloc>().add(const AuthenticationStatusChangedEvent());
      },
    );
  }
}
