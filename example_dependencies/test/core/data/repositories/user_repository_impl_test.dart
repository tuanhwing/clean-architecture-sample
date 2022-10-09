
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

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {
  @override
  Future<void> storeUser(UserModel userModel) {
    return super.noSuchMethod(
      Invocation.method(#storeUser, <dynamic>[userModel]),
      returnValue: Future<void>.value()
    );
  }

  @override
  Future<void> clean() {
    return super.noSuchMethod(
        Invocation.method(#clean, <dynamic>[]),
        returnValue: Future<void>.value()
    );
  }

  @override
  Future<UserModel> getCachedUser() {
    return super.noSuchMethod(
      Invocation.method(#getCachedUser, <dynamic>[]),
      returnValue: Future<UserModel>.value(_user)
    );
  }
}

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {
  @override
  Future<UserModel> fetchProfile() {
    return super.noSuchMethod(
      Invocation.method(#fetchProfile, <dynamic>[]),
      returnValue: Future<UserModel>.value(_user)
    );
  }

  @override
  Future<bool> logout() {
    return super.noSuchMethod(
        Invocation.method(#logout, <dynamic>[]),
        returnValue: Future<bool>.value(true)
    );
  }
}

void main() {
  late MockUserLocalDataSource _userLocalDataSource;
  late MockUserRemoteDataSource _userRemoteDataSource;
  late UserRepositoryImpl _userRepository;

  setUp(() {
    _userLocalDataSource = MockUserLocalDataSource();
    _userRemoteDataSource = MockUserRemoteDataSource();
    _userRepository = UserRepositoryImpl(
      localDataSource: _userLocalDataSource,
      remoteDataSource: _userRemoteDataSource
    );

  });

  void setUpMockStoreUserSuccess() {
    when(_userLocalDataSource.storeUser(_user))
        .thenAnswer((_) => Future<void>.value());
  }

  void setUpMockStoreUserFailure() {
    when(_userLocalDataSource.storeUser(_user))
        .thenThrow(const CacheException());
  }

  void setUpMockFetchProfileSuccess() {
    when(_userRemoteDataSource.fetchProfile())
        .thenAnswer((_) async => _user
    );
  }

  void setUpMockFetchProfileServerException() {
    when(_userRemoteDataSource.fetchProfile())
        .thenThrow(const ServerException());
  }

  void setUpMockLogoutSuccess() {
    when(_userRemoteDataSource.logout())
        .thenAnswer((_) async => true);
  }

  void setUpMockLogoutFailure() {
    when(_userRemoteDataSource.logout())
        .thenThrow(const ServerException());
  }

  void setUpMockCleanSuccess() {
    when(_userLocalDataSource.clean())
        .thenAnswer((_) => Future<void>.value());
  }

  void setUpMockGetCachedProfileSuccess() {
    when(_userLocalDataSource.getCachedUser())
        .thenAnswer((_) async => _user);
  }

  void setUpMockGetCachedProfileFailure() {
    when(_userLocalDataSource.getCachedUser())
        .thenThrow(const CacheException());
  }

  group('[repository] Fetch user profile', () {
    test('should return UserModel object when '
        'fetch profile info success', () async {
      //arrange
      setUpMockFetchProfileSuccess();
      setUpMockStoreUserSuccess();

      final Either<Failure, User> failureOrUser =
          await _userRepository.fetchProfile();
      expect(failureOrUser, Right<Failure, User>(_user));
    });

    test('should return ServerFailure object when '
        'fetch profile info failed', () async {
      //arrange
      setUpMockFetchProfileServerException();

      final Either<Failure, User> failure =
          await _userRepository.fetchProfile();

      // assert
      expect(failure, const Left<Failure, User>(ServerFailure()));
    });

    test('should return CacheFailure object when '
        'caching data failed', () async {
      //arrange
      setUpMockFetchProfileSuccess();
      setUpMockStoreUserFailure();

      final Either<Failure, User> failure =
          await _userRepository.fetchProfile();

      // assert
      expect(failure, const Left<Failure, User>(CacheFailure()));
    });
  });

  group('[repository] Logout', () {
    test('should return true when logout success', () async {
      //arrange
      setUpMockLogoutSuccess();
      setUpMockCleanSuccess();

      final Either<Failure, bool> failureOrUser =
          await _userRepository.logout();
      expect(failureOrUser, const Right<Failure, bool>(true));
    });

    test('should return ServerFailure object when server\'s '
        'response failed', () async {
      //arrange
      setUpMockLogoutFailure();

      final Either<Failure, bool> failure = await _userRepository.logout();

      // assert
      expect(failure, const Left<Failure, bool>(ServerFailure()));
    });
  });

  group('[repository] Get cached profile', () {
    test('should return User when logout success', () async {
      //arrange
      setUpMockGetCachedProfileSuccess();

      final Either<Failure, User> failureOrUser =
          await _userRepository.getCachedProfile();
      expect(failureOrUser, Right<Failure, User>(_user));
    });

    test('should return CacheFailure object when '
        'get cached data failed', () async {
      //arrange
      setUpMockGetCachedProfileFailure();

      final Either<Failure, User> failure =
          await _userRepository.getCachedProfile();

      // assert
      expect(failure, const Left<Failure, User>(CacheFailure()));
    });
  });
}