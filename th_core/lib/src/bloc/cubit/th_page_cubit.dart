
import 'package:th_core/th_core.dart';

import 'th_page_state.dart' as th;

///abstract [THPageCubit] used to manage state of page
class THPageCubit extends Cubit<THPageState> {
  ///Constructor
  THPageCubit() : super(th.THInitialState());

  ///Emit state
  void add(THPageState state) => emit(state);
}
