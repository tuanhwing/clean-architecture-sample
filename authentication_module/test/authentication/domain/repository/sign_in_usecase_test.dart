
import 'package:authentication_module/data/data.dart';
import 'package:authentication_module/domain/domain.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRemoteRepository extends Mock
    implements AuthenticationRepositoryImpl {
  @override
  Future<Either<Failure, String>> signIn(
      String email, String password) async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
      Invocation.method(#signInWith, <dynamic>['email', 'password']),
      returnValue: Future<Either<Failure, bool>> .value(resultValue)
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
    when(_authenticationRepoImpl.signIn('email', 'password'))
        .thenAnswer((_) async => const Right<Failure, String>('id'));
  }

  void setUpMockAuthenticationServerFailure() {
    when(_authenticationRepoImpl.signIn('email', 'password'))
        .thenAnswer((_) async => const Left<Failure, String>(ServerFailure()));
  }

  void setUpMockAuthenticationInternalFailure() {
    when(_authenticationRepoImpl.signIn('email', 'password')).thenAnswer(
        (_) async => const Left<Failure, String>(InternalFailure()));
  }

  group('[use case] Authentication', () {

    test('should return Right<Failure, bool> when the response '
        'authentication_remote_repository is signed in (success)', () async {

      // arrange
      setUpMockAuthenticationRepositorySuccess();

      final Either<Failure, String> failureOrUser = await _signInUseCase.call(
        const AuthenticationParams(
          dialCode: 'dialCode',
          phone: 'phone'
        )
      );
      expect(failureOrUser, const Right<Failure, bool>(true));
    });

    test(
        'should return Left<Failure, bool> [ServerFailure] when the response '
        'authentication_remote_repository is failure (failed)', () async {
      // arrange
      setUpMockAuthenticationServerFailure();

      final Either<Failure, String> failureOrUser = await _signInUseCase.call(
          const AuthenticationParams(
              dialCode: 'dialCode',
              phone: 'phone'
          )
      );

      expect(failureOrUser, const Left<Failure, bool>(ServerFailure()));
    });

    test(
        'should return Left<Failure, bool> [InternalFailure] when the response'
        ' authentication_remote_repository is failure (internal failed)',
        () async {
      // arrange
      setUpMockAuthenticationInternalFailure();

      final Either<Failure, String> failureOrUser = await _signInUseCase.call(
          const AuthenticationParams(
            dialCode: 'dialCode',
            phone: 'phone'
          )
      );

      expect(failureOrUser, const Left<Failure, bool>(InternalFailure()));
    });
  });
}
