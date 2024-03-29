import 'package:flutter/material.dart';

import '../../api/file.dart';
import '../../api/user.dart';
import '../../component/ex_dialog.dart';
import '../../component/ex_table.dart';
import '../../component/ex_tree_file.dart';
import '../../entry/path.dart';

class PathList extends StatefulWidget {
  const PathList({super.key});

  @override
  State<StatefulWidget> createState() => _PathListState();
}

class _PathListState extends State<PathList> {
  DataTableController dataTableController = DataTableController(columnNames: ["ID", "名称", "路径"]);

  late int pageNo;

  List<ExPath>? list;

  void query(int pageNo) {
    this.pageNo = pageNo;
    UserOperate.queryPath(pageNo: pageNo, pageSize: dataTableController.page.pageSize!).then((value) {
      list = value.data!.list;
      var total = value.data!.total;
      var dataList = <List<dynamic>>[
        for (var ele in list!) <dynamic>[ele.id, ele.name, ele.path]
      ];
      dataTableController.updateTable(dataList, total!, pageNo);
    });
  }

  @override
  void initState() {
    query(1);
  }

  @override
  Widget build(BuildContext context) {
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
            )).then((value) {
          if (value != null && value) {
            UserOperate.addPath(name: nameController.text, path: pathController.text).then((value) {
              if (value.isOK()) {
                query(pageNo);
                return true;
              } else {
                return false;
              }
            });
          }
        });
      },
      deleteCallback: (int index) {
        if (list != null && list!.isNotEmpty) {
          alertDialog(context: context, msg: '确认删除吗?').then((value) => {
                if (value!) {UserOperate.deletePath(id: list![index].id!).then((value) => query(pageNo))}
              });
        }
      },
      editCallback: (int index) {
        TextEditingController nameController = TextEditingController();
        TextEditingController pathController = TextEditingController();
        exShowDialog(
          title: const Text("修改路径"),
          context: context,
          content: _AddPathView(nameController: nameController, pathController: pathController, id: list![index].id!),
        ).then((value) {
          if (value != null && value) {
            UserOperate.editPath(id: list![index].id!, name: nameController.text, path: pathController.text).then((value) {
              if (value.isOK()) {
                query(pageNo);
                return true;
              } else {
                return false;
              }
            });
          }
        });
      },
      onPageChanged: (int pageNo) {
        query(pageNo);
      },
    );
  }
}

class _AddPathView extends StatelessWidget {
  _AddPathView({required this.nameController, required this.pathController, this.id});

  final TextEditingController nameController;

  final TextEditingController pathController;

  int? id;

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      UserOperate.queryOnePath(id: id!).then((value) {
        ExPath? exPath = value.data;
        if (exPath != null) {
          nameController.text = exPath.name!;
          pathController.text = exPath.path!;
        }
      });
    }
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
