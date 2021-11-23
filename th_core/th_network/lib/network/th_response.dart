
import 'package:dio/dio.dart';
import 'package:th_dependencies/th_dependencies.dart';

import '../common/common.dart';

class THResponse<T> {
  THResponse({this.statusCode = 200, this.code, this.data, this.message});
  int? statusCode;
  int? code;
  T? data;
  String? message;//error message

  ///Whether this response object is success or not
  bool get success => code != null && statusCode != null && code == 0 && statusCode == 200;

  factory THResponse.fromJson(Response? response) {
    if (response == null) return THResponse.somethingWentWrong();
    try {
      return THResponse(
        statusCode: response.statusCode,
        code: response.data['code'],
        data: response.data['data'],
        message: response.data['error_message']
      );
    }
    catch (exception) {
      return THResponse.somethingWentWrong();
    }
  }

  factory THResponse.somethingWentWrong() {
    return THResponse(
      code: THErrorCodeClient.somethingWentWrong,
      message: tr(THErrorMessageKey.somethingWentWrong)
    );
  }


  THResponse<Obj> clone<Obj>({Obj? data}) {
    return THResponse<Obj>(
      statusCode: statusCode,
      code: code,
      data: data,
      message: message
    );
  }
}