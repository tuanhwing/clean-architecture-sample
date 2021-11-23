
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:th_logger/th_logger.dart';
import 'package:th_network/common/th_network_defines.dart';
import 'package:th_dependencies/th_dependencies.dart' as th_dependencies;

import 'network/network.dart';
import 'common/common.dart';

class THNetworkRequester {
  // static final THNetworkRequester _singleton = THNetworkRequester._internal();
  // factory THNetworkRequester() {
  //   return _singleton;
  // }
  // THNetworkRequester._internal();

  late THRequest? _request;
  late String _refreshTokenPath;
  late String _authorizationPrefix;
  final Dio _tokenDio = Dio();
  final Dio _dio = Dio();
  final List<THNetworkListener> _listeners = [];
  final th_dependencies.FlutterSecureStorage storage;
  Future<THResponse>? _refreshTokenFuture;
  int _reSubmitterCount = 0;

  String? _token;
  String? _refreshToken;
  String? get token => _token;

  THNetworkRequester(String baseURL, this.storage, {
    int connectTimeout=5000,
    int receiveTimeout=3000,
    required String authorizationPrefix,
    required String refreshTokenPath}) {
    _refreshTokenPath = refreshTokenPath;
    _authorizationPrefix = authorizationPrefix;

    //Options
    _dio.options.baseUrl = baseURL;
    _dio.options.connectTimeout = connectTimeout;
    _dio.options.receiveTimeout = receiveTimeout;

    //Instance to request the token.
    _tokenDio.options.baseUrl = baseURL;
    _tokenDio.options.connectTimeout = connectTimeout;
    _tokenDio.options.receiveTimeout = receiveTimeout;

    _tokenDio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = "$_authorizationPrefix $_refreshToken";
          return handler.next(options);
        },
        onResponse: (response, handler) {
          THLogger().d("[REFRESH_TOKEN]REQUEST\nmethod: ${response.requestOptions.method}\n"
              "path: ${response.requestOptions.path}\nheaders:${response.requestOptions.headers}\n"
              "RESPONSE\nstatusCode: ${response.statusCode}\ndata: ${response.data}");

          //Update new token
          setToken(response.data['data']['token'], response.data['data']['refresh_token']);
          _dio.interceptors.requestLock.unlock();
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          THLogger().d("[REFRESH_TOKEN]DioError\ntype: ${error.type}\nmessage: ${error.message}\n\n"
              "RESPONSE\nstatusCode: ${error.response?.statusCode}\ndata: ${error.response?.data}");
          _dio.interceptors.requestLock.clear();
          if (error.response?.statusCode == 401) {//Session expired
            _notifyListeners();
          }
          return handler.next(error);
        }
    ));


    //Instance to request network.
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = "$_authorizationPrefix $_token";
          return handler.next(options);
        },
        onResponse: (response, handler) {
          THLogger().d("REQUEST\nmethod: ${response.requestOptions.method}\n"
              "path: ${response.requestOptions.path}\nheaders:${response.requestOptions.headers}\n"
              "queryParameters: ${response.requestOptions.queryParameters}\ndata: ${response.requestOptions.data}\n\n\n"
              "RESPONSE\nstatusCode: ${response.statusCode}\ndata: ${response.data}");
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          THLogger().d("DioError\ntype: ${error.type}\nmessage: ${error.message}\n\n"
              "REQUEST\npath: ${error.requestOptions.path}\nheaders:${error.requestOptions.headers}"
              "queryParameters: ${error.requestOptions.queryParameters}\ndata: ${error.requestOptions.data}\n\n "
              "RESPONSE\nstatusCode: ${error.response?.statusCode}\ndata: ${error.response?.data}");

          return handler.next(error);
        }
    ));

    _request = THRequest(_dio);
  }

  ///Notify all listeners
  void _notifyListeners() {
    for (var element in _listeners) {
      element.sessionExpired();
    }
  }

  ///Initializes [THNetworkRequester] instance
  Future<void> initialize() async {

    //Read token value
    _token = await storage.read(key: THNetworkDefines.tokenKey);
    _refreshToken = await storage.read(key: THNetworkDefines.refreshTokenKey);
  }

  ///Fetch request
  Future<THResponse<T>> _fetch<T>(THRequestMethods method,
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        Options? options
      }) async {
    THResponse<T> thResponse = THResponse.somethingWentWrong();
    switch(method) {
      case THRequestMethods.get:
        thResponse = await _request!.get(path, queryParameters: queryParameters, options: options);
        break;
      case THRequestMethods.post:
        thResponse = await _request!.post(path, data: data, queryParameters: queryParameters, options: options);
        break;
      case THRequestMethods.put:
        thResponse = await _request!.put(path, data: data, queryParameters: queryParameters, options: options);
        break;
      case THRequestMethods.delete:
        thResponse = await _request!.delete(path, data: data, queryParameters: queryParameters, options: options);
        break;
      case THRequestMethods.patch:
        thResponse = await _request!.patch(path, data: data, queryParameters: queryParameters, options: options);
        break;
    }
    
    return thResponse;
  }

  Future<THResponse<T>> _fetchNewToken<T>() async {
    try {
      final response = await _tokenDio.get(_refreshTokenPath);
      return THResponse<T>.fromJson(response);
    }
    on DioError catch (error) {
      return THResponse<T>.fromJson(error.response!);
    }
    catch(exception) {
      THLogger().e(exception.toString());
      return THResponse.somethingWentWrong();
    }
  }


  ///Set token
  Future setToken(String token, String refreshToken) async {
    _token = token;
    _refreshToken = refreshToken;

    // Write token
    await storage.write(key: THNetworkDefines.tokenKey, value: _token);
    await storage.write(key: THNetworkDefines.refreshTokenKey, value: _refreshToken);
  }

  ///Delete token
  Future removeToken() async {
    _refreshToken = null;
    _token = null;

    // Write token
    await storage.delete(key: THNetworkDefines.tokenKey);
    await storage.delete(key: THNetworkDefines.refreshTokenKey);
  }

  void addListener(THNetworkListener listener) => _listeners.add(listener);
  void removeListener(THNetworkListener listener) => _listeners.remove(listener);

  ///Perform network request
  Future<THResponse<T>> executeRequest<T>(
      THRequestMethods method,
      String path, {
        Map<String, dynamic>? queryParameters,
        dynamic data,
        Options? options
      }) async {


    THResponse<T> thResponse = await _fetch(method, path, queryParameters: queryParameters, data: data, options: options);

    if (thResponse.statusCode == 401) {//Unauthorized
      _reSubmitterCount++;//Increment request count to resubmit
      _dio.lock();
      _refreshTokenFuture ??= _fetchNewToken();

      THResponse response = await _refreshTokenFuture!;
      if (response.statusCode == 200) {
        _reSubmitterCount--;//Decrement request count to resubmit
        if (_reSubmitterCount == 0) {
          _refreshTokenFuture = null;
        }
        thResponse = await _fetch(method, path, queryParameters: queryParameters, data: data, options: options);
      }
      else {
        thResponse = response.clone<T>();
      }

    }
    return thResponse;
  }
}