

import 'dart:io';

import 'package:example_dependencies/example_dependencies.dart';

abstract class DeviceInfoDataSource {
  DeviceInfoDataSource({
    required this.deviceInfoPlugin,
    required this.packageInfo
  });
  final DeviceInfoPlugin deviceInfoPlugin;
  final PackageInfo packageInfo;

  /// Get device information
  Future<Map<String, dynamic>> get deviceInfo;
}

class DeviceInfoDataSourceImpl extends DeviceInfoDataSource {
  DeviceInfoDataSourceImpl(
    DeviceInfoPlugin deviceInfoPlugin,
    PackageInfo packageInfo
  ) : super(
    deviceInfoPlugin: deviceInfoPlugin,
    packageInfo: packageInfo,
  );

  Map<String, dynamic>? _deviceInfo;

  @override
  Future<Map<String, dynamic>> get deviceInfo async {
    if (_deviceInfo != null) {
      return _deviceInfo!;
    }

    String? deviceModel;
    String? osVersion;
    String? osName;
    String? uuid;
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceModel = iosDeviceInfo.model;
      osVersion = iosDeviceInfo.systemVersion;
      uuid = iosDeviceInfo.identifierForVendor;// unique ID on iOS
      osName = 'iOS';
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
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