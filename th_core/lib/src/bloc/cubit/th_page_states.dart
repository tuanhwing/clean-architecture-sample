
///abstract [THPageState] used to build loading/error/init state
abstract class THPageState {
  ///Constructor
  THPageState();
}

///[THNone] represents first or normal state
class THNone extends THPageState {}

/// [THPageLoading] represents loading state
class THLoading extends THPageState {}

/// [THError] represents error state
class THError extends THPageState {
  ///Constructor
  THError(this.message) : super();

  ///Message
  final String message;
}
