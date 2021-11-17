import 'package:dartz/dartz.dart';

import 'usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../../error/error.dart';

class GetCachedProfileUseCase extends UseCase<User, NoParams> {
  GetCachedProfileUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<Either<Failure, User>> invoke(NoParams params) async {
    return await _userRepository.getCachedProfile();
  }
}