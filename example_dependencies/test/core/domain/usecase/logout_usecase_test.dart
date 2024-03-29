
import 'package:dartz/dartz.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<Either<Failure, bool>> logout() async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
      Invocation.method(#logout, <dynamic>[]),
      returnValue: resultValue
    );
  }
}

void main() {
  late UserRepository _repository;
  late LogoutUseCase _useCase;

  setUp(() {
    _repository = MockUserRepository();
    _useCase = LogoutUseCase(_repository);
  });

  void setUpMockLogoutSuccess() {
    when(_repository.logout())
        .thenAnswer((_) async => const Right<Failure, bool>(true));
  }

  void setUpMockLogoutServerFailure() {
    when(_repository.logout())
        .thenAnswer((_) async => const Left<Failure, bool>(ServerFailure()));
  }

  void setUpMockLogoutCacheFailure() {
    when(_repository.logout())
        .thenAnswer((_) async => const Left<Failure, bool>(CacheFailure()));
  }

  void setUpMockLogoutInternalFailure() {
    when(_repository.logout())
        .thenAnswer((_) async => const Left<Failure, bool>(InternalFailure()));
  }

  group('[use_case] Logout', () {
    test('should return true when logout success', () async {
      //arrange
      setUpMockLogoutSuccess();

      final Either<Failure, bool> user = await _useCase.call(NoParams());
      expect(user, const Right<Failure, bool>(true));
    });

    test('should return ServerFailure when server\'s '
        'response failed', () async {
      //arrange
      setUpMockLogoutServerFailure();

      final Either<Failure, bool> failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(ServerFailure()));
    });

    test('should return CacheFailure when caching data failed', () async {
      //arrange
      setUpMockLogoutCacheFailure();

      final Either<Failure, bool> failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(CacheFailure()));
    });

    test('should return InternalFailure when something went wrong', () async {
      //arrange
      setUpMockLogoutInternalFailure();

      final Either<Failure, bool> failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(InternalFailure()));
    });
  });
}