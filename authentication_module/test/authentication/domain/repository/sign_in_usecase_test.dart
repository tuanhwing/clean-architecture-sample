
import 'dart:async';

import 'package:authentication_module/src/data/data.dart';
import 'package:authentication_module/src/domain/domain.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRemoteRepository extends Mock implements AuthenticationRepositoryImpl {
  @override
  Future<Either<Failure, bool>> signInWith(String email, password) async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
      Invocation.method(#signInWith, ['email', 'password']),
      returnValue: Future.value(resultValue)
    );
  }
}

void main() {

  late MockAuthenticationRemoteRepository _authenticationRepoImpl;
  late SignInUseCase _signInUseCase;

  setUp(() {
    _authenticationRepoImpl = MockAuthenticationRemoteRepository();
    _signInUseCase = SignInUseCase(_authenticationRepoImpl);
  });

  void setUpMockAuthenticationRepositorySuccess() {
    when(_authenticationRepoImpl.signInWith('email', 'password'))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
  }

  void setUpMockAuthenticationServerFailure() {
    when(_authenticationRepoImpl.signInWith('email', 'password'))
        .thenAnswer((_) async => const Left(ServerFailure()));
  }

  void setUpMockAuthenticationInternalFailure() {
    when(_authenticationRepoImpl.signInWith('email', 'password'))
        .thenAnswer((_) async => const Left(InternalFailure()));
  }

  group('[use case] Authentication', () {

    test('should return Right<Failure, bool> when the response authentication_remote_repository is signed in (success)', () async {

      // arrange
      setUpMockAuthenticationRepositorySuccess();

      final failureOrUser = await _signInUseCase.invoke(
        const AuthenticationParams(
          email: 'email',
          password: 'password'
        )
      );
      expect(failureOrUser, const Right<Failure, bool>(true));
    });

    test('should return Left<Failure, bool> [ServerFailure] when the response authentication_remote_repository is failure (failed)', () async {

      // arrange
      setUpMockAuthenticationServerFailure();

      final failureOrUser = await _signInUseCase.invoke(
          const AuthenticationParams(
              email: 'email',
              password: 'password'
          )
      );

      expect(failureOrUser, const Left<Failure, bool>(ServerFailure()));
    });

    test('should return Left<Failure, bool> [InternalFailure] when the response authentication_remote_repository is failure (internal failed)', () async {

      // arrange
      setUpMockAuthenticationInternalFailure();

      final failureOrUser = await _signInUseCase.invoke(
          const AuthenticationParams(
              email: 'email',
              password: 'password'
          )
      );

      expect(failureOrUser, const Left<Failure, bool>(InternalFailure()));
    });
  });
}
