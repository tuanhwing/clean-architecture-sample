
import 'dart:convert';

import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSharedPreference extends Mock implements SharedPreferences {
  @override
  String? getString(String key) {
    return super.noSuchMethod(
      Invocation.method(#getString, <dynamic>[key]),
      returnValue: json.encode(_userJson)
    );
  }
}

const Map<String, dynamic> _userJson = <String, dynamic>{
  'code': 'code',
  'name': 'name'
};

void main() {
  MockSharedPreference _sharedPreference = MockSharedPreference();
  late UserLocalDataSource _userLocalDataSource;

  setUp(() {
    _userLocalDataSource = UserLocalDataSourceImpl(_sharedPreference);
  });

  void setUpMockCachedData() {
    String? jsonString = json.encode(_userJson);
    when(_sharedPreference.getString(_userLocalDataSource.profileKey))
        .thenReturn(jsonString);
  }

  void setUpMockCacheException() {
    when(_sharedPreference.getString(_userLocalDataSource.profileKey))
        .thenThrow(const CacheException());
  }

  group('[data_source] user local', () {
    test('should return UserModel object when '
        'get cached data from shared_preference', () async {
      //arrange
      setUpMockCachedData();

      final User user = await _userLocalDataSource.getCachedUser();

      // assert
      expect(user, isNotNull);
      expect(user.id, _userJson['code']);
      expect(user.name, _userJson['name']);
    });

    test('should return CacheException when '
        'get cached data with error', () async {
      //arrange
      setUpMockCacheException();

      final Function() call = _userLocalDataSource.getCachedUser;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}
