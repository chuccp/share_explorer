import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as dio;
import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_dialog_loading.dart';
import '../component/ex_dialog.dart';
import '../component/ex_load.dart';
import '../entry/info.dart';
import '../entry/page.dart';
import '../entry/path.dart';
import '../entry/response.dart';
import '../entry/token.dart';
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

  static void connect({required String address, required BuildContext context}) {
    var url = "${HttpClient.getBaseUrl()}user/connect?address=$address";
    exShowDialogLoading(
        title: const Text("网络测试中"),
        context: context,
        onFinish: (value) {
          if (value.isOK()) {
            alertDialog(context: context, msg: value.data);
          } else {
            alertDialog(context: context, msg: value.error!);
          }
        },
        onLoadingData: () {
          return HttpClient.get(url).then((response) => response.data).then((data) => Response.fromJson(data)).then((value) {
            return value;
          });
        });
  }

  static Future<Response<ExPage<ExPath>>> queryPath({required int pageNo, required int pageSize}) async {
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
    var response = await HttpClient.postJson(url, body: jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response> editPath({required int id, required String name, required String path}) async {
    var url = "${HttpClient.getBaseUrl()}user/editPath";
    var postData = {
      "name": name,
      "id": id,
      "path": path,
    };
    var response = await HttpClient.postJson(url, body: jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response> deletePath({required int id}) async {
    var url = "${HttpClient.getBaseUrl()}user/deletePath";
    var response = await HttpClient.get(url, queryParameters: {
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

  static Future<Response<ExPath>> queryOnePath({required int id}) async {
    var url = "${HttpClient.getBaseUrl()}user/queryOnePath";
    var response = await HttpClient.get(url, queryParameters: {
      "id": id,
    });
    var data = response.data;
    var res = Response.fromJsonToPath(data);
    return res;
  }

  static Future<Response> addAdminUser(
      {required String username, required String password, required String rePassword, required bool isServer, required bool isNatServer, required List<String> addresses}) async {
    var postData = {"username": username, "password": password, "rePassword": rePassword, "isServer": isServer, "isNatServer": isNatServer, "addresses": addresses};
    var url = "${HttpClient.getBaseUrl()}user/addAdmin";
    var response = await HttpClient.postJson(url, body: jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response> addClient({required List<String> addresses}) async {
    var postData = {"addresses": addresses};
    var url = "${HttpClient.getBaseUrl()}user/addClient";
    var response = await HttpClient.postJson(url, body: jsonEncode(postData));
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static void uploadUserCert({required FilePickerResult? pickerResult, required String code, required dio.ProgressCallback progressCallback, required BuildContext context}) {
    exShowDialogLoading(
        title: const Text("证书上传中"),
        context: context,
        onFinish: (value) {},
        onLoading: () {
          PlatformFile? platformFile = pickerResult?.files.first;
          if (platformFile != null) {
            final formData = dio.FormData.fromMap({'code': code, 'cert': dio.MultipartFile.fromStream(() => platformFile.readStream!, platformFile.size, filename: platformFile.name)});
            var url = "${HttpClient.getBaseUrl()}user/uploadUserCert";
            return HttpClient.postFile(url, data: formData, onSendProgress: progressCallback).then((response) => response.data).then((data) => Response.fromJson(data)).then((value) {
              return value.isOK();
            });
          } else {
            return Future.value(false);
          }
        }).then((value) {
      if (value != null && value) {
        exShowDialog(
            context: context,
            title: const Text("上传成功"),
            onPressed: () {
              return Future(() => true);
            }).then((value) {
          if (value != null && value) {
            GoRouter.of(context).replace("/clientLogin");
          }
        });
      } else {
        alertDialog(context: context, msg: "上传失败");
      }
    });
  }

  static Future<Response> addUser({required String username, required String password, required String pathIds}) async {
    var postData = {"username": username, "password": password, "pathIds": pathIds};
    var url = "${HttpClient.getBaseUrl()}user/addUser";
    var response = await HttpClient.postJson(url, body: postData);
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response> editUser({required int id, required String username, required String password, required String pathIds}) async {
    var postData = {"id": id, "username": username, "password": password, "pathIds": pathIds};
    var url = "${HttpClient.getBaseUrl()}user/editUser";
    var response = await HttpClient.postJson(url, body: postData);
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response<ExPage<ExUser>>> queryUser({required int pageNo, required int pageSize}) async {
    var url = "${HttpClient.getBaseUrl()}user/queryUser?pageNo=$pageNo&pageSize=$pageSize";
    var response = await HttpClient.get(url);
    var data = response.data;
    var res = Response.fromJsonToUserPage(data);
    return res;
  }

  static Future<Response<ExUser>> queryOneUser({required int userId}) async {
    var url = "${HttpClient.getBaseUrl()}user/queryOneUser";
    var response = await HttpClient.get(url, queryParameters: {"userId": userId});
    var data = response.data;
    var res = Response.fromJsonToUser(data);
    return res;
  }

  static Future<Response> deleteUser({required String username}) async {
    var url = "${HttpClient.getBaseUrl()}user/deleteUser";
    var response = await HttpClient.get(url, queryParameters: {
      "username": username,
    });
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<Response> signIn({required String username, required String password, String? code, required bool start}) async {
    var url = "${HttpClient.getBaseUrl()}user/signIn";
    var response = await HttpClient.postJson(url, body: {"username": username, "password": password}, queryParameters: {"username": username, "code": code, "start": start});
    var data = response.data;
    var res = Response.fromJson(data);
    return res;
  }

  static Future<void> downloadCert() async {
    ExToken? token = await LocalStore.getToken();
    var url = "${HttpClient.getBaseUrl()}user/downloadCert?Token=${token!.token}&code=${token.code}&username=${token.username}";
    downloadUrl(url);
  }

  static Future<void> downloadUserCert({required String username}) async {
    ExToken? token = await LocalStore.getToken();
    var url = "${HttpClient.getBaseUrl()}user/downloadUserCert?username=$username&Token=${token!.token}&code=${token.code}&username=${token.username}";
    downloadUrl(url);
  }
}
