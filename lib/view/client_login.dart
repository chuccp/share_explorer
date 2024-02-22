import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _ClientLoginState();
}

class _UserLogin {
  bool _isCancel = false;

  Future<bool> userLogin(
      {required BuildContext context, required TextController? loadingTitleController, required String username, required String password, required String code, required bool start}) {
    return _userLogin(username: username, password: password, code: code, start: start).then((value) {
      if (_isCancel) {
        return false;
      }
      if (value.code == 200) {
        return LocalStore.saveToken(token: value.data, code: code, username:username,expires: const Duration(days: 1)).then((va) {
          return true;
        });
      } else if (value.code == 500) {
        _isCancel = true;
        Navigator.of(context).pop(true);
        alertDialog(context: context, msg: value.error!);
        return false;
      } else {
        loadingTitleController!.value = value.error!;
        return Future.delayed(const Duration(seconds: 5)).then((value) {
          if (_isCancel) {
            return false;
          }
          return userLogin(context: context, loadingTitleController: loadingTitleController, username: username, password: password, code: code, start: false);
        });
      }
    });
  }

  void cancel() {
    _isCancel = true;
  }

  Future<Response> _userLogin({required String username, required String password, required String code, required bool start}) {
    return UserOperate.signIn(username: username, password: password, start: start, code: code);
  }
}

class _ClientLoginState extends State<ClientLoginPage> {
  @override
  Widget build(BuildContext context) {
    ExLoginController exLoginController = ExLoginController();

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
                    onCancel: () {
                      userLogin.cancel();
                      return Future.value(true);
                    },
                    onSucceed: () {
                      GoRouter.of(context).replace("/file");
                    },
                    onLoading: () {
                      userLogin = _UserLogin();
                      return userLogin.userLogin(
                          context: context,
                          loadingTitleController: loadingTitleController,
                          username: exLoginController.username,
                          password: exLoginController.password,
                          start: true,
                          code: exLoginController.code);
                    });
              })),
    );
  }
}
