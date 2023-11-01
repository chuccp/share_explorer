import 'package:flutter/material.dart';
import '../../component/ex_button_group.dart';
import '../../component/ex_file_process.dart';
import '../../component/file_icon_button.dart';
import '../../entry/file.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({super.key});

  @override
  State<StatefulWidget> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
      child: Column(
        children: [_FileOperate(), _FilePath(), Expanded(child: _FileListView())],
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

class _FileListView extends StatelessWidget {
  const _FileListView({super.key});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[for (var i = 0; i < 100; i++) FileIconButton.fileItem(fileItem: FileItem(isDir: i & 1 > 0, name: "文件"), onPressed: () {}, onDoubleTap: () {})];
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
