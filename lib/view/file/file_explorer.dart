import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_explorer/component/ex_file_browse.dart';
import 'package:share_explorer/component/ex_file_operate.dart';
import 'package:share_explorer/component/ex_file_path.dart';

import '../../api/file.dart';
import '../../component/ex_transformView.dart';
import '../../entry/file.dart';
import '../../entry/path.dart';
import '../../entry/progress.dart';

typedef LoadFileItemListCallback = Future<List<FileItem>> Function(String rootPath, String path);

class FilePath {
  FilePath({
    required this.path,
    required this.rootPath,
  });

  String rootPath;
  String path;
}

class FilePathController extends ValueNotifier<FilePath> {
  FilePathController({
    required ExPath exPath,
  }) : super(FilePath(path: "\\", rootPath: exPath.path!));

  set path(String path) {
    value.path = path;
    notifyListeners();
  }
}

class FileExplorer extends StatefulWidget {
  FileExplorer({super.key, required this.exPath, this.onPathChanged, required this.loadFileItemListCallback, required this.exFileBrowseController});

  final ExPath exPath;

  ValueChanged<String>? onPathChanged;

  final LoadFileItemListCallback loadFileItemListCallback;

  final ExFileBrowseController exFileBrowseController;

  @override
  State<StatefulWidget> createState() => _FileExplorerState();
}

class _UploadFilePath {
  const _UploadFilePath(this.success, this.rootPath, this.path);

  final bool success;
  final String rootPath;
  final String path;
}

Future<_UploadFilePath> _uploadFile(BuildContext context, String rootPath, String path, ExTransformController exTransformController, FilePickerResult? pickerResult) {
  var id = DateTime.timestamp().millisecond;
  String? name = pickerResult?.names.first;
  var progress = Progress(pickerResult!, id: "$id", name: name, total: pickerResult.files.first.size);
  exTransformController.add(progress);
  return progress.exec(path, rootPath).then((value) => _UploadFilePath(value, rootPath, path));
}

class _FileExplorerState extends State<FileExplorer> {
  void load(FilePathController filePathController, ExFileBrowseController exFileBrowseController, ExFilePathController exFilePathController) {
    exFileBrowseController.load = true;
    exFilePathController.value = filePathController.value.path;
    widget.loadFileItemListCallback(filePathController.value.rootPath,  filePathController.value.path).then((value) {
      exFileBrowseController.value = value;
    });
  }

  // ExTransformController exTransformController = ExTransformController();

  @override
  Widget build(BuildContext context) {
    FilePathController filePathController = FilePathController(exPath: widget.exPath);
    return ValueListenableBuilder(
      valueListenable: filePathController,
      builder: (BuildContext context, value, Widget? child) {
        ExFilePathController exFilePathController = ExFilePathController();
        ExFileBrowseController exFileBrowseController = widget.exFileBrowseController;
        load(filePathController, exFileBrowseController, exFilePathController);
        return Column(
          children: [
            // ExFileOperate(
            //   onUpload: () {
            //     Future<FilePickerResult?> result = FilePicker.platform.pickFiles(withReadStream: true);
            //     result.then((value) {
            //       if (value != null) {
            //         _uploadFile(context, filePathController.value.rootPath, filePathController.value.path, exTransformController, value).then((value) {
            //           if (value.success) {
            //             if (filePathController.value.rootPath == value.rootPath && filePathController.value.path == value.path) {
            //               load(filePathController, exFileBrowseController, exFilePathController);
            //             }
            //           }
            //         });
            //       }
            //     });
            //   },
            //   onCreateNewFile: () {
            //     TextEditingController unameController = TextEditingController();
            //     showDialog<bool>(
            //         context: context,
            //         builder: (BuildContext context2) => AlertDialog(
            //                 title: const Text('新建文件夹'),
            //                 content: TextField(
            //                   autofocus: true,
            //                   controller: unameController,
            //                   decoration: const InputDecoration(hintText: "文件名", prefixIcon: Icon(Icons.folder)),
            //                 ),
            //                 actions: <Widget>[
            //                   TextButton(
            //                     onPressed: () {
            //                       Navigator.of(context2).pop(false);
            //                     },
            //                     child: const Text('取消'),
            //                   ),
            //                   TextButton(
            //                     onPressed: () {
            //                       FileOperate.createNewFolder(rootPath: filePathController.value.rootPath, path: filePathController.value.path, folder: unameController.text).then((value) {
            //                         if (value) {
            //                           Navigator.of(context2).pop(true);
            //                         }
            //                       });
            //
            //                       // if (unameController.text.isNotEmpty) {
            //                       //   unameController.clear();
            //                       // }
            //
            //                       // Navigator.of(context).pop(true);
            //                     },
            //                     child: const Text('确认'),
            //                   ),
            //                 ])).then((value){
            //
            //                   if(value!){
            //                     load(filePathController, exFileBrowseController, exFilePathController);
            //                   }
            //
            //     });
            //   },
            //   onRefresh: () {
            //     load(filePathController, exFileBrowseController, exFilePathController);
            //   },
            //   exTransformController: exTransformController,
            // ),
            ExFilePath(
                onPressed: (path) {
                  filePathController.path = path;
                  if (widget.onPathChanged != null) {
                    widget.onPathChanged!(path);
                  }
                },
                exFilePathController: exFilePathController,
                title: widget.exPath.name!),
            Expanded(
              child: ExFileBrowse(
                  exFileBrowseController: exFileBrowseController,
                  onDoubleTap: (item) {
                    if (item.hasChild()) {
                      filePathController.path = item.path!;
                      if (widget.onPathChanged != null) {
                        widget.onPathChanged!(item.path!);
                      }
                    }
                  }),
            )
          ],
        );
      },
    );
  }
}
