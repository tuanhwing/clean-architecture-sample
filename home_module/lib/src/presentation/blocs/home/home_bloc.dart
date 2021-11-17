
import 'package:th_core/th_core.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends THBaseBloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState());

}
