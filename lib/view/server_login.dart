import 'package:flutter/material.dart';

import '../component/ex_card.dart';
import '../component/ex_login.dart';
import '../entry/info.dart';

class ServerLoginPage extends StatefulWidget {
  const ServerLoginPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  State<StatefulWidget> createState() => _ServerLoginState();
}

class _ServerLoginState extends State<ServerLoginPage> {
  @override
  Widget build(BuildContext context) {
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 400,
          title: "服务端登录",
          body: ExLogin(
            isServer: true,
          ),
          footer: FooterButtonGroup(rightButtonText: '登录', onRightPressed: () {})),
    );
  }
}
