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
