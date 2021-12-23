
import 'package:dartz/dartz.dart';

import '../../domain/domain.dart';
import '../../error/error.dart';
import '../datasources/data_sources.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({required this.localDataSource, required this.remoteDataSource});
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, User>> fetchProfile() async {
    try {
      final user = await remoteDataSource.fetchProfile();
      await localDataSource.storeUser(user);

      return Right(user);
    }
    on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
    on CacheException catch (exception) {
      return Left(CacheFailure(message: exception.message));
    }
    catch (exception) {
      return Left(InternalFailure(message: exception.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedProfile() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    }
    on CacheException catch(_) {
      return const Left(CacheFailure());
    }
    catch(_) {
      return const Left(InternalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clean();

      return const Right(true);
    }
    on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
    on CacheException catch (exception) {
      return Left(CacheFailure(message: exception.message));
    }
    catch (exception) {
      return Left(InternalFailure(message: exception.toString()));
    }
  }

}