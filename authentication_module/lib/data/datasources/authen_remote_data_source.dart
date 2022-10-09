import 'package:example_dependencies/example_dependencies.dart';

///Authentication remote data source interface
abstract class AuthenticationRemoteDataSource extends BaseRemoteDataSource {
  ///Constructor
  AuthenticationRemoteDataSource(
    THNetworkRequester requester,
    DeviceInfoDataSource deviceInfoDataSource,
  ) : super(requester, deviceInfoDataSource);

  /// Calls login request the /api/auth/login endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  /// Return value of verification id
  Future<String> signIn(String dialCode, String phoneNumber);

  /// Calls registration request with the /api/auth/register endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  /// Return value of verification id
  Future<String> signUp(String dialCode, String phoneNumber);

  /// Calls code verification request with the /api/auth/codeVerification endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  /// Return value of verification id
  Future<bool> verifyCode(String verificationID, String code);
}

///Authentication remote data source implementation
class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  ///Constructor
  AuthenticationRemoteDataSourceImpl(
    THNetworkRequester requester,
    DeviceInfoDataSource deviceInfoDataSource,
  ) : super(requester, deviceInfoDataSource);

  @override
  Future<String> signIn(String dialCode, String phoneNumber) async {
    //Network
    THResponse<Map<String, dynamic>> response = await requester.executeRequest(
        THRequestMethods.post,
        '/api/auth/login',
        data: <String, String>{
          'dial_code' : dialCode,
          'phone' : phoneNumber
        }
    );

    if (!response.success) {
      throw ServerException(
          code: response.code,
          message: response.message
      );
    }
    return response.data?['verification_id'] ?? '';
  }

  @override
  Future<String> signUp(String dialCode, String phoneNumber) async {
    //Network
    THResponse<Map<String, dynamic>> response = await requester.executeRequest(
        THRequestMethods.post,
        '/api/auth/register',
        data: <String, String>{
          'dial_code' : dialCode,
          'phone' : phoneNumber
        }
    );

    if (!response.success) {
      throw ServerException(
          code: response.code,
          message: response.message
      );
    }
    return response.data?['verification_id'] ?? '';
  }

  @override
  Future<bool> verifyCode(String verificationID, String code) async {
    THResponse<Map<String, dynamic>> response = await requester.executeRequest(
        THRequestMethods.post,
        '/api/auth/codeVerification',
        data: <String, String>{
          'verification_id' : verificationID,
          'code' : code
        }
    );

    if (!response.success) {
      throw ServerException(
          code: response.code,
          message: response.message
      );
    }

    //Save user's session
    requester.setToken(
      response.data?['access_token'] ?? '',
      response.data?['refresh_token'] ?? ''
    );
    return true;
  }
}
