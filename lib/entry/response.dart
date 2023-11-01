import 'dart:convert';

import 'package:share_explorer/entry/page.dart';
import 'package:share_explorer/entry/path.dart';
import 'package:share_explorer/entry/user.dart';

import '../util/json.dart';

class Response<T> {
  Response({this.code, this.data});

  int? code;
  T? data;

  bool isOK() {
    return code == 200;
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(code: Json.getInt(json, "code"), data: Json.getDynamic(json, "data"));
  }

  static Response<String> ok() {
    return Response<String>(code: 200, data: "ok");
  }

  static Response<ExPage<ExPath>> fromJsonToPathPage(Map<String, dynamic> json) {
    var page = Response<ExPage<ExPath>>();
    page.code = Json.getInt(json, "code");
    var data = Json.getDynamic(json, "data");
    page.data = ExPage.fromPathJson(data);
    return page;
  }

  static Response<ExPage<ExUser>> fromJsonToUserPage(Map<String, dynamic> json) {
    var page = Response<ExPage<ExUser>>();
    page.code = Json.getInt(json, "code");
    var data = Json.getDynamic(json, "data");
    page.data = ExPage.fromUserJson(data);
    return page;
  }
}
