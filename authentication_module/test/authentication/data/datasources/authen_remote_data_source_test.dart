
import 'package:authentication_module/data/data.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:dio/dio.dart' as dio;

class MockTHNetworkRequester extends Mock implements THNetworkRequester {

  @override
  Future<void> setToken(String? token, String? refreshToken) {

    return super.noSuchMethod(
      Invocation.method(#setToken, <dynamic>['access_token', 'refresh_token']),
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
      returnValue: THResponse<Map<String, dynamic>>(
        code: 200,
        status: true,
        data: <String, dynamic>{
          'verification_id' : 'verification_id',
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
  late AuthenticationRemoteDataSourceImpl _dataSource;

  setUp(() {
    _requester = MockTHNetworkRequester();
    _deviceInfoDataSource = MockDeviceInfoDataSource();

    _dataSource =
        AuthenticationRemoteDataSourceImpl(_requester, _deviceInfoDataSource);

    when(_requester.setToken('access_token', 'refresh_token'))
        .thenAnswer((_) async => true
    );

    when(_deviceInfoDataSource.deviceInfo)
      .thenAnswer((_) async => <String, dynamic>{});
  });

  void setUpMockAuthenticationSuccess200() {

    when(_requester.executeRequest(THRequestMethods.post, '/front/api/v1/user/login'))
      .thenAnswer((_) async =>
        THResponse<Map<String, dynamic>>(
          code: 200,
          status: true,
          data: <String, dynamic>{
            'access_token' : 'access_token',
            'refresh_token' : 'refresh_token',
          }
        )
    );
  }

  void setUpMockHttpClientFailure404() {

    when(_requester.executeRequest(THRequestMethods.post, '/front/api/v1/user/login'))
      .thenAnswer((_) async =>
        THResponse<dynamic>(
          status: false,
          code: 404,
          data: null,
          message: 'Something went wrong'
        )
    );
  }

  group('[data_sources] Authentication', () {

    test(
      'should return true when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockAuthenticationSuccess200();
        // act
        final String result = await _dataSource.signIn('email', 'password');
        // assert
        expect(result, true);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final Function(String, String) call = _dataSource.signIn;
        // assert
        expect(() => call('email', 'password'),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}