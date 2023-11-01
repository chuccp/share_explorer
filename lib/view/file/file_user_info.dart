import 'package:flutter/material.dart';
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
      child: ListView(children:  [
        ExInfoCard(title: '个人信息',children: [
          const Text("用户ID:AAAAAAA"),
          OutlinedButton(
            child:  const Text("修改密码"),
            onPressed: () {},
          )

        ],),
        const Divider(height: 0,),
        ExInfoCard(title: '网络配置',children: [
          OutlinedButton(
            child:  const Text("重置系统"),
            onPressed: () {


            },
          )

        ],),
        const Divider(height: 0,),
        ExInfoCard(title: '系统配置',children: [
          OutlinedButton(
            child:  const Text("重置系统"),
            onPressed: () {
              alertDialog(context: context, msg: "确定要重置吗?").then((value){
                if(value!){
                  UserOperate.reset();
                }
              });
            },
          )

        ],),

      ],),
    );
  }
}
