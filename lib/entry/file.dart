import 'package:path/path.dart' as path2;

class FileItem {
  FileItem({this.name, this.path, this.isDir, this.size, this.modifyTime, this.isDisk});

  bool? isDir;
  bool? isDisk;
  String? name;
  String? path;
  int? size;
  DateTime? modifyTime;

  bool hasChild() {
    if (isDisk! || isDir!) {
      return true;
    } else {
      return false;
    }
  }

  factory FileItem.fromJson(Map<String, dynamic> json) {
    DateTime modify = DateTime.now();
    if (json.containsKey('modifyTime')) {
      int modifyTime = json['modifyTime'];
      modify = DateTime.fromMillisecondsSinceEpoch(modifyTime);
    }
    bool isDir = false;
    if (json.containsKey('isDir')) {
      isDir = json['isDir'];
    }

    bool isDisk = false;
    if (json.containsKey('isDisk')) {
      isDisk = json['isDisk'];
    }

    int size = 0;
    if (json.containsKey('size')) {
      size = json['size'];
    }
    String path = "";
    if (json.containsKey('path')) {
      path = json['path'];
    }
    return FileItem(name: json['name'], path: path, isDir: isDir, size: size, modifyTime: modify, isDisk: isDisk);
  }
}

class PathItem {
  PathItem(this.path, this.name);

  final String path;
  final String name;

  static List<PathItem> splitPath(String path_) {
    List<PathItem> pathItems = [];
    pathItems.add(PathItem("\\", "\\"));
    path_ = path_.trim();
    if (path_.startsWith("/") || path_.startsWith("\\")) {
      path_ = path_.substring(1);
    }

    path_ = path_.replaceAll("\\", "/");
    if (path_.isNotEmpty) {
      List<String> paths = path2.split(path_);
      var pathTemp = "";
      for (var path in paths) {
        pathTemp = "$pathTemp\\$path";
        pathItems.add(PathItem(pathTemp, path));
      }
    }
    return pathItems;
  }

  static String joinPath(List<PathItem> list) {
    if (list.length == 1) {
      return "/";
    }
    var path_ = list.last.path;
    path_ = path_.replaceAll("\\", "/");
    return path_;
  }
}

void main() {
  List<PathItem> pathItems = PathItem.splitPath("aaa/aaa/aaa");
  for (var item in pathItems) {}
}
