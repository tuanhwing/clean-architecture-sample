
import 'package:th_core/th_core.dart';

import '../../error/exceptions.dart';
import '../models/user_model.dart';
import 'base_remote_data_source.dart';
import 'device_info_data_source.dart';

///Abstract class UserRemoteDataSource
abstract class UserRemoteDataSource extends BaseRemoteDataSource {
  ///Constructor
  UserRemoteDataSource(
    THNetworkRequester requester,
    DeviceInfoDataSource deviceInfoDataSource
  ) : super(requester, deviceInfoDataSource);

  /// Calls the /user/info endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> fetchProfile();

  /// Calls the /user/logout endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> logout();
}

///UserRemoteDataSource implementation
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  ///Constructor
  UserRemoteDataSourceImpl(
    THNetworkRequester requester,
    DeviceInfoDataSource deviceInfoDataSource
  ) : super(requester, deviceInfoDataSource);

  @override
  Future<UserModel> fetchProfile() async {

    THResponse<Map<String, dynamic>> response = await requester.executeRequest(
      THRequestMethods.get,
      '/api/user/profile',
    );

    if (response.success) {
      return UserModel.fromJson(response.data ?? <String,dynamic>{});
    }
    else {
      throw ServerException(
          code: response.code,
          message: response.message
      );
    }
  }

  @override
  Future<bool> logout() async {
    THResponse<dynamic> response = await requester.executeRequest(
      THRequestMethods.put,
      '/api/user/logout',
      data: <String, dynamic>{
        'device' : await deviceInfo
      }
    );
    requester.removeToken();
    if (response.success) {
      return true;
    }
    else {
      throw ServerException(
          code: response.code,
          message: response.message
      );
    }
  }


}