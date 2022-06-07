


import 'package:dartz/dartz.dart';
import 'package:th_core/th_core.dart';

import "../../error/error.dart";

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}