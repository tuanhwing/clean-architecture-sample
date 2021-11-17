
import 'package:th_core/th_core.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends THBaseBloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegisterSubmitEvent>(_onSubmit);
  }

  void _onSubmit(RegisterSubmitEvent event, Emitter<RegisterState> emit) async {
    pageCubit.add(THError(tr("feature_not_available")));
  }
}