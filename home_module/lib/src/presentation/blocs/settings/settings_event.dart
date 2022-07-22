
import 'package:th_core/th_core.dart';

abstract class SettingsEvent extends Equatable {

  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LogoutEvent extends SettingsEvent {
  const LogoutEvent();
}

class SettingInitializationEvent extends SettingsEvent {
  const SettingInitializationEvent();
}

class SettingInitializationErrorEvent extends SettingsEvent {
  const SettingInitializationErrorEvent();
}
