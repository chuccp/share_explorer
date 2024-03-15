import 'dart:async';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:share_explorer/entry/message.dart';
import '../entry/file.dart';
import '../entry/token.dart';
import '../util/download.dart';
import '../util/http_client.dart';
import '../util/local_store.dart';
import '../util/stream.dart';
import '../entry/response.dart' as resp;

class FileOperate {
  static Future<List<FileItem>> rootListSync() async {
    var url = "${HttpClient.getBaseUrl()}file/root";
    var response = await HttpClient.get(url);
    List<dynamic> list = response.data;
    List<FileItem> fileItemList = list.map((e) => FileItem.fromJson(e)).toList();
    return fileItemList;
  }

  static Future<List<FileItem>> pathListSync({required String path_}) async {
    var url = "${HttpClient.getBaseUrl()}file/paths?Path=$path_";
    var response = await HttpClient.get(url, queryParameters: {"Path": path_});
    List<dynamic> list = response.data;
    List<FileItem> fileItemList = list.map((e) => FileItem.fromJson(e)).toList();
    return fileItemList;
  }

  static Future<List<FileItem>> listSync({required String rootPath, required String path_}) async {
    var url = "${HttpClient.getBaseUrl()}file/files";
    var response = await HttpClient.get(url, queryParameters: {"Path": path_, "RootPath": rootPath});
    List<dynamic> list = response.data;
    List<FileItem> fileItemList = list.map((e) => FileItem.fromJson(e)).toList();
    return fileItemList;
  }

  static void download({required String rootPath, required String path_}) async {
    ExToken? token = await LocalStore.getToken();
    var url =
        "${HttpClient.getBaseUrl()}file/download?path=${Uri.encodeComponent(path_)}&rootPath=${Uri.encodeComponent(rootPath)}&username=${Uri.encodeComponent(token!.username!)}&code=${Uri.encodeComponent(token!.code!)}&Token=${Uri.encodeComponent(token!.token!)}";
    downloadUrl(url);
  }

  static Future<Message> delete(BuildContext context, {required String rootPath, required String path_}) {
    var url = "${HttpClient.getBaseUrl()}file/delete";
    return HttpClient.getForMessageAndDialog(context, url, queryParameters: {"rootPath": rootPath, "path": path_});
  }

  static Future<Message> rename(BuildContext context, {required String rootPath, required String path_,required String oldName,required String newName}) {
    var url = "${HttpClient.getBaseUrl()}file/rename";
    return HttpClient.postJsonForMessageAndDialog(context, url,body: {"path": path_, "rootPath": rootPath, "oldName": oldName,"newName":newName});
  }

  static Future<bool> uploadNewFile({required String rootPath, required String path, required FilePickerResult? pickerResult, required dio.ProgressCallback progressCallback}) async {
    PlatformFile? platformFile = pickerResult?.files.first;
    if (platformFile != null) {
      var url = "${HttpClient.getBaseUrl()}file/upload";
      var sizeList = splitNumber(platformFile.size, 100);
      var chunkedStreamReader = ChunkedStreamReader(platformFile.readStream!);
      int uploadNum = 0;
      for (var index = 0; index < sizeList.length; index++) {
        progressCallback(uploadNum, platformFile.size);
        var size = sizeList.elementAt(index);
        var stream = chunkedStreamReader.readStream(size);
        var response = await HttpClient.postFile(url,
            data: stream, queryParameters: {"seq": index, "size": size, "total": platformFile.size, "count": sizeList.length, "path": path, "rootPath": rootPath, "name": platformFile.name});
        if (response.statusCode != 200) {
          return Future.value(false);
        } else {
          var res = resp.Response.fromJson(response.data);
          if (!res.isOK()) {
            return Future.value(false);
          }
        }
        uploadNum = uploadNum + size;
      }
      progressCallback(uploadNum, platformFile.size);
      return Future.value(true);
    }
    return Future.value(false);
  }

  static Future<bool> createNewFolder({required String rootPath, required String path, required String folder}) async {
    var response = await HttpClient.postJson("${HttpClient.getBaseUrl()}file/createNewFolder", body: {"path": path, "rootPath": rootPath, "folder": folder});
    if (response.statusCode == 200) {
      return Future.value(true);
    }
    return false;
  }
}
