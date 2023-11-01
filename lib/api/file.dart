import '../entry/file.dart';
import '../util/http_client.dart';
class FileOperate {
  static Future<List<FileItem>> rootListSync() async {
    var url = "${HttpClient.getBaseUrl()}file/root";
    var response = await HttpClient.get(url);
    List<dynamic> list = response.data;
    List<FileItem> fileItemList =
    list.map((e) => FileItem.fromJson(e)).toList();
    return fileItemList;
  }

  static Future<List<FileItem>> pathListSync({required String path_}) async {
    var url = "${HttpClient.getBaseUrl()}file/paths?Path=$path_";
    var response = await HttpClient.get(url,queryParameters: {"Path":path_});
    List<dynamic> list = response.data;
    List<FileItem> fileItemList =
    list.map((e) => FileItem.fromJson(e)).toList();
    return fileItemList;
  }


  static Future<List<FileItem>> listSync(
      {required String rootPath, required String path_}) async {
    var url = "${HttpClient.getBaseUrl()}file/files";
    var response = await HttpClient.get(url,queryParameters: {"Path":path_,"RootPath":rootPath});
    List<dynamic> list = response.data;
    List<FileItem> fileItemList =
    list.map((e) => FileItem.fromJson(e)).toList();
    return fileItemList;
  }

}
