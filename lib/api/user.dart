import 'dart:convert';
import 'dart:io';

import '../entry/info.dart';
import '../entry/page.dart';
import '../entry/path.dart';
import '../entry/response.dart';
import '../entry/user.dart';
import '../util/download.dart';
import '../util/http_client.dart';
import '../util/local_store.dart';

class UserOperate {
  static Future<InfoItem> info() async {
    var url = "${HttpClient.getBaseUrl()}user/info";
    var response = await HttpClient.get(url);
    var data = response.data;
    var infoItem = InfoItem.fromJson(data);
    return infoItem;
  }

  static Future<InfoItem> reset() async {
    var url = "${HttpClient.getBaseUrl()}user/reset";
    var response = await HttpClient.get(url);
    var data = response.data;
    var infoItem = InfoItem.fromJson(data);
    return infoItem;
  }

  static Future<Response> connect({required String address}) async {
    var url = "${HttpClient.getBaseUrl()}user/connect?address=$address";
    var response = await HttpClient.get(url);
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }



  static Future<Response<ExPage<ExPath>>> queryPath(
      {required int pageNo, required int pageSize}) async {
    var url = "${HttpClient.getBaseUrl()}user/queryPath?pageNo=$pageNo&pageSize=$pageSize";
    var response = await HttpClient.get(url);
    var data = response.data;
    var res = Response.fromJsonToPathPage(data);
    return res;
  }


  static Future<Response> addPath({required String name, required String path}) async {
    var url = "${HttpClient.getBaseUrl()}user/addPath";
    var postData = {
      "name": name,
      "path": path,
    };
    var response = await HttpClient.postJson(url, jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response> deletePath({required int id}) async {
    var url = "${HttpClient.getBaseUrl()}user/deletePath";
    var response = await HttpClient.get(url,queryParameters: {
      "id": id,
    });
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }


  static Future<Response<ExPage<ExPath>>> queryAllPath() async {
    var url = "${HttpClient.getBaseUrl()}user/queryAllPath";
    var response = await HttpClient.get(url);
    var data = response.data;
    var res = Response.fromJsonToPathPage(data);
    return res;
  }

  static Future<Response<ExPage<Map<String, dynamic>>>> queryJsonPath({required int pageNo, required int pageSize}) async {
    var list = <Map<String, dynamic>>[
      for (var i = 0; i < pageSize; i++) {"id": i + (pageNo * pageSize), "name": "name_${pageNo}_$i", "path": "path_${pageNo}_$i"}
    ];
    Map<String, dynamic> data = {"total": 200, "list": list};
    Map<String, dynamic> json = {"code": 200, "data": data};
    return Response.fromJson(json);
  }

  static Future<Response> addAdminUser(
      {required String username, required String password, required String rePassword, required bool isNatClient, required bool isNatServer, required List<String> addresses}) async {
    var postData = {"username": username, "password": password, "rePassword": rePassword, "isNatClient": isNatClient, "isNatServer": isNatServer,"addresses":addresses};
    var url = "${HttpClient.getBaseUrl()}user/addAdmin";
    var response = await HttpClient.postJson(url, jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }
  static Future<Response> addClient(
      { required List<String> addresses}) async {
    var postData = {"addresses":addresses};
    var url = "${HttpClient.getBaseUrl()}user/addClient";
    var response = await HttpClient.postJson(url, jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response<ExPage<ExUser>>> queryUser({required int pageNo, required int pageSize}) async {
    var list = <Map<String, dynamic>>[
      for (var i = 0; i < pageSize; i++) {"id": i + (pageNo * pageSize), "username": "name_${pageNo}_$i", "createTime": 0}
    ];
    Map<String, dynamic> data = {"total": 200, "list": list};
    Map<String, dynamic> json = {"code": 200, "data": data};
    return Response.fromJsonToUserPage(json);
  }

  static Future<void> downloadCert() async {
    String? token = await LocalStore.getToken();
    var url = "${HttpClient.getBaseUrl()}user/downloadCert?Token=$token";
    downloadUrl(url);
  }
}
