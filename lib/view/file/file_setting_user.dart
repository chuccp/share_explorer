import 'package:flutter/material.dart';
import 'package:share_explorer/component/ex_checkbox_list.dart';
import 'package:share_explorer/entry/user.dart';

import '../../api/user.dart';
import '../../component/ex_dialog.dart';
import '../../component/ex_table.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<StatefulWidget> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  DataTableController dataTableController = DataTableController(columnNames: ["ID", "用户","证书", "角色", "创建时间"]);

  late int pageNo;
  List<ExUser>? list;

  void query(int pageNo) {
    this.pageNo = pageNo;
    UserOperate.queryUser(pageNo: pageNo, pageSize: 10).then((value) {
      list = value.data!.list;
      var total = value.data!.total;
      var dataList = <List<dynamic>>[
        for (var ele in list!) <dynamic>[ele.id, ele.username, TextButton(onPressed: (){
          UserOperate.downloadUserCert(username: ele.username!);
        }, child: const Text("下载")),ele.role, ele.createTime]
      ];
      dataTableController.updateTable(dataList, total!, 1);
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
        TextEditingController usernameController = TextEditingController();
        TextEditingController passwordController = TextEditingController();
        ExCheckboxController exCheckboxController = ExCheckboxController([]);
        exShowDialog(
            title: const Text("添加用户"),
            context: context,
            content: _AddUserView(
              usernameController: usernameController,
              passwordController: passwordController,
              exCheckboxController: exCheckboxController,
            ),
            onPressed: () {
              return UserOperate.addUser(username: usernameController.text, password: passwordController.text, pathIds: exCheckboxController.selectIds).then((value) {
                if (value.isOK()) {
                  query(pageNo);
                  return true;
                } else {
                  return false;
                }
              });
            });
      },
      deleteCallback: (index) {
        if (list != null && list!.isNotEmpty) {
          alertDialog(context: context, msg: '确认删除吗?').then((value) => {
                if (value!)
                  {
                    UserOperate.deleteUser(username: list![index].username!).then((value) {
                      if (value.isOK()) {
                        query(pageNo);
                      } else {
                        alertError(context: context, msg: value.error!);
                      }
                    })
                  }
              });
        }
      },
      editCallback: (index) {
        TextEditingController usernameController = TextEditingController();
        TextEditingController passwordController = TextEditingController();
        ExCheckboxController exCheckboxController = ExCheckboxController([]);
        exShowDialog(
            title: const Text("编辑用户"),
            context: context,
            content: _AddUserView(usernameController: usernameController, passwordController: passwordController, exCheckboxController: exCheckboxController, userId: list![index].id),
            onPressed: () {
              return UserOperate.editUser(id:list![index].id!,username: usernameController.text, password: passwordController.text, pathIds: exCheckboxController.selectIds).then((value) {
                if (value.isOK()) {
                  query(pageNo);
                  return true;
                } else {
                 Future.delayed(const Duration(milliseconds: 100)).then((_){
                   alertError(context: context, msg: value.error!);
                 } );
                  return true;
                }
              });
            });
      },
      onPageChanged: (int pageNo) {
        UserOperate.queryUser(pageNo: pageNo, pageSize: 10).then((value) {
          var list = value.data!.list;
          var total = value.data!.total;
          var dataList = <List<dynamic>>[
            for (var ele in list!) <dynamic>[ele.id, ele.username, ele.role, ele.createTime]
          ];
          dataTableController.updateTable(dataList, total!, pageNo);
        });
      },
    );
  }
}

class _AddUserView extends StatelessWidget {
  _AddUserView({required this.usernameController, required this.passwordController, required this.exCheckboxController, this.userId});

  final TextEditingController usernameController;

  final TextEditingController passwordController;

  final ExCheckboxController exCheckboxController;

  int? userId;

  @override
  Widget build(BuildContext context) {
    UserOperate.queryAllPath().then((value) {
      var checkboxNodeList = <CheckboxNode>[for (var exPath in value.data!.list!) CheckboxNode(id: exPath.id, name: exPath.name)];
      exCheckboxController.value = checkboxNodeList;
      if (userId != null) {
        UserOperate.queryOneUser(userId: userId!).then((value) {
          if (value.isOK()) {
            usernameController.text = value.data!.username!;
            passwordController.text = value.data!.password!;
            exCheckboxController.selectIds = value.data!.pathIds!;
          }
        });
      }
    });
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
