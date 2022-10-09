import 'package:dartz/dartz.dart';

import 'usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../../error/error.dart';

///GetCachedProfileUseCase
class GetCachedProfileUseCase extends UseCase<User, NoParams> {
  ///Constructor
  GetCachedProfileUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _userRepository.getCachedProfile();
  }
}