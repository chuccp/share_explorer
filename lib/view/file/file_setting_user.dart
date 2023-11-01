import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_explorer/component/ex_checkbox_list.dart';

import '../../api/user.dart';
import '../../component/ex_dialog.dart';
import '../../component/ex_table.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    DataTableController dataTableController = DataTableController(columnNames: ["ID", "用户", "创建时间"]);
    UserOperate.queryUser(pageNo: 1, pageSize: 10).then((value) {
      var list = value.data!.list;
      var total = value.data!.total;
      var dataList = <List<dynamic>>[
        for (var ele in list!) <dynamic>[ele.id, ele.username, ele.createTime]
      ];
      dataTableController.updateTable(dataList, total!, 1);
    });
    return ExTable(
      dataTableController: dataTableController,
      addCallback: () {
        TextEditingController usernameController = TextEditingController();
        TextEditingController passwordController = TextEditingController();
        exShowDialog(
            title: const Text("添加用户"),
            context: context,
            content: _AddUserView(
              usernameController: usernameController,
              passwordController: passwordController,
            ),
            onPressed: () {
              return Future(() => true);
            });
      },
      deleteCallback: (index) {},
      editCallback: (index) {},
      onPageChanged: (int pageNo) {
        UserOperate.queryUser(pageNo: pageNo, pageSize: 10).then((value) {
          var list = value.data!.list;
          var total = value.data!.total;
          var dataList = <List<dynamic>>[
            for (var ele in list!) <dynamic>[ele.id, ele.username, ele.createTime]
          ];
          dataTableController.updateTable(dataList, total!, pageNo);
        });
      },
    );
  }
}

class _AddUserView extends StatelessWidget {
  const _AddUserView({required this.usernameController, required this.passwordController});

  final TextEditingController usernameController;

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    ExCheckboxController exCheckboxController = ExCheckboxController([
      CheckboxNode(id: 0, name: "aaa"),
      CheckboxNode(id: 1, name: "aaa"),
      CheckboxNode(id: 2, name: "aaa"),
      CheckboxNode(id: 3, name: "aaa"),
      CheckboxNode(id: 4, name: "aaa"),
      CheckboxNode(id: 5, name: "aaa")
    ]);
    return SizedBox(
      height: 375,
      width: 400,
      child: Column(
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: "用户名",
              hintText: "用户名",
            ),
          ),
          TextField(
            autofocus: true,
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "密码",
              hintText: "密码",
            ),
          ),
          const ListTile(
            title: Text("目录选择"),
          ),
          Expanded(
              child: ExCheckboxList(
            exCheckboxController: exCheckboxController,
          ))
        ],
      ),
    );
  }
}
