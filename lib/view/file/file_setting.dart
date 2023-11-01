import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_load.dart';

import '../../component/ex_button_group.dart';
import 'file_setting_path.dart';
import 'file_setting_user.dart';
import 'file_user_info.dart';

class FileSettingPage extends StatefulWidget {
  const FileSettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _FileSettingPageState();
}

class _FileSettingPageState extends State<FileSettingPage> {
  int selectIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderOnForeground: false,
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            IconButton(
                              splashRadius: 20,
                              icon: const Icon(Icons.arrow_back_rounded),
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                            ),
                            const Text("设置")
                          ],
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
                              selectIndex: selectIndex,
                              titles: const ["用户管理", "目录管理", "个人中心"],
                              indexCallback: (index) {
                                setState(() {
                                  selectIndex = index;
                                });
                              })),
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                  child: Builder(
                    builder: (BuildContext context) {
                      if (selectIndex == 1) {
                        return const PathList();
                      }
                      if (selectIndex == 0) {
                        return const UserList();
                      }
                      if (selectIndex == 2) {
                        return const UserInfo();
                      }
                      return ExLoading();
                    },
                  ),
                ))
              ],
            )));
  }
}
