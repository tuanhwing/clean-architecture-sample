import 'package:example_dependencies/example_dependencies.dart';

///Authentication local data source interface
abstract class AuthenticationLocalDataSource {
  ///Constructor
  AuthenticationLocalDataSource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  ///Save data
  void saveData({required String key, required String value});
}

///Authentication local data source implementation
class AuthenticationLocalDataSourceImpl extends AuthenticationLocalDataSource {
  ///Constructor
  AuthenticationLocalDataSourceImpl(SharedPreferences sharedPreferences)
      : super(sharedPreferences);

  @override
  void saveData({required String key, required String value}) {
    _sharedPreferences.setString(key, value);
  }
}
