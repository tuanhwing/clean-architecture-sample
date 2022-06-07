
import 'package:example_dependencies/core/core.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_module/src/presentation/blocs/blocs.dart';
import 'package:mockito/mockito.dart';

const THShowErrorOverlayState _error = THShowErrorOverlayState(message: "error message");

class MockLogOutUseCase extends Mock implements LogoutUseCase {

  @override
  Future<Either<Failure, bool>> invoke(NoParams params) async {
    Right<Failure, bool> resultValue = const Right<Failure, bool>(true);
    return super.noSuchMethod(
        Invocation.method(#invoke, [NoParams()]),
        returnValue: resultValue
    );
  }
}

void main() {
  GetIt.I.registerFactory<THPageCubit>(() => THPageCubit());

  late MockLogOutUseCase _logoutUseCase;
  late SettingsBloc _settingBloc;
  late AppBloc _appBloc = AppBloc();

  GetIt.I.registerLazySingleton<AppBloc>(() => _appBloc);

  setUp(() {
    _logoutUseCase = MockLogOutUseCase();
    _settingBloc = SettingsBloc(_logoutUseCase);
  });

  void setUpMockLogOutSuccess() {
    when(_logoutUseCase.invoke(NoParams()))
        .thenAnswer((_) async => const Right<Failure, bool>(true));
  }

  void setUpMockLogOutServerFailure() {
    when(_logoutUseCase.invoke(NoParams()))
        .thenAnswer((_) async => Left<Failure, bool>(ServerFailure(message: _error.message)));
  }

  void setUpMockLogOutCacheFailure() {
    when(_logoutUseCase.invoke(NoParams()))
        .thenAnswer((_) async => Left<Failure, bool>(CacheFailure(message: _error.message)));
  }

  void setUpMockLogOutInternalFailure() {
    when(_logoutUseCase.invoke(NoParams()))
        .thenAnswer((_) async => Left<Failure, bool>(InternalFailure(message: _error.message)));
  }

  group('[bloc] Settings', () {
    test('initial state (None) is correct', () {
      expect(_settingBloc.pageCubit.state, THInitialState());
    });

    test('should emit [Loading, Error] when logout with error from response\'s server', () async {
      //arrange
      setUpMockLogOutServerFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_settingBloc.pageCubit.stream, emitsInOrder(expected));

      //Logout
      _settingBloc.add(const LogoutEvent());
    });

    test('should emit [Loading, Error] when logout with cache error', () async {
      //arrange
      setUpMockLogOutCacheFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_settingBloc.pageCubit.stream, emitsInOrder(expected));

      //Logout
      _settingBloc.add(const LogoutEvent());
    });

    test('should emit [Loading, Error] when logout with internal error', () async {
      //arrange
      setUpMockLogOutInternalFailure();

      // assert later
      final expected = [
        THShowLoadingOverlayState(),
        _error,
      ];
      expectLater(_settingBloc.pageCubit.stream, emitsInOrder(expected));

      //Logout
      _settingBloc.add(const LogoutEvent());
    });

    test('should emit null object into AppState when logout successful', () async {
      //arrange
      setUpMockLogOutSuccess();

      //Logout
      _settingBloc.add(const LogoutEvent());
      await untilCalled(_logoutUseCase.invoke(NoParams()));
      verify(_logoutUseCase.invoke(NoParams()));

      //AppBloc
      await untilCalled(_appBloc.emit(const AppState(user: null)));
      expect(_appBloc.state.user, null);
    });
  });
}
