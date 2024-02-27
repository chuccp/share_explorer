
import 'package:dio/src/response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/entry/message.dart';
import 'package:share_explorer/entry/response.dart';

import '../api/user.dart';
import '../component/ex_card.dart';
import '../component/ex_dialog.dart';
import '../component/ex_dialog_loading.dart';
import '../component/ex_file_select.dart';
import '../component/ex_load.dart';
import '../component/ex_login.dart';
import '../entry/info.dart';
import '../util/local_store.dart';
import '../entry/response.dart' as resp;

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _ClientLoginState();
}

class _UserLogin {
  bool _isCancel = false;

  Future<bool> userLogin({required TextController loadingTitleController, required String username, required String password, required String code, required bool start}) {
    if (_isCancel) {
      return Future.value(false);
    }
    return _userLogin(username: username, password: password, code: code, start: start).then((value) {
      if (_isCancel) {
        return false;
      }
      if (value.code == 200) {
        _isCancel = true;
        return LocalStore.saveToken(token: value.data, code: code, username: username, expires: const Duration(days: 1)).then((va) {
          return true;
        });
      } else if (value.code == 500) {
        _isCancel = true;
        loadingTitleController.value = value.error!;
        return false;
      } else {
        return Future.delayed(const Duration(seconds: 5)).then((value) {
          if (_isCancel) {
            return false;
          }
          return userLogin(loadingTitleController: loadingTitleController, username: username, password: password, code: code, start: false);
        });
      }
    });
  }

  void cancel() {
    _isCancel = true;
  }

  Future<resp.Response> _userLogin({required String username, required String password, required String code, required bool start}) {
    return UserOperate.signIn(username: username, password: password, start: start, code: code);
  }
}

class _ClientLoginState extends State<ClientLoginPage> {
  @override
  Widget build(BuildContext context) {
    ExLoginController exLoginController = ExLoginController();
    exLoginController.username = "111111";
    exLoginController.code = "111111";
    exLoginController.password = "111111";
    var userLogin = _UserLogin();
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 412,
          title: "客户端登录",
          body: ExLogin(
            isServer: false,
            isClient: true,
            exLoginController: exLoginController,
          ),
          // footer: FooterButtonGroup(width: 240,leftFex:12,rightFex: 8,leftButtonText: "切换用户", onLeftPressed: () {}, rightButtonText: '登录', onRightPressed: () {})),
          footer: FooterButtonGroup(
              leftFex: 20,
              rightFex: 15,
              leftButtonText: "添加证书",
              onLeftPressed: () {
                GoRouter.of(context).push("/certUploadPage");
              },
              rightButtonText: '登录',
              onRightPressed: () {
                TextController? loadingTitleController = TextController("查找节点并登录中...");
                exShowDialogLoading(
                  context: context,
                  title: const Text("登陆中"),
                  loadingTitleController: loadingTitleController,
                  onLoading: () {
                    userLogin.cancel();
                    userLogin = _UserLogin();
                    return userLogin.userLogin(
                        loadingTitleController: loadingTitleController, username: exLoginController.username, password: exLoginController.password, code: exLoginController.code, start: true);
                  },
                ).then((value) {
                  userLogin.cancel();
                  if (value != null && value) {
                    GoRouter.of(context).replace("/file");
                  } else {
                    userLogin.cancel();
                  }
                });
              })),
    );
  }
}
