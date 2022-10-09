
import 'package:flutter_test/flutter_test.dart';
import 'package:example_dependencies/example_dependencies.dart';

UserModel _user = const UserModel(
    id: 'code',
    name: 'name',
    phoneModel: PhoneModel(
      dialCode: 'dialCode',
      phoneNumber: 'phoneNumber',
      fullPhoneNumber: 'fullPhoneNumber',
    )
);

void main() {
  GetIt.I.registerFactory<THWidgetCubit>(() => THWidgetCubit());

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
      final Iterable<dynamic> expected = <dynamic>[
        AppState(user: _user),
      ];
      expectLater(_bloc.stream, emitsInOrder(expected));

      //Logged in
      _bloc.add(AuthenticationStatusChangedEvent(
          user: _user, isLoggedIn: true));
    });

    test('should user\'s AppState is null when user logged out', () {
      // assert later
      final Iterable<dynamic> expected = <dynamic>[
        const AppState(user: null),
      ];
      expectLater(_bloc.stream, emitsInOrder(expected));

      //Logged in
      _bloc.add(const AuthenticationStatusChangedEvent(user: null));
    });
  });
}