
import 'package:example_dependencies/example_dependencies.dart';

import '../models/models.dart';

abstract class AuthenticationLocalDataSource {
  final SharedPreferences _sharedPreferences;
  AuthenticationLocalDataSource(this._sharedPreferences);
}

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  AuthenticationLocalDataSourceImpl(SharedPreferences sharedPreferences) : super(sharedPreferences);

}
