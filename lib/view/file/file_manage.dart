import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/view/file/file_explorer.dart';

import '../../component/ex_button_group.dart';

class FileManagePage extends StatefulWidget {
  const FileManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _FileManagePageState();
}

class _FileManagePageState extends State<FileManagePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        borderOnForeground: false,
        color: Colors.white,
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
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
                        titles: const ["目录A", "目录B", "目录C"],
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
                            onPressed: () {
                              GoRouter.of(context).push("/fileSetting");
                            },
                          ))
                    ],
                  ),
                ),
                const Expanded(child: FileExplorer())
              ],
            )));
  }

}
