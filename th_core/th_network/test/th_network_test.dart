import 'package:flutter_test/flutter_test.dart';
import 'package:th_dependencies/th_dependencies.dart';
import 'package:th_network/network/network.dart';

import 'package:th_network/th_network.dart';

void main() {

  Future<THNetworkRequester>? _requesterFuture;
  THNetworkRequester _requester;

  setUp(() {
    _requesterFuture = THNetwork.getInstance("http://myapi-dev.com.vn", const FlutterSecureStorage());
  });

  test('get', () async {
    _requester = await _requesterFuture!;
    THResponse response = await _requester.executeRequest(THRequestMethods.get, "/front/api/v1/settings/", queryParameters: {"attr_name": "Contact"});
    expect(response.code, 0);
  });

  test('post', () async {
    _requester = await _requesterFuture!;
    final deviceInfo = {
      "device_code" : "device_code",
      'device_model': "deviceModel",
      'os_name': "osName",
      'os_version': "osVersion",
      'app_version': "app_version"
    };
    THResponse response = await _requester.executeRequest(
        THRequestMethods.post,
        "/front/api/v1/user/login",
        data: {
          "login_id" : "dev01@gmail.com",
          "password" : "dev",
          "device" : deviceInfo
        }
    );
    expect(response.code, 0);
    expect(response.statusCode, 200);
  });
}
