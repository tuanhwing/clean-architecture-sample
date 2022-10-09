
import 'package:example_dependencies/example_dependencies.dart';

import 'home_event.dart';
import 'home_state.dart';

///HomeBloc
class HomeBloc extends THBaseBloc<HomeEvent, HomeState> {
  ///Constructor
  HomeBloc(this._fetchProfileUseCase, this._getCachedProfileUseCase, this._logoutUseCase)
      : super(const HomeState()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<LogoutEvent>(_onLogout);
  }

  final FetchProfileUseCase _fetchProfileUseCase;
  final GetCachedProfileUseCase _getCachedProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  void _onLogout(LogoutEvent event, Emitter<HomeState> emit) async {
    final Either<Failure, bool> _ =
    await _logoutUseCase.call(NoParams());

    GetIt.I.get<AppBloc>().add(const AuthenticationStatusChangedEvent());
  }

  void _onFetchProfile(FetchProfileEvent event, Emitter<HomeState> emit) async {

    //Caced profile
    final Either<Failure, User> failureOrCached =
        await _getCachedProfileUseCase.call(NoParams());
    failureOrCached.fold(
      (Failure failure) => null, //Show error
      (User user) =>
        GetIt.I.get<AppBloc>().add(UserProfileUpdatedEvent(user: user)),
    );

    //Remote profile
    final Either<Failure, User> failureOrFetched =
    await _fetchProfileUseCase.call(NoParams());
    failureOrFetched.fold(
      (Failure failure) => null, //Show error
      (User user) =>
          GetIt.I.get<AppBloc>().add(UserProfileUpdatedEvent(user: user)),
    );
  }
}
