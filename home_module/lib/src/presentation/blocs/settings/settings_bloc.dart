
import 'package:example_dependencies/example_dependencies.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends THBaseBloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._logoutUseCase) : super(const SettingsState()) {
    on<LogoutEvent>(_onLogout);
    on<SettingInitializationEvent>(_onInitialization);
    on<SettingInitializationErrorEvent>(_onInitializationError);

    pageCubit.add(THFetchInProgressState());
  }

  final LogoutUseCase _logoutUseCase;

  void _onLogout(LogoutEvent event, Emitter<SettingsState> emit) async {
    pageCubit.add(THShowLoadingOverlayState());
    await Future.delayed(const Duration(seconds: 2));
    final failureOrLoggedOut = await _logoutUseCase.call(NoParams());
    failureOrLoggedOut.fold(
      (failure) => pageCubit.add(THShowErrorOverlayState(message: failure.message ?? tr("unknown"))),//Show error
      (loggedOut) {
        GetIt.I.get<AppBloc>().add(const AuthenticationStatusChangedEvent());
      },
    );
  }

  void _onInitialization(SettingInitializationEvent event, Emitter<SettingsState> emit) async {
    pageCubit.add(THInitialState());
    pageCubit.add(THFetchInProgressState());

    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(count: state.count + 1));
    pageCubit.add(THFetchSuccessState());
  }

  void _onInitializationError(SettingInitializationErrorEvent event, Emitter<SettingsState> emit) async {
    pageCubit.add(THInitialState());
    pageCubit.add(THFetchInProgressState());

    await Future.delayed(const Duration(seconds: 2));
    pageCubit.add(const THFetchFailureState());
  }
}
