import 'package:flutter/material.dart';

import '../component/ex_card.dart';
import '../component/ex_login.dart';
import '../entry/info.dart';

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  State<StatefulWidget> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLoginPage> {
  @override
  Widget build(BuildContext context) {
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 400,
          title: "客户端登录",
          body: ExLogin(
            isServer: false,
          ),
          footer: FooterButtonGroup(rightButtonText: '登录', onRightPressed: () {})),
    );
  }
}
