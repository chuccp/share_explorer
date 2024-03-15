import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_explorer/component/ex_file_browse.dart';
import 'package:share_explorer/component/ex_file_operate.dart';
import 'package:share_explorer/component/ex_file_path.dart';

import '../../api/file.dart';
import '../../component/ex_dialog.dart';
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

  String get path => value.path;

  String get rootPath => value.rootPath;
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

class _FileExplorerState extends State<FileExplorer> {
  void load(FilePathController filePathController, ExFileBrowseController exFileBrowseController, ExFilePathController exFilePathController) {
    exFileBrowseController.load = true;
    exFilePathController.value = filePathController.value.path;
    widget.loadFileItemListCallback(filePathController.value.rootPath, filePathController.value.path).then((value) {
      exFileBrowseController.value = value;
      exFileBrowseController.path = filePathController.value.path;
    });
  }

  // ExTransformController exTransformController = ExTransformController();

  void openDir(FilePathController filePathController, ExFileBrowseController exFileBrowseController, String path) {
    if (mounted) {
      filePathController.path = path;
      exFileBrowseController.path = path;
      if (widget.onPathChanged != null) {
        widget.onPathChanged!(path);
      }
    }
  }

  void reload(FilePathController filePathController, ExFileBrowseController exFileBrowseController) {
    if (mounted) {
      filePathController.path = filePathController.path;
      exFileBrowseController.path = filePathController.path;
    }
  }

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
                  openDir(filePathController, exFileBrowseController, path);
                },
                exFilePathController: exFilePathController,
                title: widget.exPath.name!),
            Expanded(
              child: ExFileBrowse(
                exFileBrowseController: exFileBrowseController,
                onDoubleTap: (item) {
                  if (item.hasChild()) {
                    openDir(filePathController, exFileBrowseController, item.path!);
                  }else{
                    FileOperate.download(rootPath: filePathController.value.rootPath, path_: item.path!);
                  }
                },
                onActionPressed: (ACTION action, FileItem fileItem) {
                  if (action == ACTION.download && fileItem.isFile()) {
                    FileOperate.download(rootPath: filePathController.value.rootPath, path_: fileItem.path!);
                  }
                  if (action == ACTION.open && fileItem.hasChild()) {
                    openDir(filePathController, exFileBrowseController, fileItem.path!);
                  }
                  if (action == ACTION.delete && fileItem.isFile()) {
                    confirmDialog(context: context, msg: '是否删除 ${fileItem.name!}').then((value) {
                      if (value != null && value) {
                        FileOperate.delete(context, rootPath: filePathController.value.rootPath, path_: fileItem.path!).then((value) {
                          if (value.ok) {
                            reload(filePathController, exFileBrowseController);
                          }
                        });
                      }
                    });
                  }

                  if (action == ACTION.rename && !fileItem.isDisk!) {
                    TextEditingController? controller = TextEditingController();
                    exShowDialog(context: context, title: Text("重命名:${fileItem.name!}"), content: TextField(controller: controller, autofocus: true)).then((value) {
                      if (value != null && value) {
                        FileOperate.rename(context, rootPath: filePathController.rootPath, path_: filePathController.path, oldName: fileItem.name!, newName: controller.text).then((value) {
                          if (value.ok) {
                            reload(filePathController, exFileBrowseController);
                          }
                        });
                      }
                    });
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }
}
