
import 'package:dartz/dartz.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const UserModel _user = UserModel(code: 'code', name: 'name');

class MockUserRepository extends Mock implements UserRepositoryImpl {
  @override
  Future<Either<Failure, User>> fetchProfile() async {
    Right<Failure, User> resultValue = const Right<Failure, User>(_user);
    return super.noSuchMethod(
      Invocation.method(#fetchProfile, [],),
      returnValue: resultValue
    );
  }
}

void main() {

  late MockUserRepository _repository;
  late FetchProfileUseCase _useCase;

  setUp(() {
    _repository = MockUserRepository();
    _useCase = FetchProfileUseCase(_repository);
  });

  void setUpMockFetchProfileSuccess() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Right<Failure, User>(_user));
  }

  void setUpMockFetchProfileServerFailure() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Left(ServerFailure()));
  }

  void setUpMockFetchProfileCacheFailure() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Left(CacheFailure()));
  }

  void setUpMockFetchProfileInternalFailure() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Left(InternalFailure()));
  }

  group('[use_case] Fetch Profile', () {
    test('should return User object when fetch profile info success', () async {
      //arrange
      setUpMockFetchProfileSuccess();

      final user = await _useCase.invoke(NoParams());
      expect(user, const Right<Failure, User>(_user));
    });

    test('should return ServerFailure when server\'s response failed', () async {
      //arrange
      setUpMockFetchProfileServerFailure();

      final failure = await _useCase.invoke(NoParams());
      expect(failure, const Left<Failure, bool>(ServerFailure()));
    });

    test('should return CacheFailure when caching data failed', () async {
      //arrange
      setUpMockFetchProfileCacheFailure();

      final failure = await _useCase.invoke(NoParams());
      expect(failure, const Left<Failure, bool>(CacheFailure()));
    });

    test('should return InternalFailure when something went wrong', () async {
      //arrange
      setUpMockFetchProfileInternalFailure();

      final failure = await _useCase.invoke(NoParams());
      expect(failure, const Left<Failure, bool>(InternalFailure()));
    });
  });
}