
import 'package:equatable/equatable.dart';

import 'phone.dart';

///User
class User extends Equatable {
  ///Constructor
  const User({required this.id, required this.name, required this.phone});

  ///Id
  final String id;
  ///Name
  final String name;
  ///Phone
  final Phone phone;

  @override
  List<Object?> get props => <Object?>[id, name, phone];
}