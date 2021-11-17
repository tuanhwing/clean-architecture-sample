
import 'package:dartz/dartz.dart';

import '../../error/error.dart';
import '../entities/entities.dart';


///abstract [UserRepository] class used to perform data logic related to authentication
abstract class UserRepository {
  ///Fetch remote user's profile
  Future<Either<Failure, User>> fetchProfile();

  ///Get cached user's profile
  Future<Either<Failure, User>> getCachedProfile();

  ///Logout
  Future<Either<Failure, bool>> logout();
}
