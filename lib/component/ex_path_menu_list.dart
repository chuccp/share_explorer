import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_explorer/entry/path.dart';

import '../api/file.dart';
import '../entry/file.dart';
import '../entry/progress.dart';
import '../view/file/file_explorer.dart';
import 'ex_button_group.dart';
import 'ex_file_browse.dart';
import 'ex_file_operate.dart';
import 'ex_transformView.dart';

class ExPathMenuController extends ValueNotifier<List<ExPath>> {
  ExPathMenuController() : super(List.empty());

  int _selectIndex = 0;

  @override
  set value(List<ExPath> value) {
    super.value = value;
  }

  ExPath get selectExPath => super.value[_selectIndex];

  int get selectIndex => _selectIndex;

  set selectIndex(int selectIndex) {
    _selectIndex = selectIndex;
    notifyListeners();
  }
}

class _UploadFilePath {
  const _UploadFilePath(this.success, this.rootPath, this.path);

  final bool success;
  final String rootPath;
  final String path;
}

class ExPathMenuList extends StatelessWidget {
  const ExPathMenuList({super.key, required this.exPathMenuController, required this.exTransformController, required this.loadFileItemList, required this.onPressSetting});

  final ExPathMenuController exPathMenuController;

  final ExTransformController exTransformController;

  final LoadFileItemListCallback loadFileItemList;

  final VoidCallback  onPressSetting;

  void refresh(ExFileBrowseController exFileBrowseController) {
    exFileBrowseController.load = true;
    loadFileItemList(exPathMenuController.selectExPath.path!, exFileBrowseController.path).then((value) {
      exFileBrowseController.value = value;
    });
  }

  Future<_UploadFilePath> _uploadFile(BuildContext context, String rootPath, String path, ExTransformController exTransformController, FilePickerResult? pickerResult) {
    var id = DateTime.timestamp().millisecond;
    String? name = pickerResult?.names.first;
    var progress = Progress(pickerResult!, id: "$id", name: name, total: pickerResult.files.first.size);
    exTransformController.add(progress);
    return progress.exec(path, rootPath).then((value) => _UploadFilePath(value, rootPath, path));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: exPathMenuController,
      builder: (BuildContext context, value, Widget? child) {
        ExFileBrowseController exFileBrowseController = ExFileBrowseController();
        var titles = [for (var ex in exPathMenuController.value) ex.name!];
        return Material(
            borderOnForeground: false,
            color: Colors.white,
            child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Column(
                        children: [
                          const ListTile(
                            title: Row(
                              children: [Icon(Icons.account_circle_rounded), Text("文件管理")],
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.black26,
                          ),
                          Expanded(
                              child: ExButtonGroup(
                            selectIndex: 0,
                            titles: titles,
                            indexCallback: (index) {
                              exPathMenuController.selectIndex = index;
                            },
                            emptyTitle: '当前没有设置目录，请在左下角设置',
                          )),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.black26,
                          ),
                          SizedBox(
                              height: 50,
                              child: IconButton(
                                splashRadius: 20,
                                icon: const Icon(Icons.settings),
                                onPressed: onPressSetting,
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                      child: Column(
                        children: [
                          ExFileOperate(
                              exTransformController: exTransformController,
                              onUpload: () {
                                Future<FilePickerResult?> result = FilePicker.platform.pickFiles(withReadStream: true);
                                result.then((value) {
                                  if (value != null) {
                                    _uploadFile(context, exPathMenuController.selectExPath.path!, exFileBrowseController.path, exTransformController, value).then((value) {
                                      if (value.success) {
                                        refresh(exFileBrowseController);
                                      }
                                    });
                                  }
                                });
                              },
                              onCreateNewFile: () {
                                TextEditingController unameController = TextEditingController();
                                showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context2) => AlertDialog(
                                            title: const Text('新建文件夹'),
                                            content: TextField(
                                              autofocus: true,
                                              controller: unameController,
                                              decoration: const InputDecoration(hintText: "文件名", prefixIcon: Icon(Icons.folder)),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context2).pop(false);
                                                },
                                                child: const Text('取消'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  FileOperate.createNewFolder(rootPath: exPathMenuController.selectExPath.path!, path: exFileBrowseController.path, folder: unameController.text)
                                                      .then((value) {
                                                    if (value) {
                                                      Navigator.of(context2).pop(true);
                                                    }
                                                  });
                                                },
                                                child: const Text('确认'),
                                              ),
                                            ])).then((value) {
                                  if (value!) {
                                    refresh(exFileBrowseController);
                                  }
                                });
                              },
                              onRefresh: () {
                                refresh(exFileBrowseController);
                              }),
                          Expanded(child: Builder(
                            builder: (BuildContext context) {
                              if (exPathMenuController.selectIndex >= 0 && exPathMenuController.value.isNotEmpty) {
                                return FileExplorer(
                                  exPath: exPathMenuController.selectExPath,
                                  loadFileItemListCallback: (String rootPath, String path) {
                                    return loadFileItemList(rootPath, path).then((value) {
                                      return value;
                                    });
                                  },
                                  exFileBrowseController: exFileBrowseController,
                                );
                              } else {
                                return const Text("");
                              }
                            },
                          ))
                        ],
                      ),
                    ))
                  ],
                )));
      },
    );
  }
}
