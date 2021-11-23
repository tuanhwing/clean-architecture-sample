
import 'package:th_local_database/th_local_database.dart';

@entity
class Person {
  @primaryKey
  final int id;
  final String name;

  Person(this.id, this.name);
}