import '../entry/node.dart';
import '../entry/page.dart';
import '../entry/response.dart';
import '../util/http_client.dart';

class DiscoverOperate {
  static Future<Response<ExPage<ExNode>>> nodeList({required int pageNo, required int pageSize, required int nodeType}) async {
    var url = "${HttpClient.getBaseUrl()}discover/nodeList";
    var response = await HttpClient.get(url, queryParameters: {"pageNo": pageNo, "pageSize": pageSize, "nodeType": nodeType});
    var data = response.data;
    var res = Response.fromJsonToNodePage(data);
    return res;
  }

  static Future<bool> nodeStatus() async {
    var url = "${HttpClient.getBaseUrl()}discover/nodeStatus";
    var response = await HttpClient.get(url);
    if (response.statusCode != 200) {
      return false;
    }
    var data = response.data;
    var res = Response.fromJson(data);
    return res.isOK();
  }
}
