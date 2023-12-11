import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/user.dart';
import '../component/ex_card.dart';
import '../component/ex_login.dart';
import '../entry/info.dart';
import '../util/local_store.dart';

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  State<StatefulWidget> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLoginPage> {
  @override
  Widget build(BuildContext context) {
    ExLoginController exLoginController = ExLoginController();
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 412,
          title: "客户端登录",
          body: ExLogin(
            isServer: true,
            exLoginController: exLoginController,
          ),
          // footer: FooterButtonGroup(width: 240,leftFex:12,rightFex: 8,leftButtonText: "切换用户", onLeftPressed: () {}, rightButtonText: '登录', onRightPressed: () {})),
          footer: FooterButtonGroup(
              rightButtonText: '登录',
              onRightPressed: () {
                UserOperate.signIn(username: exLoginController.username, password: exLoginController.password).then((value) {
                  if (value.isOK()) {
                    LocalStore.saveToken(token: value.data, expires: const Duration(days: 1)).then((value) {
                      GoRouter.of(context).replace("/file", extra: {"info": widget.infoItem});
                    });
                  }
                });
              })),
    );
  }
}
