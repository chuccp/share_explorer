import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'ex_file_select.dart';

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

  String get username => usernameController.text;

  String get password => passwordController.text;

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

  TextEditingController passwordController = TextEditingController();
}

class ExLogin extends StatefulWidget {
  ExLogin({super.key, this.isServer, required this.exLoginController});

  bool? isServer;

  ExLoginController exLoginController;

  @override
  State<StatefulWidget> createState() => _ExLoginState();
}

class _ExLoginState extends State<ExLogin> {
  bool _useSelected = false;

  bool _saveSelected = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.exLoginController,
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Column(
            children: [
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
              if (!widget.isServer!)
                ExFileSelect(
                  labelText: '证书文件',
                  filePickerCallback: (FilePickerResult? value) {
                    widget.exLoginController.filePickerResult = value;
                  },
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
              ),
              if (!widget.isServer!)
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _saveSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _saveSelected = !_saveSelected;
                      widget.exLoginController.useSelected = _saveSelected;
                    });
                  },
                  subtitle: const Text('下次可免证书登录'),
                  title: const Text('是否存储证书'),
                )
            ],
          ),
        );
      },
    );
  }
}
