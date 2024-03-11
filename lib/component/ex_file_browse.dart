import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../entry/file.dart';
import 'ex_load.dart';
import 'ex_right_context_menu.dart';
import 'file_icon_button.dart';

typedef VoidFileItemCallback = void Function(FileItem);

enum ACTION { rename, download, open, delete }

typedef FileItemValueChanged = void Function(ACTION action, FileItem fileItem);

class ExFileBrowseController extends ValueNotifier<List<FileItem>> {
  ExFileBrowseController() : super(List.empty());

  bool _isLoad_ = true;

  @override
  set value(List<FileItem> value) {
    _isLoad_ = false;
    super.value = value;
  }

  bool get load => _isLoad_;

  set load(bool isLoad) {
    _isLoad_ = isLoad;
    notifyListeners();
  }

  String _path_ = "";

  set path(String path) {
    _path_ = path;
  }

  String get path => _path_;
}

class ExFileBrowse extends StatefulWidget {
  ExFileBrowse({super.key, required this.exFileBrowseController, this.onDoubleTap, required this.onActionPressed});

  final ExFileBrowseController exFileBrowseController;

  VoidFileItemCallback? onDoubleTap;

  final FileItemValueChanged onActionPressed;

  @override
  State<StatefulWidget> createState() => _ExFileBrowseState();
}

class _ExFileBrowseState extends State<ExFileBrowse> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.exFileBrowseController,
      builder: (BuildContext context, value, Widget? child) {
        return _ExFileListView(fileItems: widget.exFileBrowseController.value, onDoubleTap: widget.onDoubleTap, isLoad: widget.exFileBrowseController.load, onActionPressed: widget.onActionPressed);
      },
    );
  }
}

class _ExFileListView extends StatelessWidget {
  _ExFileListView({required this.fileItems, this.onDoubleTap, required this.isLoad, required this.onActionPressed});

  final List<FileItem> fileItems;
  VoidFileItemCallback? onDoubleTap;
  final bool isLoad;
  final FileItemValueChanged onActionPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoad) {
      return ExLoading();
    }
    final List<Widget> children = <Widget>[
      for (int i = 0; i < fileItems.length; i++)
        FileIconButton.fileItem(
          fileItem: fileItems[i],
          onPressed: () => {},
          onDoubleTap: () {
            if (onDoubleTap != null) {
              onDoubleTap!(fileItems[i]);
            }
          },
          fileMenuChildren: [
            ContextMenuButtonConfig(
                label: "下载",
                onPressed: (item) {
                  onActionPressed(ACTION.download, item);
                }),
            ContextMenuButtonConfig(
                label: "删除",
                onPressed: (item) {
                  onActionPressed(ACTION.delete, item);
                }),
            ContextMenuButtonConfig(
                label: "重命名",
                onPressed: (item) {
                  onActionPressed(ACTION.rename, item);
                })
          ],
          dirMenuChildren: [
            ContextMenuButtonConfig(
                label: "打开",
                onPressed: (item) {
                  onActionPressed(ACTION.open, item);
                }),
            ContextMenuButtonConfig(
                label: "重命名",
                onPressed: (item) {
                  onActionPressed(ACTION.rename, item);
                })
          ],
        )
    ];
    return Container(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: GestureDetector(
          onTap: () => {},
          child: GridView.extent(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            maxCrossAxisExtent: 120.0,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            children: children,
          ),
        ));
  }
}
