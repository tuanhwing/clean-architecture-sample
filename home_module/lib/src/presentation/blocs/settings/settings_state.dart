
import 'package:example_dependencies/example_dependencies.dart';

///Setting state
class SettingsState extends Equatable {
  ///Constructor
  const SettingsState({this.count = 0});
  ///Count
  final int count;

  ///Return new instance and copy all value not in params
  SettingsState copyWith({
    int? count,
  }) {
    return SettingsState(
        count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => <Object?>[count];
}