
import 'package:example_dependencies/example_dependencies.dart';

import '../repositories/repositories.dart';

///SignInUseCase
class SignInUseCase extends UseCase<String, AuthenticationParams> {
  ///Constructor
  SignInUseCase(this._userRepository);

  final AuthenticationRepository _userRepository;

  @override
  Future<Either<Failure, String>> call(AuthenticationParams params) async {
    return await _userRepository.signIn(params.dialCode, params.phone);
  }
}

///SignUpUseCase
class SignUpUseCase extends UseCase<String, AuthenticationParams> {
  ///Constructor
  SignUpUseCase(this._userRepository);

  final AuthenticationRepository _userRepository;

  @override
  Future<Either<Failure, String>> call(AuthenticationParams params) async {
    return await _userRepository.signUp(params.dialCode, params.phone);
  }
}

///Authentication parameters
class AuthenticationParams extends Equatable {
  ///Constructor
  const AuthenticationParams({
    required this.dialCode,
    required this.phone
  });

  ///dialCode
  final String dialCode;
  ///phone
  final String phone;

  @override
  List<Object?> get props => <Object?>[dialCode, phone];
}