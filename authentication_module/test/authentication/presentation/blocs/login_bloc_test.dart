
import 'package:authentication_module/src/domain/domain.dart';
import 'package:authentication_module/src/presentation/blocs/blocs.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

const User _user = UserModel(code: 'code', name: 'name');
const AuthenticationParams authenticationParams = AuthenticationParams(email: 'email', password: 'password');
const THShowErrorOverlayState _error = THShowErrorOverlayState(message: "error message");

class MockSignInUseCase extends Mock implements SignInUseCase {
  @override
  Future<Either<Failure, bool>> call(AuthenticationParams params) async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
      Invocation.method(#invoke, [const AuthenticationParams(
        email: 'email',
        password: 'password')
      ]),
      returnValue: Future.value(resultValue)
    );
  }
}

class MockFetchProfileUseCase extends Mock implements FetchProfileUseCase {
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    Right<Failure, User> resultValue = const Right<Failure, User>(_user);
    return super.noSuchMethod(
      Invocation.method(#invoke, [NoParams()]),
      returnValue: Future.value(resultValue)
    );
  }
}

void main() {
  GetIt.I.registerFactory<THPageCubit>(() => THPageCubit());

  late MockSignInUseCase _signInUssCase;
  late MockFetchProfileUseCase _fetchProfileUseCase;
  late LoginBloc _loginBloc;
  late AppBloc _appBloc = AppBloc();

  GetIt.I.registerLazySingleton<AppBloc>(() => _appBloc);

  setUp(() {
    _signInUssCase = MockSignInUseCase();
    _fetchProfileUseCase = MockFetchProfileUseCase();
    _loginBloc = LoginBloc(_signInUssCase, _fetchProfileUseCase);
  });

  void setUpMockAuthenticationSuccess() {
    when(_signInUssCase.call(authenticationParams))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
  }

  void setUpMockAuthenticationServerFailure() {
    when(_signInUssCase.call(authenticationParams))
        .thenAnswer((_) async => Left<Failure, bool>(ServerFailure(message: _error.message)));
  }

  void setUpMockAuthenticationInternalFailure() {
    when(_signInUssCase.call(authenticationParams))
        .thenAnswer((_) async => Left<Failure, bool>(InternalFailure(message: _error.message)));
  }

  void setUpMockFetchProfileSuccess() {
    when(_fetchProfileUseCase.call(NoParams()))
        .thenAnswer((_) async => const Right<Failure, User>(_user));
  }

  void setUpMockFetchProfileServerFailure() {
    when(_fetchProfileUseCase.call(NoParams()))
        .thenAnswer((_) async => Left<Failure, User>(ServerFailure(message: _error.message)));
  }

  void setUpMockFetchProfileInternalFailure() {
    when(_fetchProfileUseCase.call(NoParams()))
        .thenAnswer((_) async => Left<Failure, User>(InternalFailure(message: _error.message)));
  }

  group('[bloc] Login', () {

    test('initial state (None) is correct', () {
      expect(_loginBloc.pageCubit.state, THInitialState());
    });

    test('should emit [Loading, Error] when authentication with error from response\'s server', () async {
      //arrange
      setUpMockAuthenticationServerFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const LoginSubmitEvent());
    });

    test('should emit [Loading, Error] when authentication with internal error', () async {
      //arrange
      setUpMockAuthenticationInternalFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const LoginSubmitEvent());
    });

    test('should emit [Loading, Error] when fetch profile with error from response\'s server', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileServerFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const LoginSubmitEvent());
    });

    test('should emit [Loading, Error] when fetch profile with internal error', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileInternalFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const LoginSubmitEvent());
    });

    test('should emit [Loading, None] when authentication+fetch profile successful', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileSuccess();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        THInitialState(),
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const LoginSubmitEvent());
    });

    test('should emit [User] object into AppState when authentication successful', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileSuccess();

      //Authentication
      _loginBloc.add(const LoginSubmitEvent());
      await untilCalled(_signInUssCase.call(authenticationParams));
      verify(_signInUssCase.call(authenticationParams));

      //Fetch profile
      await untilCalled(_fetchProfileUseCase.call(NoParams()));
      verify(_fetchProfileUseCase.call(NoParams()));

      //AppBloc
      await untilCalled(_appBloc.emit(const AppState(user: _user)));
      expect(_appBloc.state.user, _user);
    });
  });

  tearDown(() {
    _loginBloc.dispose();
    _appBloc.dispose();
  });
}
