import 'package:flutter_test/flutter_test.dart';

import 'dao/person_dao.dart';
import 'database/test_database.dart';
import 'entity/person_entity.dart';

void main() {
  group('database tests', () {
    late TestDatabase database;
    late PersonDao personDao;

    setUp(() async {
      database = await $FloorTestDatabase
          .inMemoryDatabaseBuilder()
          .build();
      personDao = database.personDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('find person by id', () async {
      final person = Person(1, 'Simon');
      await personDao.insertPerson(person);

      final actual = personDao.findPersonById(person.id);
      final firstPerson = await actual.first;

      expect(firstPerson?.id, equals(1));
    });
  });
}
