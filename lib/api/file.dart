import '../entry/file.dart';

class FileOperate {
  static Future<List<FileItem>> rootListSync() async {
    return Future.value(<FileItem>[FileItem(name: "aaa", isDir: true, isDisk: false, path: "aaa", modifyTime: DateTime.timestamp())]);
  }

  static Future<List<FileItem>> pathListSync({required String path_}) async {
    return Future.value(<FileItem>[
      FileItem(name: "vvv", isDir: true, isDisk: false, path: "${path_}vvv", modifyTime: DateTime.timestamp()),
      FileItem(name: "zzz", isDir: true, isDisk: false, path: "${path_}zzz", modifyTime: DateTime.timestamp())
    ]);
  }
}
