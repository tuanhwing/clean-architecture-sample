
import 'package:example_dependencies/example_dependencies.dart';
import 'package:th_core/th_core.dart';

import '../repositories/repositories.dart';

class SignInUseCase extends UseCase<bool, AuthenticationParams> {
  SignInUseCase(this._userRepository);

  final AuthenticationRepository _userRepository;

  @override
  Future<Either<Failure, bool>> call(AuthenticationParams params) async {
    return await _userRepository.signInWith(params.email, params.password);
  }
}

///Authentication parameters
class AuthenticationParams extends Equatable {
  const AuthenticationParams({
    required this.email,
    required this.password
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];

}