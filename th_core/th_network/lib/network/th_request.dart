
import 'package:dio/dio.dart';
import 'package:th_logger/th_logger.dart';
import 'package:th_network/common/common.dart';
import 'package:th_dependencies/th_dependencies.dart' as th_dependencies;

import 'th_response.dart';

class THRequest {
  THRequest( this._dioClient);
  final Dio _dioClient;

  ///Handling errors
  THResponse<T> _handlingErrors<T>(DioError? error) {
    if (error == null) {
      THLogger().e("_handlingErrors status:${error?.requestOptions} data:${error?.message}");
      return THResponse.somethingWentWrong();
    }

    THLogger().e("_handlingErrors status:${error.response?.statusCode}\nrequest:${error.requestOptions}\nheaders:${error.response?.headers}\ndata:${error.response?.data}");
    THResponse<T> result = THResponse<T>();

    switch(error.type) {
      case DioErrorType.receiveTimeout:
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
        result.code = THErrorCodeClient.networkError;
        result.message = th_dependencies.tr(THErrorMessageKey.networkError);
        break;
      case DioErrorType.other:
        result.code = THErrorCodeClient.somethingWentWrong;
        result.message = th_dependencies.tr(THErrorMessageKey.somethingWentWrong);
        break;
      case DioErrorType.response:
        result = THResponse<T>.fromJson(error.response!);
        break;
      default:
        result.code = THErrorCodeClient.unknown;
        result.message = th_dependencies.tr(THErrorMessageKey.unknown);
        break;
    }

    return result;
  }

  ///Parse response object
  THResponse<T> _parseResponse<T>(Response? response) {
    if (response == null) return THResponse.somethingWentWrong();
    THResponse<T> result = THResponse<T>.fromJson(response);

    return result;
  }

  /// Handy method to make http GET request
  Future<THResponse<T>> get<T>(String path, {Map<String, dynamic>? queryParameters = const {}, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dioClient.get(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return _parseResponse<T>(response);
    }
    on DioError catch (error) {
      return _handlingErrors(error);
    }
    catch(exception) {
      THLogger().e(exception.toString());
      return THResponse.somethingWentWrong();
    }
  }

  /// Handy method to make http POST request
  Future<THResponse<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters = const {}, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dioClient.post(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return _parseResponse<T>(response);
    }
    on DioError catch (error) {
      return _handlingErrors(error);
    }
    catch(exception) {
      THLogger().e(exception.toString());
      return THResponse.somethingWentWrong();
    }
  }

  /// Handy method to make http PUT request
  Future<THResponse<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters = const {}, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dioClient.put(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return _parseResponse<T>(response);
    }
    on DioError catch (error) {
      return _handlingErrors(error);
    }
    catch(exception) {
      THLogger().e(exception.toString());
      return THResponse.somethingWentWrong();
    }
  }

  /// Handy method to make http DELETE request
  Future<THResponse<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters = const {}, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dioClient.delete(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return _parseResponse<T>(response);
    }
    on DioError catch (error) {
      return _handlingErrors(error);
    }
    catch(exception) {
      THLogger().e(exception.toString());
      return THResponse.somethingWentWrong();
    }
  }

  /// Handy method to make http PATCH request
  Future<THResponse<T>> patch<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters = const {}, Options? options, CancelToken? cancelToken}) async {
    try {
      final response = await _dioClient.patch(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
      return _parseResponse<T>(response);
    }
    on DioError catch (error) {
      return _handlingErrors(error);
    }
    catch(exception) {
      THLogger().e(exception.toString());
      return THResponse.somethingWentWrong();
    }
  }
}