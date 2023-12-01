import '../util/json.dart';
class ExNode {

  ExNode({this.nodeType, this.serverName, this.address,this.lastLiveTime});

  int? nodeType;

  String? serverName;

  String? address;

  DateTime? lastLiveTime;

  factory ExNode.fromJson(Map<String, dynamic> json) {
    return ExNode(
        nodeType: Json.getInt(json, "nodeType"),
        serverName: Json.getString(json, "serverName"),
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
