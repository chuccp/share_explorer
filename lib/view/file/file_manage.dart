import 'package:flutter/material.dart';
import 'package:share_explorer/api/user.dart';
import 'package:share_explorer/entry/file.dart';

import '../../api/file.dart';
import '../../component/ex_path_menu_list.dart';
import '../../component/ex_transformView.dart';

class FileManagePage extends StatefulWidget {
  const FileManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _FileManagePageState();
}

class _FileManagePageState extends State<FileManagePage> {
  Future<List<FileItem>> loadFileItemList(String rootPath, String path) {
    return FileOperate.listSync(rootPath: rootPath, path_: path);
  }

  @override
  Widget build(BuildContext context) {
    ExPathMenuController exPathMenuController = ExPathMenuController();
    ExTransformController exTransformController = ExTransformController();
    UserOperate.queryAllPath().then((value) {
      if (value.data != null && value.data!.list != null) {
        exPathMenuController.value = value.data!.list!;
      }
    });
    return ExPathMenuList(
      exPathMenuController: exPathMenuController,
      exTransformController: exTransformController,
      loadFileItemList: (String rootPath, String path) {
        return loadFileItemList(rootPath, path);
      },
    );
  }
}
