import '../entry/info.dart';
import '../entry/page.dart';
import '../entry/path.dart';
import '../entry/response.dart';
import '../entry/user.dart';

class UserOperate {
  static Future<InfoItem> info() async {
    var infoItem = InfoItem(hasInit: false, remoteAddress: <String>["127.0.0.1:4565", "127.0.0.1:4566"]);
    return infoItem;
  }

  static Future<Response<ExPage<ExPath>>> queryPath({required int pageNo, required int pageSize}) async {
    var list = <Map<String, dynamic>>[
      for (var i = 0; i < pageSize; i++) {"id": i + (pageNo * pageSize), "name": "name_${pageNo}_$i", "path": "path_${pageNo}_$i"}
    ];
    Map<String, dynamic> data = {"total": 200, "list": list};
    Map<String, dynamic> json = {"code": 200, "data": data};
    return Response.fromJsonToPathPage(json);
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

    return Response.ok();
  }

  static Future<Response<ExPage<ExUser>>> queryUser({required int pageNo, required int pageSize}) async {
    var list = <Map<String, dynamic>>[
      for (var i = 0; i < pageSize; i++) {"id": i + (pageNo * pageSize), "username": "name_${pageNo}_$i", "createTime": 0}
    ];
    Map<String, dynamic> data = {"total": 200, "list": list};
    Map<String, dynamic> json = {"code": 200, "data": data};
    return Response.fromJsonToUserPage(json);
  }
}
