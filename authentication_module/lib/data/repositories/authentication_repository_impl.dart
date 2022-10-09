import 'package:example_dependencies/example_dependencies.dart';

import '../../domain/repositories/authentication_repository.dart';
import '../datasources/datasources.dart';

///AuthenticationRepository implementation
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  ///Constructor
  AuthenticationRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  ///Local data source
  final AuthenticationLocalDataSource localDataSource;

  ///Remote data source
  final AuthenticationRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> signIn(String dialCode, String phone) async {
    try {
      final String id = await remoteDataSource.signIn(dialCode, phone);

      return Right<Failure, String>(id);
    } on ServerException catch (exception) {
      return Left<Failure, String>(ServerFailure(message: exception.message));
    } catch (exception) {
      return Left<Failure, String>(
          InternalFailure(message: exception.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signUp(String dialCode, String phone) async {
    try {
      final String id = await remoteDataSource.signUp(dialCode, phone);

      return Right<Failure, String>(id);
    } on ServerException catch (exception) {
      return Left<Failure, String>(ServerFailure(message: exception.message));
    } catch (exception) {
      return Left<Failure, String>(
          InternalFailure(message: exception.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyCode(
      String verificationID, String code) async {
    try {
      final bool result =
          await remoteDataSource.verifyCode(verificationID, code);

      return Right<Failure, bool>(result);
    } on ServerException catch (exception) {
      return Left<Failure, bool>(ServerFailure(message: exception.message));
    } catch (exception) {
      return Left<Failure, bool>(
          InternalFailure(message: exception.toString()));
    }
  }
}
