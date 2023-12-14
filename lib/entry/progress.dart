import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import '../api/file.dart';

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
    return FileOperate.uploadNewFile2(
        path: path,
        pickerResult: pickerResult,
        rootPath: rootPath,
        progressCallback: (int count, int total) {
          var endTime = DateTime.now().millisecondsSinceEpoch;
          startTime ??= DateTime.now().millisecondsSinceEpoch;
          this.count??=0;
          print("${this.count}=======$count=======$endTime======$startTime");
          if(endTime == startTime){
            _speed = 0;
          }else{
            _speed = ((count - this.count!)*1000/ (endTime - startTime!)).floor();
          }

          startTime = endTime;
          this.count = count;
          this.total = total;
          if(count==total){
            isDone = true;
          }
          if (voidCallback != null) {
            voidCallback!();
          }
        });
  }
}
