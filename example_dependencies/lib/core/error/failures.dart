
import 'package:th_core/th_core.dart';

///Failure
abstract class Failure extends Equatable {
  ///Constructor
  const Failure({this.message});
  ///Message
  final String? message;

  @override
  List<Object?> get props => <Object?>[message];
}

///ServerFailure
class ServerFailure extends Failure {
  ///Constructor
  const ServerFailure({String? message}) : super(message: message);
}

///CacheFailure
class CacheFailure extends Failure {
  ///Constructor
  const CacheFailure({String? message}) : super(message: message);
}

///InternalFailure
class InternalFailure extends Failure {
  ///Constructor
  const InternalFailure({String? message}) : super(message: message);
}