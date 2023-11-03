import 'dart:collection';


import 'package:context_menus/context_menus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_explorer/component/ex_path_button.dart';
import '../../api/file.dart';
import '../../component/ex_button_group.dart';
import '../../component/ex_file_process.dart';
import '../../component/ex_load.dart';
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

  void updateProgresses(Progress progress) {
    if (_progresses.containsKey(progress.id)) {
      _progresses[progress.id]!.count = progress.count;
    } else {
      _progresses[progress.id!] = progress;
    }
    notifyListeners();
  }

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

void _uploadFile(BuildContext context, String rootPath, FilePickerResult? pickerResult) {
  var path = Provider.of<FilePageDelegate>(context, listen: false).path;
  var id = DateTime.timestamp().millisecond;
  String? name = pickerResult?.names.first;
  FileOperate.uploadNewFile(
      path: path,
      pickerResult: pickerResult,
      rootPath: rootPath,
      progressCallback: (int count, int total) {
        var progress = Progress(id: id.toString(), name: name, count: count, total: total);
        Provider.of<FilePageDelegate>(context, listen: false).updateProgresses(progress);
      }).then((value) => {
        if (value) {loadFileAsset(context: context, rootPath: rootPath, path: path, isArrow: false)}
      });
}

class _FileOperate extends StatelessWidget {
  const _FileOperate({super.key});

  @override
  Widget build(BuildContext context) {
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
                      _uploadFile(context, rootPath, value);
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text("新建文件夹"),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.cached),
                  label: const Text("刷新"),
                  onPressed: () {
                    var rootPath = Provider.of<FilePageDelegate>(context, listen: false).rootPath;
                    var path = Provider.of<FilePageDelegate>(context, listen: false).path;
                    loadFileAsset(context: context, rootPath: rootPath, path: path, isArrow: false);
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
                  menuChildren: const [_TransformView()],
                ),
              ))
        ],
      ),
    );
  }
}

class _TransformView extends StatelessWidget {
  const _TransformView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 400,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: ExButtonGroup(
              titles: const ["文件上传(0)"],
              emptyTitle: '',
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: 400,
            child: const VerticalDivider(width: 3, color: Colors.black26, indent: 1),
          ),
          const ExFileProcessList()
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
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Row(
          children: [
            ExPathButton(
              title: "返回上一级",
              hasPress: true,
              onPressed: () {},
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 12,
              child: const VerticalDivider(width: 3, color: Colors.black26, indent: 1),
            ),
            _PathView(
              exPath: exPath,
            ),
          ],
        ));
  }
}

class _PathView extends StatelessWidget {
  const _PathView({super.key, required this.exPath});

  final ExPath exPath;

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<FilePageDelegate>(context).items;
    final List<Widget> children = [];

    children.add(
      ExPathButton(
        hasPress: items.isNotEmpty,
        onPressed: () {},
        title: exPath.name!,
      ),
    );
    children.add(const Text(">"));
    var len = items.length;
    for (var i = 0; i < len; i++) {
      children.add(ExPathButton(
        hasPress: i < len - 1,
        onPressed: () {},
        title: items[i].name,
      ));
      children.add(const Text(">"));
    }
    return Row(children: children);
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
  Widget build(BuildContext context) {
    var items = Provider.of<FilePageDelegate>(context).fileItems;
    var focusNodes = Provider.of<FilePageDelegate>(context).focusNodes;
    var rootPath = Provider.of<FilePageDelegate>(context).rootPath;
    if (rootPath.isEmpty || widget.rootPath != rootPath) {
      Provider.of<FilePageDelegate>(context).reset();
      loadFileAsset(context: context, rootPath: widget.rootPath, path: "/", isArrow: false);
      return ExLoading();
    }
    final List<Widget> children = <Widget>[
      for (int i = 0; i < items.length; i++)

    ContextMenuRegion(contextMenu:  GenericContextMenu(buttonConfigs: [ ContextMenuButtonConfig(
      "删除",
      onPressed: () {

        print(items[i].name);


      },
    ),ContextMenuButtonConfig(
      "重命名",
      onPressed: () {

        print(items[i].name);


      },
    ),],),
    child: FileIconButton.fileItem(
      fileItem: items[i],
      focusNode: focusNodes.elementAt(i),
      onPressed: () => {focusNodes.elementAt(i).requestFocus()},
      onDoubleTap: () {
        if (items[i].isDir!) {
          loadFileAsset(context: context, rootPath: widget.rootPath, path: items[i].path!, isArrow: false);
        } else {
          Future.delayed(const Duration(milliseconds: 100)).then((value) {
            // FilePicker.platform.saveFile(fileName: items[i].name).then((value) {
            //   if (value != null && value.isNotEmpty) {
            //     FileOperate.downLoadFile(fileItem: items[i], localPath: value);
            //   }
            // });
          });
          Provider.of<FilePageDelegate>(context, listen: false).unFocusNodes();
        }
      },
    ),)
        
        
    ];

    return Container(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: GestureDetector(
          onTap: () => {},
          child: ContextMenuOverlay(child: GridView.extent(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            maxCrossAxisExtent: 120.0,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: children,
          ),)  ,
        ));
  }
}
