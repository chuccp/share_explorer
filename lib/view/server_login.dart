import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/user.dart';
import '../component/ex_card.dart';
import '../component/ex_login.dart';
import '../entry/info.dart';
import '../generated/l10n.dart';
import '../util/local_store.dart';

class ServerLoginPage extends StatefulWidget {
  const ServerLoginPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  State<StatefulWidget> createState() => _ServerLoginState();
}

class _ServerLoginState extends State<ServerLoginPage> {
  @override
  Widget build(BuildContext context) {
    ExLoginController exLoginController = ExLoginController();
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 400,
          title: S.of(context).server_login,
          body: ExLogin(
            isServer: true,
            exLoginController: exLoginController,
          ),
          footer: FooterButtonGroup(
              rightButtonText: '登录',
              onRightPressed: () {
                UserOperate.signIn(username: exLoginController.username, password: exLoginController.password).then((value) {
                  if (value.isOK()) {
                    LocalStore.saveToken(token: value.data,expires: const Duration(days: 1)).then((value) {
                      GoRouter.of(context).replace("/file", extra: {"info": widget.infoItem});
                    });
                  }
                });
              })),
    );
  }
}
