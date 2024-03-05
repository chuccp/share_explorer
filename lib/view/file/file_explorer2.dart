import 'dart:collection';

import 'package:context_menus/context_menus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_explorer/component/ex_path_button.dart';
import '../../api/file.dart';
import '../../component/ex_file_browse.dart';
import '../../component/ex_file_path.dart';
import '../../component/ex_load.dart';
import '../../component/ex_transformView.dart';
import '../../component/file_icon_button.dart';
import '../../entry/file.dart';
import '../../entry/path.dart';
import '../../entry/progress.dart';

class FilePageDelegate extends ChangeNotifier {
  final List<PathItem> _pathItem = [];
  final List<FileItem> _fileItems = [];

  final Map<String, Progress> _progresses = <String, Progress>{};

  final List<FocusNode> _focusNodes = [];

  UnmodifiableListView<PathItem> get items => UnmodifiableListView(_pathItem);

  PathItem get lastItem => _pathItem[_pathItem.length - 1];

  PathItem _backItems() {
    var i = index - 1;
    return _pathArrowItem[i - 1];
  }

  PathItem _forwardItems() {
    var i = index + 1;
    return _pathArrowItem[i - 1];
  }

  PathItem get backItems => _backItems();

  PathItem get forwardItems => _forwardItems();

  bool get hasBack => index > 1;

  bool get hasForward => index < _pathArrowItem.length;

  UnmodifiableListView<FileItem> get fileItems => UnmodifiableListView(_fileItems);

  UnmodifiableListView<FocusNode> get focusNodes => UnmodifiableListView(_focusNodes);

  UnmodifiableListView<Progress> get progresses => UnmodifiableListView(_progresses.values);

  int index = 0;
  final List<PathItem> _pathArrowItem = [];

  void disposeFocusNodes() {
    if (_focusNodes.isNotEmpty) {
      for (var fi in _focusNodes) {
        fi.unfocus();
      }
    }
    _focusNodes.clear();
  }

  void unFocusNodes() {
    if (_focusNodes.isNotEmpty) {
      for (var fi in _focusNodes) {
        fi.unfocus();
      }
    }
  }

  String _rootPath = "";
  String _path = "";

  String get rootPath => _rootPath;

  String get path => _path;

  void reset() {
    _focusNodes.clear();
    _fileItems.clear();
    _pathArrowItem.clear();
  }

  void toPath({required String path, required List<FileItem> fileItems, required bool isArrow, required String rootPath}) {
    _rootPath = rootPath;
    _path = path;
    _focusNodes.addAll([for (var _ in fileItems) FocusNode()]);
    _pathItem.clear();
    _pathItem.addAll(PathItem.splitPath(path));
    _fileItems.clear();
    _fileItems.addAll(fileItems);
    if (!isArrow) {
      _pathArrowItem.clear();
      _pathArrowItem.addAll(_pathItem);
      index = _pathArrowItem.length;
    } else {
      index = _pathItem.length;
    }
    notifyListeners();
  }
}

void loadFileAsset({required BuildContext context, required String rootPath, required String path, required bool isArrow}) {
  Provider.of<FilePageDelegate>(context, listen: false).disposeFocusNodes();
  FileOperate.listSync(path_: path, rootPath: rootPath)
      .then((value) => {Provider.of<FilePageDelegate>(context, listen: false).toPath(path: path, fileItems: value, isArrow: isArrow, rootPath: rootPath)})
      .onError((error, stackTrace) => {Provider.of<FilePageDelegate>(context, listen: false).toPath(path: path, fileItems: [], isArrow: isArrow, rootPath: rootPath)});
}

void refresh({required BuildContext context}) {
  var rootPath = Provider.of<FilePageDelegate>(context, listen: false).rootPath;
  var path = Provider.of<FilePageDelegate>(context, listen: false).path;
  loadFileAsset(context: context, rootPath: rootPath, path: path, isArrow: false);
}

void goUpPath({required BuildContext context}) {
  var rootPath = Provider.of<FilePageDelegate>(context, listen: false).rootPath;
  var path = Provider.of<FilePageDelegate>(context, listen: false).path;
  var pathItems = PathItem.splitPath(path);
  if (pathItems.length > 1) {
    pathItems.removeLast();
    var ppp = PathItem.joinPath(pathItems);
    loadFileAsset(context: context, rootPath: rootPath, path: ppp, isArrow: false);
  }
}

class FileExplorer extends StatelessWidget {
  const FileExplorer({super.key, required this.exPath});

  final ExPath exPath;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FilePageDelegate(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Column(
          children: [
            const _FileOperate(),
            _FilePath(exPath: exPath),
            Expanded(
                child: _FileListView(
              rootPath: exPath.path!,
            ))
          ],
        ),
      ),
    );
  }
}

void _uploadFile(BuildContext context, String rootPath, FilePickerResult? pickerResult, ExTransformController exTransformController) {
  var path = Provider.of<FilePageDelegate>(context, listen: false).path;
  var id = DateTime.timestamp().millisecond;
  String? name = pickerResult?.names.first;
  var progress = Progress(pickerResult!, id: "$id", name: name, total: pickerResult.files.first.size);
  exTransformController.add(progress);
  progress.exec(path, rootPath).then((value) {
    if (value) {
      loadFileAsset(context: context, rootPath: rootPath, path: path, isArrow: false);
    }
  });
}

