import '../util/json.dart';
class ExNode {

  ExNode({this.id, this.address,this.lastLiveTime});

  String? id;

  String? address;

  DateTime? lastLiveTime;

  factory ExNode.fromJson(Map<String, dynamic> json) {
    return ExNode(
      id: Json.getString(json, "id"),
        address: Json.getString(json, "address"),
        lastLiveTime: Json.getDateTime(json, "lastLiveTime"),
       );
  }

  static List<ExNode> fromListJson(List<dynamic> json) {
    var list = <ExNode>[];
    for (var value in json) {
      list.add(ExNode.fromJson(value));
    }
    return list;
  }
}
