
import 'package:authentication_module/src/data/data.dart';
import 'package:example_dependencies/example_dependencies.dart';

import '../../domain/repositories/authen_repository.dart';
import '../datasources/datasources.dart';


class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.localDataSource, required this.remoteDataSource});
  final AuthenticationLocalDataSource localDataSource;
  final AuthenticationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, bool>> signInWith(String email, password) async {
    try {
      await remoteDataSource.signIn(email, password);

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