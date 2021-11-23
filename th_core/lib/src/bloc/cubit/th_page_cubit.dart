
import 'package:th_core/th_core.dart';

import 'th_page_states.dart';

///abstract [THPageCubit] used to manage state of page
class THPageCubit extends Cubit<THPageState> {
  ///Constructor
  THPageCubit() : super(THNone());

  ///Emit state
  void add(THPageState state) => emit(state);
}
