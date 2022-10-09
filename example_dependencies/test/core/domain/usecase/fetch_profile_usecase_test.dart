
import 'package:dartz/dartz.dart';
import 'package:example_dependencies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

UserModel _user = const UserModel(
    id: 'code',
    name: 'name',
    phoneModel: PhoneModel(
      dialCode: 'dialCode',
      phoneNumber: 'phoneNumber',
      fullPhoneNumber: 'fullPhoneNumber',
    )
);

class MockUserRepository extends Mock implements UserRepositoryImpl {
  @override
  Future<Either<Failure, User>> fetchProfile() async {
    Right<Failure, User> resultValue = Right<Failure, User>(_user);
    return super.noSuchMethod(
      Invocation.method(#fetchProfile, <dynamic>[],),
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
        .thenAnswer((_) async => Right<Failure, User>(_user));
  }

  void setUpMockFetchProfileServerFailure() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Left<Failure, User>(ServerFailure()));
  }

  void setUpMockFetchProfileCacheFailure() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Left<Failure, User>(CacheFailure()));
  }

  void setUpMockFetchProfileInternalFailure() {
    when(_repository.fetchProfile())
        .thenAnswer((_) async => const Left<Failure, User>(InternalFailure()));
  }

  group('[use_case] Fetch Profile', () {
    test('should return User object when fetch profile info success', () async {
      //arrange
      setUpMockFetchProfileSuccess();

      final Either<Failure, User> user = await _useCase.call(NoParams());
      expect(user, Right<Failure, User>(_user));
    });

    test('should return ServerFailure when server\'s '
        'response failed', () async {
      //arrange
      setUpMockFetchProfileServerFailure();

      final Either<Failure, User> failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(ServerFailure()));
    });

    test('should return CacheFailure when caching data failed', () async {
      //arrange
      setUpMockFetchProfileCacheFailure();

      final Either<Failure, User> failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(CacheFailure()));
    });

    test('should return InternalFailure when something went wrong', () async {
      //arrange
      setUpMockFetchProfileInternalFailure();

      final Either<Failure, User> failure = await _useCase.call(NoParams());
      expect(failure, const Left<Failure, bool>(InternalFailure()));
    });
  });
}