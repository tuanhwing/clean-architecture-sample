
import 'package:th_core/th_core.dart';

import '../../../domain/domain.dart';

///AppState
class AppState extends Equatable {
  ///Constructor
  const AppState({
    this.user,
    this.isLoggedIn = false,
    this.languages = const <String>['vi', 'en'],
  });

  ///Instance of User
  final User? user;
  ///Flag to detect user is logged in or not
  final bool isLoggedIn;
  ///Languages
  final List<String> languages;

  ///Return new instance with received params
  AppState copyWith({User? user, bool? isLoggedIn}) {
      return AppState(
        user: user,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        languages: languages,
      );
  }

  @override
  List<Object?> get props => <Object?>[user, isLoggedIn];
}
