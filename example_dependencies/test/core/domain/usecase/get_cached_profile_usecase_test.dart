
import 'package:dartz/dartz.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const UserModel _user = UserModel(code: 'code', name: 'name');

class MockUserRepository extends Mock implements UserRepositoryImpl {
  @override
  Future<Either<Failure, User>> getCachedProfile() async {
    Right<Failure, User> resultValue = const Right<Failure, User>(_user);
    return super.noSuchMethod(
      Invocation.method(#getCachedProfile, []),
      returnValue: resultValue
    );
  }
}

void main() {
  late UserRepository _repository;
  late GetCachedProfileUseCase _useCase;

  setUp(() {
    _repository = MockUserRepository();
    _useCase = GetCachedProfileUseCase(_repository);
  });

  void setUpMockCachedProfileSuccess() {
    when(_repository.getCachedProfile())
        .thenAnswer((_) async => const Right<Failure, User>(_user));
  }

  void setUpMockCachedProfileCacheFailure() {
    when(_repository.getCachedProfile())
        .thenAnswer((_) async => const Left(CacheFailure()));
  }

  void setUpMockCachedProfileInternalFailure() {
    when(_repository.getCachedProfile())
        .thenAnswer((_) async => const Left(InternalFailure()));
  }

  group('[use_case] Get cached profile', () {
    test('should return User object when get cached profile info success', () async {
      //arrange
      setUpMockCachedProfileSuccess();

      final user = await _useCase.call(NoParams());
      expect(user, const Right<Failure, User>(_user));
    });

    test('should return CacheFailure when caching data failed', () async {
      //arrange
      setUpMockCachedProfileCacheFailure();

      final failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(CacheFailure()));
    });

    test('should return InternalFailure when something went wrong', () async {
      //arrange
      setUpMockCachedProfileInternalFailure();

      final failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(InternalFailure()));
    });
  });
}