
import 'package:authentication_module/data/data.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {
  @override
  Future<String> signIn(String? dialCode, String? phone) {
    return super.noSuchMethod(
        Invocation.method(#signIn, <dynamic>['dialCode', 'phone']),
        returnValue: Future<String>.value('verification_id'));
  }
}

class MockAuthenticationLocalDataSource extends Mock
    implements AuthenticationLocalDataSource {}

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
    when(_remoteDataSource.signIn('dialCode', 'phone'))
        .thenAnswer((_) async => 'verification_id'
    );
  }

  void setUpMockAuthenticationServerFailure() {
    when(_remoteDataSource.signIn('dialCode', 'phone'))
        .thenThrow(const ServerException()
    );
  }

  group('[repositories] Authentication', () {
    test(
        'should return true when the response authentication_remote '
            'is signed in (success)',
        () async {
      // arrange
      setUpMockAuthenticationSuccess();

      final Either<Failure, String> failureOrUser =
          await _authenticationRepoImpl.signIn('dialCode', 'phone');
      expect(failureOrUser, const Right<Failure, bool>(true));
    });

    test(
        'should return ServerFailure when the response authentication_remote '
            'is failed',
        () async {
      // arrange
      setUpMockAuthenticationServerFailure();

      final Either<Failure, String> failureOrUser =
          await _authenticationRepoImpl.signIn('dialCode', 'phone');
      expect(failureOrUser, const Left<Failure, bool>(ServerFailure()));
    });
  });

}