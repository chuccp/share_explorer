import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:share_explorer/component/ex_dialog.dart';
import 'package:share_explorer/entry/message.dart';
import 'package:share_explorer/entry/token.dart';

import 'local_store.dart';
import '../entry/response.dart' as resp;

class HttpClient {
  static final httpClient = dio.Dio();

  static Future<Response<dynamic>> get(String url, {Map<String, dynamic>? queryParameters}) async {
    return await httpClient.get(url, queryParameters: queryParameters, options: await getOptions());
  }

  static Future<Response<dynamic>> postJson(String url, {Object? body, Map<String, dynamic>? queryParameters}) async {
    return await httpClient.post(url, data: body, queryParameters: queryParameters, options: await getOptions());
  }

  static Future<Message> postJsonForMessage(String url, {Object? body, Map<String, dynamic>? queryParameters}) async {
    var response = await postJson(url, queryParameters: queryParameters, body: body);
    if (response.statusCode != 200) {
      return Message(ok: false, msg: "系统异常", code: response.statusCode!);
    } else {
      var rs = resp.Response.fromJson(response.data);
      if (rs.code == 200 || rs.code == 203) {
        return Message(ok: true, msg: rs.error!, code: rs.code!, data: rs.data);
      }
      return Message(ok: false, msg: rs.data, code: rs.code!);
    }
  }

  static Future<Message> getForMessage(String url, {Map<String, dynamic>? queryParameters}) async {
    var response = await get(url, queryParameters: queryParameters);
    if (response.statusCode != 200) {
      return Message(ok: false, msg: "系统异常", code: response.statusCode!);
    } else {
      var rs = resp.Response.fromJson(response.data);
      if (rs.code == 200 || rs.code == 203) {
        return Message(ok: true, msg: rs.error!, code: rs.code!, data: rs.data);
      }
      return Message(ok: false, msg: rs.data, code: rs.code!);
    }
  }

  static Future<Message> getForMessageAndDialog(BuildContext context, String url, {Object? body, Map<String, dynamic>? queryParameters}) {
    return getForMessage(url, queryParameters: queryParameters).then((value) {
      if (!value.ok) {
        alertError(context: context, msg: value.msg);
      }
      return value;
    });
  }

  static Future<Message> postJsonForMessageAndDialog(BuildContext context, String url, {Object? body, Map<String, dynamic>? queryParameters}) {
    return postJsonForMessage(url, queryParameters: queryParameters, body: body).then((value) {
      if (!value.ok) {
        alertError(context: context, msg: value.msg);
      }

      return value;
    });
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
