import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_dialog.dart';

import '../../api/user.dart';
import '../../component/ex_info_card.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
      child: ListView(
        children: [
          ExInfoCard(
            title: '个人信息',
            children: [
              const Text("用户ID:AAAAAAA"),
              OutlinedButton(
                child: const Text("修改密码"),
                onPressed: () {
                  TextEditingController passwordController = TextEditingController(text: "");
                  TextEditingController newPasswordController = TextEditingController(text: "");
                  TextEditingController reNewPasswordController = TextEditingController(text: "");
                  exShowDialog(
                      title: const Text("修改密码"),
                      context: context,
                      content: SizedBox(height: 180,width: 200,child: Column(children: [
                        TextField(controller: passwordController, obscureText: true,decoration: const InputDecoration(labelText: "原密码", hintText: "原密码"),),
                        TextField(controller: newPasswordController, obscureText: true,decoration: const InputDecoration(labelText: "新密码", hintText: "新密码"),),
                        TextField(controller: reNewPasswordController, obscureText: true,decoration: const InputDecoration(labelText: "重复新密码", hintText: "重复新密码"),)
                      ],) ,) ,
                      onPressed: () {
                        return Future.value(true);
                      });
                },
              )
            ],
          ),
          const Divider(
            height: 0,
          ),
          const Divider(
            height: 0,
          ),
          ExInfoCard(
            title: '系统配置',
            children: [
              OutlinedButton(
                child: const Text("重置系统"),
                onPressed: () {
                  alertDialog(context: context, msg: "确定要重置吗?").then((value) {
                    if (value!=null && value) {
                      UserOperate.reset().then((value) => GoRouter.of(context).replace("/"));
                    }
                    return Future.value(true);

                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
