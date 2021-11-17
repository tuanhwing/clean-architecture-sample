
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:th_core/th_core.dart';

abstract class BaseRemoteDataSource {
  BaseRemoteDataSource(this._requester);
  final THNetworkRequester _requester;
  Map<String, dynamic>? _deviceInfo;

  THNetworkRequester get requester => _requester;

  ///Get device information
  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (_deviceInfo != null) {
      return _deviceInfo!;
    }

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceModel;
    String osVersion;
    String osName;
    String uuid;
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceModel = iosDeviceInfo.model;
      osVersion = iosDeviceInfo.systemVersion;
      uuid = iosDeviceInfo.identifierForVendor;// unique ID on iOS
      osName = 'iOS';
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceModel = androidDeviceInfo.model;
      osVersion = '${androidDeviceInfo.version.sdkInt}';
      uuid = androidDeviceInfo.androidId;// unique ID on Android
      osName = 'Android';
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _deviceInfo ??= {
      'device_code': uuid,
      'device_model': deviceModel,
      'os_name': osName,
      'os_version': osVersion,
      'app_version': '${packageInfo.version}+${packageInfo.buildNumber}'
      };
    return _deviceInfo!;
  }
}