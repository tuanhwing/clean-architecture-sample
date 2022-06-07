
import 'package:dartz/dartz.dart';

import 'usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../../error/error.dart';

class FetchProfileUseCase extends UseCase<User, NoParams> {
  FetchProfileUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _userRepository.fetchProfile();
  }
}
