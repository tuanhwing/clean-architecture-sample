
import 'package:dartz/dartz.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {
  @override
  Future<Either<Failure, bool>> logout() async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
      Invocation.method(#logout, []),
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
        .thenAnswer((_) async => const Left(ServerFailure()));
  }

  void setUpMockLogoutCacheFailure() {
    when(_repository.logout())
        .thenAnswer((_) async => const Left(CacheFailure()));
  }

  void setUpMockLogoutInternalFailure() {
    when(_repository.logout())
        .thenAnswer((_) async => const Left(InternalFailure()));
  }

  group('[use_case] Logout', () {
    test('should return true when logout success', () async {
      //arrange
      setUpMockLogoutSuccess();

      final user = await _useCase.invoke(NoParams());
      expect(user, const Right<Failure, bool>(true));
    });

    test('should return ServerFailure when server\'s response failed', () async {
      //arrange
      setUpMockLogoutServerFailure();

      final failure = await _useCase.invoke(NoParams());
      expect(failure, const Left<Failure, bool>(ServerFailure()));
    });

    test('should return CacheFailure when caching data failed', () async {
      //arrange
      setUpMockLogoutCacheFailure();

      final failure = await _useCase.invoke(NoParams());
      expect(failure, const Left<Failure, bool>(CacheFailure()));
    });

    test('should return InternalFailure when something went wrong', () async {
      //arrange
      setUpMockLogoutInternalFailure();

      final failure = await _useCase.invoke(NoParams());
      expect(failure, const Left<Failure, bool>(InternalFailure()));
    });
  });
}