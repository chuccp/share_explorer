import 'package:flutter/material.dart';

import '../../api/file.dart';
import '../../api/user.dart';
import '../../component/ex_dialog.dart';
import '../../component/ex_table.dart';
import '../../component/ex_tree_file.dart';

class PathList extends StatelessWidget {
  const PathList({super.key});

  @override
  Widget build(BuildContext context) {
    DataTableController dataTableController = DataTableController(columnNames: ["ID", "名称", "路径"]);
    UserOperate.queryPath(pageNo: 1, pageSize: dataTableController.page.pageSize!).then((value) {
      var list = value.data!.list;
      var total = value.data!.total;
      var dataList = <List<dynamic>>[
        for (var ele in list!) <dynamic>[ele.id, ele.name, ele.path]
      ];
      dataTableController.updateTable(dataList, total!, 1);
    });
    return ExTable(
      dataTableController: dataTableController,
      addCallback: () {
        TextEditingController nameController = TextEditingController();
        TextEditingController pathController = TextEditingController();
        exShowDialog(
            title: const Text("添加路径"),
            context: context,
            content: _AddPathView(
              nameController: nameController,
              pathController: pathController,
            ),
            onPressed: () {
              return Future(() => true);
            });
      },
      deleteCallback: (int index) {
        print(index);
      },
      onPageChanged: (int pageNo) {
        UserOperate.queryPath(pageNo: pageNo, pageSize: dataTableController.page.pageSize!).then((value) {
          var list = value.data!.list;
          var total = value.data!.total;
          var dataList = <List<dynamic>>[
            for (var ele in list!) <dynamic>[ele.id, ele.name, ele.path]
          ];
          dataTableController.updateTable(dataList, total!, pageNo);
        });
      },
    );
  }
}

class _AddPathView extends StatelessWidget {
  const _AddPathView({required this.nameController, required this.pathController});

  final TextEditingController nameController;

  final TextEditingController pathController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      width: 400,
      child: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "别名",
              hintText: "别名",
            ),
          ),
          TextField(
            readOnly: true,
            controller: pathController,
            decoration: const InputDecoration(labelText: "远程目录", hintText: "从下面选择路径"),
          ),
          ExTreeFile(
            rootCall: () {
              return FileOperate.rootListSync();
            },
            pathCall: (key) {
              return FileOperate.pathListSync(path_: key);
            },
            onChanged: (String value) {
              pathController.text = value;
            },
          )
        ],
      ),
    );
  }
}
