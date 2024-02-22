import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ExLoginInfo {
  ExLoginInfo({this.useSelected, this.saveSelected});

  static ExLoginInfo empty = ExLoginInfo(useSelected: false, saveSelected: false);

  bool? useSelected;

  bool? saveSelected;

  FilePickerResult? filePickerResult;
}

class ExLoginController extends ValueNotifier<ExLoginInfo> {
  ExLoginController() : super(ExLoginInfo.empty);

  set username(String username) {
    usernameController.text = username;
  }

  set password(String password) {
    passwordController.text = password;
  }

  set code(String code) {
    codeController.text = code;
  }

  String get username => usernameController.text;

  String get password => passwordController.text;

  String get code => codeController.text;

  set useSelected(bool useSelected) {
    value.useSelected = useSelected;
  }

  set saveSelected(bool saveSelected) {
    value.saveSelected = saveSelected;
  }

  set filePickerResult(FilePickerResult? filePickerResult) {
    value.filePickerResult = filePickerResult;
  }

  TextEditingController usernameController = TextEditingController();

  TextEditingController codeController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
}

class ExLogin extends StatefulWidget {
  ExLogin({super.key, this.isServer, this.isClient,required this.exLoginController});

  bool? isServer;

  bool? isClient;

  ExLoginController exLoginController;

  @override
  State<StatefulWidget> createState() => _ExLoginState();
}

class _ExLoginState extends State<ExLogin> {
  bool _useSelected = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.exLoginController,
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Column(
            children: [

              if(widget.isClient!=null && widget.isClient!)
              TextField(
                controller: widget.exLoginController.codeController,
                decoration: const InputDecoration(
                  labelText: "本地代码",
                ),
              ),
              TextField(
                controller: widget.exLoginController.usernameController,
                decoration: const InputDecoration(
                  labelText: "账号",
                ),
              ),
              TextField(
                controller: widget.exLoginController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "密码",
                ),
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _useSelected,
                onChanged: (bool? value) {
                  setState(() {
                    _useSelected = !_useSelected;
                    widget.exLoginController.useSelected = _useSelected;
                  });
                },
                subtitle: const Text('下次进入页面直接登录'),
                title: const Text('是否记录登录信息'),
              )
            ],
          ),
        );
      },
    );
  }
}
