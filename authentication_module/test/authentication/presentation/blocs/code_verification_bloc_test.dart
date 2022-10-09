
import 'package:authentication_module/domain/domain.dart';
import 'package:authentication_module/presentation/blocs/blocs.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

User _user = const UserModel(
  id: 'code',
  name: 'name',
  phoneModel: PhoneModel(
    dialCode: 'dialCode',
    phoneNumber: 'phoneNumber',
    fullPhoneNumber: 'fullPhoneNumber',
  )
);
const AuthenticationParams authenticationParams =
    AuthenticationParams(dialCode: 'dialCode', phone: 'phone');
const WidgetShowErrorNotifyOverlay<String> _error =
WidgetShowErrorNotifyOverlay<String>(data: 'error message');

class MockSignInUseCase extends Mock implements SignInUseCase {
  @override
  Future<Either<Failure, String>> call(AuthenticationParams params) async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
      Invocation.method(#invoke, <dynamic>[const AuthenticationParams(
          dialCode: 'dialCode',
          phone: 'phone'
      )]),
      returnValue: Future<Either<Failure, bool>>.value(resultValue)
    );
  }
}

class MockVerifyCodeUseCase extends Mock implements VerifyCodeUseCase {
  @override
  Future<Either<Failure, bool>> call(CodeVerificationParams params) async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
        Invocation.method(#invoke, <dynamic>[const AuthenticationParams(
            dialCode: 'dialCode',
            phone: 'phone'
        )]),
        returnValue: Future<Either<Failure, bool>>.value(resultValue)
    );
  }
}

class MockFetchProfileUseCase extends Mock implements FetchProfileUseCase {
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    Right<Failure, User> resultValue = Right<Failure, User>(_user);
    return super.noSuchMethod(
      Invocation.method(#invoke, <dynamic>[NoParams()]),
      returnValue: Future<Either<Failure, User>>.value(resultValue)
    );
  }
}

void main() {
  GetIt.I.registerFactory<THWidgetCubit>(() => THWidgetCubit());

  late MockSignInUseCase _signInUssCase;
  late MockVerifyCodeUseCase _verifyCodeUseCase;
  late MockFetchProfileUseCase _fetchProfileUseCase;
  late CodeVerificationBloc _loginBloc;
  late AppBloc _appBloc = AppBloc();

  GetIt.I.registerLazySingleton<AppBloc>(() => _appBloc);

  setUp(() {
    _signInUssCase = MockSignInUseCase();
    _fetchProfileUseCase = MockFetchProfileUseCase();
    _verifyCodeUseCase = MockVerifyCodeUseCase();
    _loginBloc = CodeVerificationBloc(_verifyCodeUseCase);
  });

  void setUpMockAuthenticationSuccess() {
    when(_signInUssCase.call(authenticationParams)).thenAnswer(
        (_) async => const Right<Failure, String>('verification_id'));
  }

  void setUpMockAuthenticationServerFailure() {
    when(_signInUssCase.call(authenticationParams)).thenAnswer((_) async =>
        Left<Failure, String>(ServerFailure(message: _error.data)));
  }

  void setUpMockAuthenticationInternalFailure() {
    when(_signInUssCase.call(authenticationParams)).thenAnswer((_) async =>
        Left<Failure, String>(InternalFailure(message: _error.data)));
  }

  void setUpMockFetchProfileSuccess() {
    when(_fetchProfileUseCase.call(NoParams()))
        .thenAnswer((_) async => Right<Failure, User>(_user));
  }

  void setUpMockFetchProfileServerFailure() {
    when(_fetchProfileUseCase.call(NoParams())).thenAnswer((_) async =>
        Left<Failure, User>(ServerFailure(message: _error.data)));
  }

  void setUpMockFetchProfileInternalFailure() {
    when(_fetchProfileUseCase.call(NoParams())).thenAnswer((_) async =>
        Left<Failure, User>(InternalFailure(message: _error.data)));
  }

  group('[bloc] Login', () {

    test('initial state (None) is correct', () {
      expect(_loginBloc.pageCubit.state, const WidgetInitial<void>());
    });

    test('should emit [Loading, Error] when authentication with '
        'error from response\'s server', () async {
      //arrange
      setUpMockAuthenticationServerFailure();

      // assert later
      final Iterable<dynamic> expected = <dynamic>[
        const WidgetShowLoadingOverlay<void>(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const CodeVerificationSubmitEvent(
          pin: '123456', verificationID: 'verification_id'));
    });

    test('should emit [Loading, Error] when authentication '
        'with internal error', () async {
      //arrange
      setUpMockAuthenticationInternalFailure();

      // assert later
      final Iterable<dynamic> expected = <dynamic>[
        const WidgetShowLoadingOverlay<void>(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const CodeVerificationSubmitEvent(
          pin: '123456', verificationID: 'verification_id'));
    });

    test('should emit [Loading, Error] when fetch profile with error from '
        'response\'s server', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileServerFailure();

      // assert later
      final Iterable<dynamic> expected = <dynamic>[
        const WidgetShowLoadingOverlay<void>(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const CodeVerificationSubmitEvent(
          pin: '123456', verificationID: 'verification_id'));
    });

    test('should emit [Loading, Error] when fetch profile '
        'with internal error', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileInternalFailure();

      // assert later
      final Iterable<dynamic> expected = <dynamic>[
        const WidgetShowLoadingOverlay<void>(),
        _error,
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const CodeVerificationSubmitEvent(
          pin: '123456', verificationID: 'verification_id'));
    });

    test('should emit [Loading, None] when authentication+fetch '
        'profile successful', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileSuccess();

      // assert later
      final Iterable<dynamic> expected = <dynamic>[
        const WidgetShowLoadingOverlay<void>(),
        const WidgetInitial<void>(),
      ];
      expectLater(_loginBloc.pageCubit.stream, emitsInOrder(expected));

      //Authentication
      _loginBloc.add(const CodeVerificationSubmitEvent(
          pin: '123456', verificationID: 'verification_id'));
    });

    test('should emit [User] object into AppState when '
        'authentication successful', () async {
      //arrange
      setUpMockAuthenticationSuccess();
      setUpMockFetchProfileSuccess();

      //Authentication
      _loginBloc.add(const CodeVerificationSubmitEvent(
          pin: '123456', verificationID: 'verification_id'));
      await untilCalled(_signInUssCase.call(authenticationParams));
      verify(_signInUssCase.call(authenticationParams));

      //Fetch profile
      await untilCalled(_fetchProfileUseCase.call(NoParams()));
      verify(_fetchProfileUseCase.call(NoParams()));

      //AppBloc
      await untilCalled(_appBloc.emit(AppState(user: _user)));
      expect(_appBloc.state.user, _user);
    });
  });

  tearDown(() {
    _loginBloc.close();
    _appBloc.close();
  });
}
