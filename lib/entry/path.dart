import '../util/json.dart';

class ExPath {
  ExPath({
    this.id,
    this.name,
    this.path,
    this.createTime,
    this.updateTime,
  });

  int? id;

  String? name;

  String? path;

  DateTime? createTime;

  DateTime? updateTime;

  factory ExPath.fromJson(Map<String, dynamic> json) {
    return ExPath(
        id: Json.getInt(json, "id"),
        name: Json.getString(json, "name"),
        path: Json.getString(json, "path"));
  }

  static List<ExPath> fromListJson(List<dynamic> json) {
    var list = <ExPath>[];
    for (var value in json) {
      list.add(ExPath.fromJson(value));
    }
    return list;
  }
}
