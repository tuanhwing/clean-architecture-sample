
import 'package:th_core/th_core.dart';

abstract class Failure extends Equatable {
  const Failure({this.message});
  final String? message;

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({String? message}) : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({String? message}) : super(message: message);
}

class InternalFailure extends Failure {
  const InternalFailure({String? message}) : super(message: message);
}