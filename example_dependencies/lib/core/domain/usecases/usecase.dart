


import 'package:dartz/dartz.dart';
import 'package:th_core/th_core.dart';

import '../../error/error.dart';

///abstract class UseCase
abstract class UseCase<Type, Params> {
  ///call function
  Future<Either<Failure, Type>> call(Params params);
}

///NoParams
class NoParams extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}