void createFolder({required BuildContext context, required String rootPath, required String folder}) {
  var lastItem = Provider.of<FilePageDelegate>(context, listen: false).lastItem;
  FileOperate.createNewFolder(path: lastItem.path, folder: folder, rootPath: rootPath).then((value) => {
        if (value) {loadFileAsset(context: context, rootPath: rootPath, path: lastItem.path, isArrow: false)}
      });
}

class _FileOperate extends StatelessWidget {
  const _FileOperate({super.key});

  @override
  Widget build(BuildContext context) {
    ExTransformController exTransformController = ExTransformController();
    exTransformController.finish(() {
      refresh(context: context);
    });
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("上传"),
                onPressed: () {
                  var rootPath = Provider.of<FilePageDelegate>(context, listen: false).rootPath;
                  Future<FilePickerResult?> result = FilePicker.platform.pickFiles(withReadStream: true);
                  result.then((value) {
                    if (value != null) {
                      _uploadFile(context, rootPath, value, exTransformController);
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text("新建文件夹"),
                  onPressed: () {
                    TextEditingController unameController = TextEditingController();
                    showDialog<String>(
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
                                    onPressed: () => Navigator.pop(context2, 'Cancel'),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (unameController.text.isNotEmpty) {
                                        var rootPath = Provider.of<FilePageDelegate>(context, listen: false).rootPath;
                                        createFolder(context: context, rootPath: rootPath, folder: unameController.text);
                                        unameController.clear();
                                      }
                                      Navigator.pop(context2, 'OK');
                                    },
                                    child: const Text('确认'),
                                  ),
                                ]));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.cached),
                  label: const Text("刷新"),
                  onPressed: () {
                    refresh(context: context);
                  },
                ),
              )
            ],
          )),
          SizedBox(
              width: 100,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: MenuAnchor(
                  crossAxisUnconstrained: false,
                  anchorTapClosesMenu: false,
                  style: MenuStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(0)), mouseCursor: MaterialStateProperty.all(SystemMouseCursors.basic)),
                  builder: (BuildContext context, MenuController controller, Widget? child) {
                    return IconButton(
                      icon: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                    );
                  },
                  menuChildren: [
                    ExTransformView(
                      exTransformController: exTransformController,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class _FilePath extends StatelessWidget {
  const _FilePath({super.key, required this.exPath});

  final ExPath exPath;

  @override
  Widget build(BuildContext context) {
    ExFilePathController exFilePathController = ExFilePathController();
    return ExFilePath(exFilePathController: exFilePathController, title: exPath.name!,);
  }
}



class _FileListView extends StatefulWidget {
  const _FileListView({super.key, required this.rootPath});

  final String rootPath;

  @override
  State<StatefulWidget> createState() => _FileListViewState();
}

class _FileListViewState extends State<_FileListView> {
  @override
  void initState() {
    loadFileAsset(context: context, rootPath: widget.rootPath, path: "/", isArrow: false);

  }

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<FilePageDelegate>(context).fileItems;
    // var focusNodes = Provider.of<FilePageDelegate>(context).focusNodes;
    // var rootPath = Provider.of<FilePageDelegate>(context).rootPath;
    // if (rootPath.isEmpty || widget.rootPath != rootPath) {
    //   Provider.of<FilePageDelegate>(context).reset();
    //   loadFileAsset(context: context, rootPath: widget.rootPath, path: "/", isArrow: false);
    //   return ExLoading();
    // }
    // final List<Widget> children = <Widget>[
    //   for (int i = 0; i < items.length; i++)
    //     FileIconButton.fileItem(
    //       fileItem: items[i],
    //       focusNode: focusNodes.elementAt(i),
    //       onPressed: () => {focusNodes.elementAt(i).requestFocus()},
    //       onDoubleTap: () {
    //         if (items[i].isDir!) {
    //           loadFileAsset(context: context, rootPath: widget.rootPath, path: items[i].path!, isArrow: false);
    //         } else {
    //           Future.delayed(const Duration(milliseconds: 100)).then((value) {
    //             FileOperate.download(rootPath: widget.rootPath, path_: items[i].path!);
    //           });
    //           Provider.of<FilePageDelegate>(context, listen: false).unFocusNodes();
    //         }
    //       },
    //     )
    //     // right_context_menu.ExRightContextMenu(menuChildren: [ right_context_menu.ContextMenuButtonConfig(label: "下载"),right_context_menu.ContextMenuButtonConfig(label: "删除")],
    //     // child: )
    // ];
    //
    // return Container(
    //     padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
    //     child: GestureDetector(
    //       onTap: () => {},
    //       child: GridView.extent(
    //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    //         maxCrossAxisExtent: 120.0,
    //         crossAxisSpacing: 5,
    //         mainAxisSpacing: 5,
    //         children: children,
    //       ),
    //     ));
    ExFileBrowseController exFileBrowseController = ExFileBrowseController();
    exFileBrowseController.value = items;
    return ExFileBrowse(
      exFileBrowseController: exFileBrowseController,
    );
  }
}
