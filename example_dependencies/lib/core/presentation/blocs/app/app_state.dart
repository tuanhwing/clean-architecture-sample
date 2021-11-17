
import 'package:th_core/th_core.dart';

import '../../../domain/domain.dart';

class AppState extends Equatable {
  const AppState({this.user});
  final User? user;

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
