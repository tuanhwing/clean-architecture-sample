
import 'package:example_dependencies/example_dependencies.dart';

///abstract [AuthenticationRepository] class used to perform data logic related to authentication
abstract class AuthenticationRepository {
  ///Sign in
  Future<Either<Failure, bool>> signInWith(String email, password);
}