import 'package:example_dependencies/example_dependencies.dart';

import 'settings_event.dart';
import 'settings_state.dart';

///Setting bloc
class SettingsBloc extends THBaseBloc<SettingsEvent, SettingsState> {
  ///Constructor
  SettingsBloc() : super(const SettingsState()) {
    on<SettingInitializationEvent>(_onInitialization);
    on<SettingInitializationErrorEvent>(_onInitializationError);

    // forceLoadingWidget();
  }



  void _onInitialization(
      SettingInitializationEvent event, Emitter<SettingsState> emit) async {

    forceLoadingWidget();

    await Future<void>.delayed(const Duration(seconds: 2));
    emit(state.copyWith(count: state.count + 1));
    forceContentWidget();
  }

  void _onInitializationError(SettingInitializationErrorEvent event,
      Emitter<SettingsState> emit) async {
    // pageCubit.add(THInitialState());
    // pageCubit.add(THFetchInProgressState());
    forceLoadingWidget();

    await Future<void>.delayed(const Duration(seconds: 2));
    forceErrorWidget();
    // pageCubit.add(const THFetchFailureState());
  }
}
