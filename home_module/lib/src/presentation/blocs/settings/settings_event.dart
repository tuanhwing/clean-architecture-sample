
import 'package:th_core/th_core.dart';

///Abstract setting event
abstract class SettingsEvent extends Equatable {
  ///Constructor
  const SettingsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

///SettingInitializationEvent
class SettingInitializationEvent extends SettingsEvent {
  ///Constructor
  const SettingInitializationEvent();
}

///SettingInitializationErrorEvent
class SettingInitializationErrorEvent extends SettingsEvent {
  ///Constructor
  const SettingInitializationErrorEvent();
}
