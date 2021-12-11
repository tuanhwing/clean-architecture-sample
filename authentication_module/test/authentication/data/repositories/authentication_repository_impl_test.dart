

import 'package:authentication_module/src/data/data.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRemoteDataSource extends Mock implements AuthenticationRemoteDataSource {

  @override
  Future<bool> signIn(String? email, String? password) {
    return super.noSuchMethod(Invocation.method(#signIn, ['email', 'password']), returnValue: Future.value(true));
  }
}

class MockAuthenticationLocalDataSource extends Mock implements AuthenticationLocalDataSource {}

void main() {
  late MockAuthenticationRemoteDataSource _remoteDataSource;
  late MockAuthenticationLocalDataSource _localDataSource;
  late AuthenticationRepositoryImpl _authenticationRepoImpl;

  setUp(() {
    _remoteDataSource = MockAuthenticationRemoteDataSource();
    _localDataSource = MockAuthenticationLocalDataSource();
    _authenticationRepoImpl = AuthenticationRepositoryImpl(
      remoteDataSource: _remoteDataSource,
      localDataSource: _localDataSource,
    );
  });

  void setUpMockAuthenticationSuccess() {
    when(_remoteDataSource.signIn('email', 'password'))
        .thenAnswer((_) async => true
    );
  }

  void setUpMockAuthenticationServerFailure() {
    when(_remoteDataSource.signIn('email', 'password'))
        .thenThrow(const ServerException()
    );
  }

  group('[repositories] Authentication', () {

    test('should return true when the response authentication_remote is signed in (success)', () async {

      // arrange
      setUpMockAuthenticationSuccess();

      final failureOrUser = await _authenticationRepoImpl.signInWith('email', 'password');
      failureOrUser.fold(
        (failure) => expect(failure, true),
        (signedIn) => expect(signedIn, true),
      );
    });

    test('should return ServerFailure when the response authentication_remote is failed', () async {

      // arrange
      setUpMockAuthenticationServerFailure();

      final failureOrUser = await _authenticationRepoImpl.signInWith('email', 'password');
      failureOrUser.fold(
            (failure) => expect(failure, equals(const ServerFailure())),
            (signedIn) => expect(signedIn, equals(const ServerFailure())),
      );
    });
  });

}