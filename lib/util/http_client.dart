import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'local_store.dart';

class HttpClient {
  static final httpClient = dio.Dio();



  static  Future<Response<dynamic>> get(String url,{Map<String, dynamic>? queryParameters}) async {
    return await httpClient.get(url,queryParameters:queryParameters, options: await getOptions());
  }

  static Future<Response<dynamic>> postJson(String url, Object? body) async {
    return await httpClient.post(url, data: body, options: await getOptions());
  }

  static Future<Options> getOptions() async {
    Map<String, dynamic> httpHeaders = {};
    String? token = await LocalStore.getToken();
    if (token != null) {
      httpHeaders["token"] = token;
    }
    return Options(headers: httpHeaders);
  }

  static String getBaseUrl() {
    if (kReleaseMode) {
      return "/";
    }
    return "http://127.0.0.1:2156/";
  }

  static Future<Response<dynamic>> postFile(String url, {required dio.FormData data, required dio.ProgressCallback onSendProgress}) async {
    return await httpClient.post(url,data: data,onSendProgress:onSendProgress);
  }
}
