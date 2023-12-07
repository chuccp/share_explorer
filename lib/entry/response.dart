import 'dart:convert';

import 'package:share_explorer/entry/node.dart';
import 'package:share_explorer/entry/page.dart';
import 'package:share_explorer/entry/path.dart';
import 'package:share_explorer/entry/user.dart';

import '../util/json.dart';

class Response<T> {
  Response({this.code, this.data,this.error});

  int? code;
  T? data;
  String? error;

  bool isOK() {
    return code == 200;
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(code: Json.getInt(json, "code"), data: Json.getDynamic(json, "data"),error:Json.getString(json, "error") );
  }

  

  static Response<String> ok() {
    return Response<String>(code: 200, data: "ok");
  }

  static Response<ExPage<ExPath>> fromJsonToPathPage(Map<String, dynamic> json) {
    var page = Response<ExPage<ExPath>>();
    page.code = Json.getInt(json, "code");
    page.error = Json.getString(json, "error");
    var data = Json.getDynamic(json, "data");
    page.data = ExPage.fromPathJson(data);
    return page;
  }

  static Response<ExPath> fromJsonToPath(Map<String, dynamic> json) {
    var exPath = Response<ExPath>();
    exPath.code = Json.getInt(json, "code");
    exPath.error = Json.getString(json, "error");
    var data = Json.getDynamic(json, "data");

    exPath.data = ExPath.fromJson(data);
    return exPath;
  }

  static Response<ExUser> fromJsonToUser(Map<String, dynamic> json) {
    var exPath = Response<ExUser>();
    exPath.code = Json.getInt(json, "code");
    exPath.error = Json.getString(json, "error");
    var data = Json.getDynamic(json, "data");
    exPath.data = ExUser.fromJson(data) ;
    return exPath;
  }

  static Response<ExPage<ExUser>> fromJsonToUserPage(Map<String, dynamic> json) {
    var page = Response<ExPage<ExUser>>();
    page.code = Json.getInt(json, "code");
    page.error = Json.getString(json, "error");
    var data = Json.getDynamic(json, "data");
    page.data = ExPage.fromUserJson(data);
    return page;
  }

  static Response<ExPage<ExNode>> fromJsonToNodePage(Map<String, dynamic> json) {
    var page = Response<ExPage<ExNode>>();
    page.code = Json.getInt(json, "code");
    page.error = Json.getString(json, "error");
    var data = Json.getDynamic(json, "data");
    page.data = ExPage.fromNodeJson(data);
    return page;
  }

}
