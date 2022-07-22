
import 'package:example_dependencies/example_dependencies.dart';

abstract class BaseRemoteDataSource {
  BaseRemoteDataSource(this._requester, this._deviceInfoDataSource);
  final THNetworkRequester _requester;
  final DeviceInfoDataSource _deviceInfoDataSource;

  THNetworkRequester get requester => _requester;

  ///Get device information
  Future<Map<String, dynamic>> get deviceInfo async => await _deviceInfoDataSource.deviceInfo;
}