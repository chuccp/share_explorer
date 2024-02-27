import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:share_explorer/entry/token.dart';

import 'local_store.dart';

class HttpClient {
  static final httpClient = dio.Dio();

  static Future<Response<dynamic>> get(String url, {Map<String, dynamic>? queryParameters}) async {
    return await httpClient.get(url, queryParameters: queryParameters, options: await getOptions());
  }

  static Future<Response<dynamic>> postJson(String url, {Object? body, Map<String, dynamic>? queryParameters}) async {
    return await httpClient.post(url, data: body, queryParameters: queryParameters, options: await getOptions());
  }

  static Future<Options> getOptions() async {
    Map<String, dynamic> httpHeaders = {};
    ExToken? token = await LocalStore.getToken();
    if (token != null) {
      httpHeaders["token"] = token.token;
      httpHeaders["code"] = token.code;
      httpHeaders["username"] = token.username;
    }
    return Options(headers: httpHeaders);
  }

  static String getBaseUrl() {
    if (kReleaseMode) {
      return "/";
    }
    return "http://127.0.0.1:2156/";
  }

  static Future<Response<dynamic>> postFile(String url, {Map<String, dynamic>? queryParameters, required Object? data, dio.ProgressCallback? onSendProgress}) async {
    var options = await getOptions();
    options.headers?["Content-Type"] = "multipart/form-data";
    return await httpClient.post(url, data: data, options: options, queryParameters: queryParameters, onSendProgress: onSendProgress);
  }
}
