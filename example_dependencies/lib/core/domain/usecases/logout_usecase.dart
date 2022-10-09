
import 'package:dartz/dartz.dart';

import 'usecase.dart';
import '../../error/error.dart';
import '../repositories/repositories.dart';

///LogoutUseCase
class LogoutUseCase extends UseCase<bool, NoParams> {
  ///Constructor
  LogoutUseCase(this._userRepository);
  final UserRepository _userRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _userRepository.logout();
  }

}