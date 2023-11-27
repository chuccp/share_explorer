import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
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

  static Future<bool> uploadNewFile(
      {required String rootPath,
        required String path,
        required FilePickerResult? pickerResult,
        required dio.ProgressCallback progressCallback}) async {
    PlatformFile? platformFile = pickerResult?.files.first;
    if (platformFile != null) {
      final formData = dio.FormData.fromMap({
        'Path': path,
        "RootPath": rootPath,
        'file': dio.MultipartFile.fromStream(
                () => platformFile.readStream!, platformFile.size,
            filename: platformFile.name)
      });
      var url = "${HttpClient.getBaseUrl()}file/upload";
      var response = await HttpClient.postFile(url, data: formData, onSendProgress: progressCallback);
      if (response.statusCode == 200) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  static Future<bool> createNewFolder(
      {required String rootPath,
        required String path,
        required String folder}) async {
    var response = await HttpClient.postJson("${HttpClient.getBaseUrl()}file/createNewFolder",
       {
          "path": path,
          "rootPath": rootPath,
          "folder": folder
        });
    if (response.statusCode == 200) {
      return Future.value(true);
    }
    return false;
  }


}
