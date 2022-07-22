
import 'package:example_dependencies/example_dependencies.dart';

class SettingsState extends Equatable {
  const SettingsState({this.count = 0});

  final int count;

  SettingsState copyWith({
    int? count,
  }) {
    return SettingsState(
        count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [count];
}