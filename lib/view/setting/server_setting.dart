import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/entry/info.dart';

import '../../api/user.dart';
import '../../component/ex_address_input.dart';
import '../../component/ex_card.dart';
import '../../component/ex_dialog.dart';
import '../../entry/setting.dart';
import '../../util/local_store.dart';

class ServerSetting extends StatelessWidget {
  const ServerSetting({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  Widget build(BuildContext context) {
    SetSignUpController setSignUpController = SetSignUpController();
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 460,
          title: "账号设置",
          body: SetSignUp(setSignUpController: setSignUpController),
          footer: FooterButtonGroup(
              rightButtonText: '下一步',
              onRightPressed: () {
                GoRouter.of(context).push("/serverNetSetting", extra: {"info": infoItem, "signUpInfo": setSignUpController.serverSettingItem});
              },
              leftButtonText: '上一步',
              onLeftPressed: () {
                GoRouter.of(context).pop();
              })),
    );
  }
}

class SetSignUpController {
  bool useNatSelected = false;
  bool beNatSelected = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  ServerSettingItem get serverSettingItem =>
      ServerSettingItem(username: usernameController.text, password: passwordController.text, rePassword: rePasswordController.text, useNatSelected: useNatSelected, beNatSelected: beNatSelected);
}

class SetSignUp extends StatefulWidget {
  const SetSignUp({super.key, required this.setSignUpController});

  final SetSignUpController setSignUpController;

  @override
  State<StatefulWidget> createState() => _SetSignUpState();
}

class _SetSignUpState extends State<SetSignUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(children: [
        const Text(
          "设置管理员账号",
          textAlign: TextAlign.left,
        ),
        TextField(
          autofocus: true,
          controller: widget.setSignUpController.usernameController,
          decoration: const InputDecoration(labelText: "用户名", hintText: "用户名", prefixIcon: Icon(Icons.person)),
        ),
        TextField(
          controller: widget.setSignUpController.passwordController,
          decoration: const InputDecoration(labelText: "登录密码", hintText: "您的登录密码", prefixIcon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextField(
          controller: widget.setSignUpController.rePasswordController,
          decoration: const InputDecoration(labelText: "确认密码", hintText: "确认登录密码", prefixIcon: Icon(Icons.repeat)),
          obscureText: true,
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: widget.setSignUpController.useNatSelected,
          onChanged: (bool? value) {
            setState(() {
              widget.setSignUpController.useNatSelected = value!;
            });
          },
          subtitle: const Text('连接节点，使用NAT穿透服务'),
          title: const Text('是否使用NAT穿透服务'),
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: widget.setSignUpController.beNatSelected,
          onChanged: (bool? value) {
            setState(() {
              widget.setSignUpController.beNatSelected = value!;
            });
          },
          subtitle: const Text('作为节点，提供NAT穿透服务'),
          title: const Text('是否提供NAT穿透服务'),
        ),
      ]),
    );
  }
}

class NetSetPage extends StatelessWidget {
  const NetSetPage({super.key, required this.infoItem, required this.signUpInfo});

  final InfoItem infoItem;
  final ServerSettingItem signUpInfo;

  @override
  Widget build(BuildContext context) {
    print(signUpInfo);
    AddressControllers addressControllers = AddressControllers(addresses: infoItem.addresses!);
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 360,
          title: "远程节点设置",
          body: AddressInputGroup(
              addressControllers: addressControllers,
              testCallback: (value) {
                UserOperate.connect(address: value.toString()).then((value) => {
                      if (value.isOK()) {alertDialog(context: context, msg: value.data)}
                    });
              }),
          footer: FooterButtonGroup(
              rightButtonText: '下一步',
              onRightPressed: () {
                UserOperate.addAdminUser(
                        username: signUpInfo.username!,
                        password: signUpInfo.password!,
                        rePassword: signUpInfo.rePassword!,
                        isNatClient: signUpInfo.useNatSelected!,
                        isNatServer: signUpInfo.beNatSelected!,
                        addresses: addressControllers.addressStr)
                    .then((value) {
                  if (value.isOK()) {
                    LocalStore.saveToken(token: value.data).then((value){
                      GoRouter.of(context).push("/certPage", extra: {"info": infoItem});
                    });
                  }
                });
              },
              leftButtonText: '上一步',
              onLeftPressed: () {
                GoRouter.of(context).pop();
              })),
    );
  }
}

class CertPage extends StatelessWidget {
  const CertPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  Widget build(BuildContext context) {
    return ExCardLayout(
        child: ExCard(
      title: "设置完成",
      width: 400,
      height: 300,
      footer: FooterButtonGroup(
          rightButtonText: '去使用',
          onRightPressed: () {
            GoRouter.of(context).replace("/");
          },
          leftFex: 9,
          rightFex: 8,
          width: 240,
          leftButtonText: '下载证书',
          onLeftPressed: () {
            UserOperate.downloadCert();
          }),
      body: const Text("使用客户端模式登录时需要证书才能登录，对传输数据做加密处理"),
    ));
  }
}
