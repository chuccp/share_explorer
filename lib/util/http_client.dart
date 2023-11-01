import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

import 'local_store.dart';

class HttpClient {
  static final httpClient = dio.Dio();



  static get(String url,{Map<String, dynamic>? queryParameters}) async {
    return await httpClient.get(url,queryParameters:queryParameters, options: await getOptions());
  }

  static postJson(String url, String body) async {
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
    // if (kReleaseMode) {
    //   return "/";
    // }
    return "http://127.0.0.1:2156/";
  }
}
