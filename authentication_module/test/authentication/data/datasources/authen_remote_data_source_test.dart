
import 'package:authentication_module/src/data/data.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:dio/dio.dart' as dio;

class MockTHNetworkRequester extends Mock implements THNetworkRequester {

  @override
  Future setToken(String? token, String? refreshToken) {

    return super.noSuchMethod(
      Invocation.method(#setToken, ['access_token', 'refresh_token']),
      returnValue: Future.value(true)
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
      Invocation.method(#executeRequest, [THRequestMethods.post, '/front/api/v1/user/login']),
      returnValue: THResponse(
        statusCode: 200,
        code: 0,
        data: {
          'access_token' : 'access_token',
          'refresh_token' : 'refresh_token',
        }
      )
    );
  }
}

void main() {
  late MockTHNetworkRequester _requester;
  late AuthenticationRemoteDataSourceImpl _dataSource;

  setUp(() {
    _requester = MockTHNetworkRequester();

    _dataSource = AuthenticationRemoteDataSourceImpl(_requester);

    when(_requester.setToken("access_token", "refresh_token"))
        .thenAnswer((_) async => true
    );
  });

  void setUpMockAuthenticationSuccess200() {
    when(_requester.executeRequest(THRequestMethods.post, "/front/api/v1/user/login"))
      .thenAnswer((_) async =>
        THResponse(
          statusCode: 200,
          code: 0,
          data: {
            'access_token' : 'access_token',
            'refresh_token' : 'refresh_token',
          }
        )
    );
  }

  void setUpMockHttpClientFailure404() {
    when(_requester.executeRequest(THRequestMethods.post, "/front/api/v1/user/login"))
      .thenAnswer((_) async =>
        THResponse(
          statusCode: 404,
          code: 1,
          data: null,
          message: "Something went wrong"
        )
    );
  }

  group("[data_sources] Authentication", () {

    test(
      'should return true when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockAuthenticationSuccess200();
        // act
        final result = await _dataSource.signIn('email', 'password');
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
        final call = _dataSource.signIn;
        // assert
        expect(() => call('email', 'password'), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}