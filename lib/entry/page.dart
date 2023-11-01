import 'package:share_explorer/entry/path.dart';
import 'package:share_explorer/entry/user.dart';

import '../util/json.dart';

class ExPage<T> {
  ExPage({
    this.total,
    this.list,
  });

  int? total;
  List<T>? list;

  static ExPage<ExPath> fromPathJson(Map<String, dynamic> json) {
    var exPage = ExPage<ExPath>();
    exPage.total = Json.getInt(json, "total");
    exPage.list = ExPath.fromListJson(Json.getListDynamic(json, "list"));
    return exPage;
  }

  static ExPage<ExUser> fromUserJson(Map<String, dynamic> json) {
    var exPage = ExPage<ExUser>();
    exPage.total = Json.getInt(json, "total");
    exPage.list = ExUser.fromListJson(Json.getListDynamic(json, "list"));
    return exPage;
  }

  static ExPage<Map<String, dynamic>> fromJson(Map<String, dynamic> json) {
    var exPage = ExPage<Map<String, dynamic>>();
    exPage.total = Json.getInt(json, "total");
    exPage.list = Json.getListMapDynamic(json, "list");
    return exPage;
  }
}
