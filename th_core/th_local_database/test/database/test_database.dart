
// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


import '../dao/daos.dart';
import '../entity/entities.dart';

part 'test_database.g.dart';

@Database(version: 1, entities: [Person])
abstract class TestDatabase extends FloorDatabase {
  PersonDao get personDao;
}