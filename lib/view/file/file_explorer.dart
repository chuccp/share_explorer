import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/file.dart';
import '../../component/ex_button_group.dart';
import '../../component/ex_file_process.dart';
import '../../component/ex_load.dart';
import '../../component/file_icon_button.dart';
import '../../entry/file.dart';
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

  UnmodifiableListView<FileItem> get fileItems =>
      UnmodifiableListView(_fileItems);

  UnmodifiableListView<FocusNode> get focusNodes =>
      UnmodifiableListView(_focusNodes);

  UnmodifiableListView<Progress> get progresses =>
      UnmodifiableListView(_progresses.values);

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

  String get rootPath => _rootPath;

  void toPath(
      {required String path,
        required List<FileItem> fileItems,
        required bool isArrow,
        required String rootPath}) {
    _rootPath = rootPath;
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


void loadFileAsset(
    {required BuildContext context,
      required String rootPath,
      required String path,
      required bool isArrow}) {
  Provider.of<FilePageDelegate>(context, listen: false).disposeFocusNodes();
  FileOperate.listSync(path_: path, rootPath: rootPath).then((value) => {
    Provider.of<FilePageDelegate>(context, listen: false).toPath(
        path: path, fileItems: value, isArrow: isArrow, rootPath: rootPath)
  });
}

class FileExplorer extends StatelessWidget {
  const FileExplorer({super.key, required this.rootPath});

 final String rootPath;

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) => FilePageDelegate(),
      child:  Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
        child: Column(
          children: [const _FileOperate(), const _FilePath(), Expanded(child: _FileListView(rootPath: rootPath,))],
        ),
      ),
    );

  }
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
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text("新建文件夹"),
                  onPressed: () {},
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
  const _FilePath({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Row(
          children: [
            const Text("返回上一级"),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 12,
              child: const VerticalDivider(width: 3, color: Colors.black26, indent: 1),
            ),
            const _PathView(),
          ],
        ));
  }
}

class _PathView extends StatelessWidget {
  const _PathView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Text("全部文件"), Text(">"), Text("全部文件")]);
  }
}
class _FileListView extends StatefulWidget{

  const _FileListView({super.key, required this.rootPath});

  final String rootPath;

  @override
  State<StatefulWidget> createState()=>_FileListViewState();

}
class _FileListViewState extends State<_FileListView> {


  @override
  Widget build(BuildContext context) {
    var items = Provider.of<FilePageDelegate>(context).fileItems;
    var focusNodes = Provider.of<FilePageDelegate>(context).focusNodes;
    var rootPath = Provider.of<FilePageDelegate>(context).rootPath;
    if (rootPath.isEmpty || widget.rootPath!=rootPath){
      loadFileAsset(context: context, rootPath: widget.rootPath, path: "/", isArrow: false);
      return  ExLoading();
    }
    final List<Widget> children = <Widget>[
      for (int i = 0; i < items.length; i++)
        FileIconButton.fileItem(
          fileItem: items[i],
          focusNode: focusNodes.elementAt(i),
          onPressed: () => {focusNodes.elementAt(i).requestFocus()},
          onDoubleTap: () {
            if (items[i].isDir!) {
              loadFileAsset(context:context, rootPath:widget.rootPath, path:items[i].path!, isArrow:false);
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
        )
    ];


    return Container(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: GestureDetector(
          onTap: () => {},
          child: GridView.extent(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            maxCrossAxisExtent: 120.0,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: children,
          ),
        ));
  }


}
