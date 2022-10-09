
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart' as dio;

const Map<String, dynamic> _userJson = <String, dynamic>{
  'code': 'code',
  'name': 'name'
};

class MockTHNetworkRequester extends Mock implements THNetworkRequester {

  @override
  Future<void> setToken(String? token, String? refreshToken) {

    return super.noSuchMethod(
        Invocation.method(
            #setToken, <dynamic>['access_token', 'refresh_token']),
        returnValue: Future<bool>.value(true)
    );
  }

  @override
  Future<void> removeToken() {
    return super.noSuchMethod(
      Invocation.method(#removeToken, <dynamic>[]),
      returnValue: Future<bool>.value(true)
    );
  }

  @override
  Future<THResponse<T>> executeRequest<T>(
      THRequestMethods? method,
      String? path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        dio.Options? options
      }) async {

    return super.noSuchMethod(
        Invocation.method(#executeRequest, <dynamic>[THRequestMethods.post, '/front/api/v1/user/login']),
        returnValue: THResponse<dynamic>(
            code: 200,
            status: true,
            data: <String, dynamic>{
              'access_token' : 'access_token',
              'refresh_token' : 'refresh_token',
            }
        )
    );
  }
}

class MockDeviceInfoDataSource extends Mock implements DeviceInfoDataSource {
  @override
  Future<Map<String, dynamic>> get deviceInfo => super.noSuchMethod(
      Invocation.getter(#deviceInfo),
      returnValue:
          Future<Map<String, dynamic>>.value(<String, dynamic>{'os': 'os'}));
}

void main() {
  late MockTHNetworkRequester _requester;
  late MockDeviceInfoDataSource _deviceInfoDataSource;
  late UserRemoteDataSource _userRemoteDataSource;

  setUp(() {
    _requester = MockTHNetworkRequester();
    _deviceInfoDataSource = MockDeviceInfoDataSource();
    _userRemoteDataSource = UserRemoteDataSourceImpl(
      _requester,
      _deviceInfoDataSource
    );

    when(_deviceInfoDataSource.deviceInfo)
        .thenAnswer((_) async => <String, dynamic>{});

    when(_requester.removeToken())
        .thenAnswer((_) async => true);
  });

  void setUpMockFetchProfileSuccess200() {
    when(_requester.executeRequest(
        THRequestMethods.get, '/front/api/v1/user/login'))
        .thenAnswer((_) async =>
        THResponse<Map<String, dynamic>>(
          code: 200,
          status: true,
          data: _userJson
        )
    );
  }

  void setUpMockFetchProfileServerException() {
    when(_requester.executeRequest(
        THRequestMethods.get, '/front/api/v1/user/login'))
        .thenThrow(const ServerException());
  }

  void setUpMockLogoutSuccess200() {
    when(_requester.executeRequest(
        THRequestMethods.get, '/front/api/v1/user/logout'))
        .thenAnswer((_) async =>
        THResponse<Map<String, dynamic>>(
          code: 200,
          status: true,
          data: <String, dynamic>{}
        )
    );
  }

  void setUpMockLogoutServerException() {
    when(_requester.executeRequest(
        THRequestMethods.get, '/front/api/v1/user/logout'))
        .thenThrow(const ServerException());
  }

  group('[data_source] user remote', () {
    test('should return UserModel object when '
        'fetch profile info success', () async {
      //arrange
      setUpMockFetchProfileSuccess200();

      final User user = await _userRemoteDataSource.fetchProfile();

      // assert
      expect(user, equals(UserModel.fromJson(_userJson)));
      expect(user.id, _userJson['code']);
      expect(user.name, _userJson['name']);
    });

    test('should return ServerException object when '
        'failure fetch profile info', () async {
      //arrange
      setUpMockFetchProfileServerException();

      final Function() call = _userRemoteDataSource.fetchProfile;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });

    test('should return true object when logout success', () async {
      //arrange
      setUpMockLogoutSuccess200();

      final bool loggedOut = await _userRemoteDataSource.logout();

      // assert
      expect(loggedOut, true);
    });

    test('should return ServerException object when logout failure', () async {
      //arrange
      setUpMockLogoutServerException();

      final Function() call = _userRemoteDataSource.logout;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
