
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.code, required this.name});
  final String code;
  final String name;

  @override
  List<Object?> get props => [code, name];
}