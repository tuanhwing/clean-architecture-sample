
import 'package:example_dependencies/example_dependencies.dart';

import '../models/models.dart';

abstract class AuthenticationRemoteDataSource extends BaseRemoteDataSource {
  AuthenticationRemoteDataSource(
    THNetworkRequester requester,
    DeviceInfoDataSource deviceInfoDataSource,
  ) : super(requester, deviceInfoDataSource);


  /// Calls the /user/login endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> signIn(String email, String password);

  /// Calls the /user/register endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<bool> registerWith(String email, String password);
}

class AuthenticationRemoteDataSourceImpl extends AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl(
      THNetworkRequester requester,
      DeviceInfoDataSource deviceInfoDataSource,
  ) : super(requester, deviceInfoDataSource);

  @override
  Future<bool> signIn(String email, String password) async {
    // ///Mock Up
    // await Future.delayed(const Duration(seconds: 1));
    // requester.setToken(MockUp.login['access_token'], MockUp.login['refresh_token']);
    // return true;

    //Network
    THResponse response = await requester.executeRequest(
        THRequestMethods.post,
        "/front/api/v1/user/login",
        data: {
          "login_id" : email,
          "password" : password,
          "device" : await deviceInfo
        }
    );

    if (response.success) {
      requester.setToken(response.data['access_token'], response.data['refresh_token']);
      return true;
    }
    else {
      throw ServerException(
          code: response.code,
          message: response.message
      );
    }
  }

  @override
  Future<bool> registerWith(String email, String password) {
    throw UnimplementedError();
  }

}
