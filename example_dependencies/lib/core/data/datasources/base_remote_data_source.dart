
import 'package:th_core/th_core.dart';
import 'device_info_data_source.dart';

///Abstract class remote data source
abstract class BaseRemoteDataSource {
  ///Constructor
  BaseRemoteDataSource(this._requester, this._deviceInfoDataSource);
  final THNetworkRequester _requester;
  final DeviceInfoDataSource _deviceInfoDataSource;

  ///Return instance of THNetworkRequester
  THNetworkRequester get requester => _requester;

  ///Get device information
  Future<Map<String, dynamic>> get deviceInfo async =>
      await _deviceInfoDataSource.deviceInfo;
}