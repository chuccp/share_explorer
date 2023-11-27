import '../util/json.dart';

class ExUser {
  ExUser({this.id, this.username, this.role, this.createTime, this.updateTime});

  int? id;

  String? username;

  String? role;

  DateTime? createTime;

  DateTime? updateTime;

  factory ExUser.fromJson(Map<String, dynamic> json) {
    return ExUser(
        id: Json.getInt(json, "id"),
        username: Json.getString(json, "username"),
        role: Json.getString(json, "role"),
        createTime: Json.getDateTime(json, "createTime"),
        updateTime: Json.getDateTime(json, "updateTime"));
  }

  static List<ExUser> fromListJson(List<dynamic> json) {
    var list = <ExUser>[];
    for (var value in json) {
      list.add(ExUser.fromJson(value));
    }
    return list;
  }
}
