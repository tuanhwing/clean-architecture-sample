import 'package:example_dependencies/example_dependencies.dart';

import '../repositories/repositories.dart';

///VerifyCodeUseCase
class VerifyCodeUseCase extends UseCase<bool, CodeVerificationParams> {
  ///Constructor
  VerifyCodeUseCase(this._userRepository);

  final AuthenticationRepository _userRepository;

  @override
  Future<Either<Failure, bool>> call(CodeVerificationParams params) async {
    return await _userRepository.verifyCode(params.verificationID, params.code);
  }
}

///Authentication parameters
class CodeVerificationParams extends Equatable {
  ///Constructor
  const CodeVerificationParams({
    required this.verificationID,
    required this.code
  });

  ///dialCode
  final String verificationID;
  ///phone
  final String code;

  @override
  List<Object?> get props => <Object?>[verificationID, code];
}