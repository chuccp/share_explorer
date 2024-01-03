import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import '../api/file.dart';
import '../util/http_client.dart';
import '../util/stream.dart';

class Progress {
  Progress(
    this.pickerResult, {
    this.id,
    this.name,
    this.count,
    this.total,
  });

  final FilePickerResult pickerResult;

  String? id;
  String? name;
  int? count;
  int? total;
  int? startTime;
  bool? isDone;

  int _speed = 0;

  String get size => _size();

  String get speed => __speed();

  String _size() {
    return convertBytes(total!);
  }

  bool isStop = false;

  bool isCancel = false;

  bool isDownload = true;

  Future<bool> pause() {
    if (isDownload) {
      isDownload = false;
    }
    return Future.value(true);
  }

  Future<bool> cancel() {
    isDownload = false;
    isStop = true;
    isCancel = true;
    return doCancel();
  }

  Future<bool> resume() {
    if (isStop) {
      isStop = false;
      isDownload = true;
      start();
    }
    return Future.value(true);
  }

  String __speed() {
    return convertBytes(_speed);
  }

  String convertBytes(int number) {
    String result = "";
    if (number >= 1024 * 1024 * 1024 * 1024) {
      result = "${number ~/ (1024 * 1024 * 1024 * 1024)} Gb";
    }
    if (number >= 1024 * 1024 * 1024) {
      result = "${number ~/ (1024 * 1024 * 1024)} Gb";
    } else if (number >= 1024 * 1024) {
      result = "${number ~/ (1024 * 1024)} Mb";
    } else if (number >= 1024) {
      result = "${number ~/ 1024} Kb";
    } else {
      result = "$number b";
    }
    return result;
  }

  VoidCallback? voidCallback;

  Future<bool> exec(String path, String rootPath) {
    count = 0;
    startTime = DateTime.now().millisecondsSinceEpoch;
    return uploadNewFile(
        path: path,
        pickerResult: pickerResult,
        rootPath: rootPath,
        progressCallback: (int count, int total) {
          var endTime = DateTime.now().millisecondsSinceEpoch;
          startTime ??= DateTime.now().millisecondsSinceEpoch;
          this.count ??= 0;
          if (endTime == startTime) {
            _speed = 0;
          } else {
            _speed = ((count - this.count!) * 1000 / (endTime - startTime!)).floor();
          }
          startTime = endTime;
          this.count = count;
          this.total = total;
          if (count == total) {
            isDone = true;
          }
          if (voidCallback != null) {
            voidCallback!();
          }
        });
  }

  List<int>? sizeList;
  String? url;
  ChunkedStreamReader<int>? chunkedStreamReader;
  int uploadNum = 0;
  dio.ProgressCallback? progressCallback;
  String? path;
  String? rootPath;
  int startIndex = 0;

  Future<bool> uploadNewFile({required String rootPath, required String path, required FilePickerResult? pickerResult, required dio.ProgressCallback progressCallback}) async {
    PlatformFile? platformFile = pickerResult?.files.first;
    if (platformFile != null) {
      url = "${HttpClient.getBaseUrl()}file/upload";
      sizeList = splitNumber(platformFile.size, 100);
      chunkedStreamReader = ChunkedStreamReader(platformFile.readStream!);
      this.progressCallback = progressCallback;
      total = platformFile.size;
      this.path = path;
      this.rootPath = rootPath;
      name = platformFile.name;
      progressCallback(uploadNum, total!);
      return start();
    }
    return Future.value(false);
  }

  Future<bool> doCancel() async {
    if (!isDone!) {
      if (chunkedStreamReader != null) {
        chunkedStreamReader!.cancel();
      }
      var url = "${HttpClient.getBaseUrl()}file/cancelUpload";
      var response = await HttpClient.get(url, queryParameters: {"size": size, "total": total, "count": sizeList!.length, "path": path, "rootPath": rootPath, "name": name});
      if (response.statusCode != 200) {
        return Future.value(false);
      }
      return Future.value(true);
    }
    return Future.value(true);
  }

  Future<bool> start() async {
    if (isCancel) {
      return Future.value(false);
    }
    for (var index = startIndex; index < sizeList!.length; index++) {
      if (isCancel) {
        break;
      }
      var size = sizeList!.elementAt(index);
      var stream = chunkedStreamReader!.readStream(size);
      var response = await HttpClient.postFile(url!,
          data: limitStream(stream), queryParameters: {"seq": index, "size": size, "total": total, "count": sizeList!.length, "path": path, "rootPath": rootPath, "name": name});
      if (response.statusCode != 200) {
        return Future.value(false);
      }
      uploadNum = uploadNum + size;
      progressCallback!(uploadNum, total!);

      if (!isDownload) {
        startIndex = index + 1;
        isStop = true;
        return Future.value(true);
      }
    }
    return Future.value(true);
  }
}
