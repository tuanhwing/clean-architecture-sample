
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:th_dependencies/th_dependencies.dart';

import 'cubit/cubit.dart';

///abstract [THBaseBloc] class used to building your bloc
abstract class THBaseBloc<Event, State> extends Bloc<Event, State> {
  ///Constructor
  THBaseBloc(State initialState) : super(initialState) {
    _pageCubit = GetIt.I.get<THPageCubit>();
  }

  late THPageCubit _pageCubit;

  ///Get THPage
  THPageCubit get pageCubit => _pageCubit;

  ///Dispose function
  void dispose() {}
}
