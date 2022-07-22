
import 'package:example_dependencies/example_dependencies.dart';

abstract class UserRemoteDataSource extends BaseRemoteDataSource {
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

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  UserRemoteDataSourceImpl(
    THNetworkRequester requester,
    DeviceInfoDataSource deviceInfoDataSource
  ) : super(requester, deviceInfoDataSource);

  @override
  Future<UserModel> fetchProfile() async {
    ///Mock Up
    await Future.delayed(const Duration(seconds: 1));
    return UserModel.fromJson(MockUp.profile);

    // //Network
    // THResponse response = await requester.executeRequest(
    //   THRequestMethods.get,
    //   "/front/api/v1/user/info",
    // );
    //
    // if (response.success) {
    //   return UserModel.fromJson(response.data);
    // }
    // else {
    //   throw ServerException(
    //       code: response.code,
    //       message: response.message
    //   );
    // }
  }

  @override
  Future<bool> logout() async {
    // ///Mock Up
    // await Future.delayed(const Duration(seconds: 1));
    // return true;

    //Network
    THResponse response = await requester.executeRequest(
      THRequestMethods.put,
      "/front/api/v1/user/logout",
      data: {
        "device" : await deviceInfo
      }
    );

    if (response.success) {
      requester.removeToken();
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