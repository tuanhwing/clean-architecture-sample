import 'package:example_dependencies/example_dependencies.dart';

///abstract [AuthenticationRepository] class used to perform data logic
///related to authentication
abstract class AuthenticationRepository {
  ///Sign in
  Future<Either<Failure, String>> signIn(String dialCode, String phone);
  ///Sign up
  Future<Either<Failure, String>> signUp(String dialCode, String phone);
  ///Code verification
  Future<Either<Failure, bool>> verifyCode(String verificationID, String code);
}
