
import 'package:example_dependencies/example_dependencies.dart';

abstract class AuthenticationLocalDataSource {
  final SharedPreferences _sharedPreferences;
  AuthenticationLocalDataSource(this._sharedPreferences);

  //Temporary
  void saveData({required String key, required String value});
}

class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  AuthenticationLocalDataSourceImpl(SharedPreferences sharedPreferences) : super(sharedPreferences);

  @override
  void saveData({required String key, required String value}) {
    _sharedPreferences.setString(key, value);
  }


}
