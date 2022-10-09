
import 'dart:convert';

import 'package:th_core/th_core.dart';

import '../../error/exceptions.dart';
import '../models/user_model.dart';

///Abstract class user local data source
abstract class UserLocalDataSource {
  ///Constructor
  UserLocalDataSource(this.sharedPreferences);
  ///SharedPreferences
  final SharedPreferences sharedPreferences;
  ///profileKey
  final String profileKey = 'th_profile_key';
  
  /// Store user information in Share Preferences
  ///
  /// Throws a [CacheException] for all error codes.
  Future<void> storeUser(UserModel userModel);

  /// Get cached user information in Share Preferences
  ///
  /// Throws a [CacheException] for all error codes.
  Future<UserModel> getCachedUser();

  /// Clean user information in Share Preferences
  ///
  /// Throws a [CacheException] for all error codes.
  Future<void> clean();
}

///UserLocalDataSource implementation
class UserLocalDataSourceImpl extends UserLocalDataSource {
  ///Constructor
  UserLocalDataSourceImpl(SharedPreferences sharedPreferences)
      : super(sharedPreferences);

  @override
  Future<UserModel> getCachedUser() async {
    String? data = sharedPreferences.getString(profileKey);
    if (data != null) {
      return  UserModel.fromJson(json.decode(data));
    }
    else {
      throw const CacheException();
    }
  }

  @override
  Future<void> storeUser(UserModel userModel) async {
    await sharedPreferences.setString(
        profileKey, json.encode(userModel.toJson()));
    return;
  }

  @override
  Future<bool> clean() async {
    return await sharedPreferences.remove(profileKey);
  }

}