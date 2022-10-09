
import 'package:dartz/dartz.dart';

import '../../domain/domain.dart';
import '../../error/error.dart';
import '../datasources/data_sources.dart';
import '../models/models.dart';

///UserRepository implementation
class UserRepositoryImpl extends UserRepository {
  ///Constructor
  UserRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});
  ///UserLocalDataSource
  final UserLocalDataSource localDataSource;
  ///UserRemoteDataSource
  final UserRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, User>> fetchProfile() async {
    try {
      final UserModel user = await remoteDataSource.fetchProfile();
      await localDataSource.storeUser(user);

      return Right<Failure, User>(user);
    }
    on ServerException catch (exception) {
      return Left<Failure, User>(ServerFailure(message: exception.message));
    }
    on CacheException catch (exception) {
      return Left<Failure, User>(CacheFailure(message: exception.message));
    }
    catch (exception) {
      return Left<Failure, User>(
          InternalFailure(message: exception.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedProfile() async {
    try {
      final UserModel user = await localDataSource.getCachedUser();
      return Right<Failure, User>(user);
    }
    on CacheException catch(_) {
      return const Left<Failure, User>(CacheFailure());
    }
    catch(_) {
      return const Left<Failure, User>(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clean();

      return const Right<Failure, bool>(true);
    }
    on ServerException catch (exception) {
      return Left<Failure, bool>(ServerFailure(message: exception.message));
    }
    on CacheException catch (exception) {
      return Left<Failure, bool>(CacheFailure(message: exception.message));
    }
    catch (exception) {
      return Left<Failure, bool>(
          InternalFailure(message: exception.toString()));
    }
  }

}