
import 'package:flutter_test/flutter_test.dart';
import 'package:example_dependencies/example_dependencies.dart';

const User _user = User(code: 'code', name: 'name');

void main() {
  GetIt.I.registerFactory<THPageCubit>(() => THPageCubit());

  late AppBloc _bloc;

  setUp(() {
    _bloc = AppBloc();
  });

  group('[bloc] app', () {
    test('initial state is correct', () {
      expect(_bloc.state.user, isNull);
    });

    test('should user\'s AppState not null when user logged in', () {
      // assert later
      final expected = [
        const AppState(user: _user),
      ];
      expectLater(_bloc.stream, emitsInOrder(expected));

      //Logged in
      _bloc.add(const AuthenticationStatusChangedEvent(user: _user));
    });

    test('should user\'s AppState is null when user logged out', () {
      // assert later
      final expected = [
        const AppState(user: null),
      ];
      expectLater(_bloc.stream, emitsInOrder(expected));

      //Logged in
      _bloc.add(const AuthenticationStatusChangedEvent(user: null));
    });
  });
}