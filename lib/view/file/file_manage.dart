import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/api/user.dart';
import 'package:share_explorer/component/ex_load.dart';
import 'package:share_explorer/view/file/file_explorer.dart';

import '../../component/ex_button_group.dart';
import '../../entry/page.dart';
import '../../entry/path.dart';
import '../../entry/response.dart';

class FileManagePage extends StatefulWidget {
  const FileManagePage({super.key});

  @override
  State<StatefulWidget> createState() => _FileManagePageState();
}

class _FileManagePageState extends State<FileManagePage> {



  List<ExPath> exPaths = [];

  _updatePaths(List<ExPath> exPaths){
    setState(() {
      this.exPaths.clear();
      this.exPaths.addAll(exPaths);
      if(exPaths.isNotEmpty){
        selectIndex = 0;
      }
    });
  }

  _updateIndex(int index){
    setState(() {
      selectIndex = index;
    });
  }

  void _queryAll(){
    UserOperate.queryAllPath().then((value){
      _updatePaths(value.data!.list!);
    });
  }

  @override
  void initState() {
    super.initState();
    _queryAll();
  }

  int selectIndex = -1;

  @override
  Widget build(BuildContext context) {

    var titles = [
      for(var ex in exPaths)
        ex.name!
    ];

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
                          child: ExButtonGroup(selectIndex:selectIndex,titles: titles,indexCallback:(index){
                            _updateIndex(index);
                          }, emptyTitle: '当前没有设置目录，请在左下角设置',)
                          ),
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
                              GoRouter.of(context).push("/fileSetting").then((value) {
                                _queryAll();
                              });
                            },
                          ))
                    ],
                  ),
                ),
                Expanded(child: Builder(builder: (BuildContext context) {
                  if(selectIndex>=0 && exPaths.isNotEmpty){
                    return  FileExplorer(exPath: exPaths[selectIndex],);
                  }else{
                    return const Text("");
                  }
                },))
              ],
            )));
  }


}
