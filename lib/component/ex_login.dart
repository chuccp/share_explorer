import 'package:flutter/material.dart';

import 'ex_file_select.dart';



class ExLoginInfo{
  const ExLoginInfo({required this.username,required this.password});
  static const ExLoginInfo empty = ExLoginInfo(username: '', password: '');

  final String username;

  final String password;

}

class ExLoginController extends ValueNotifier<ExLoginInfo>{
  ExLoginController():super(ExLoginInfo.empty);

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
    return ValueListenableBuilder(valueListenable: widget.exLoginController, builder: (BuildContext context, value, Widget? child) {
      return Container(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "账号",
              ),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "密码",
              ),
            ),
            if(!widget.isServer!)
              const ExFileSelect(
                labelText: '证书文件',
              ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: _useSelected,
              onChanged: (bool? value) {
                setState(() {
                  _useSelected = !_useSelected;
                });
              },
              subtitle: const Text('下次进入页面直接登录'),
              title: const Text('是否记录登录信息'),
            ),
            if(!widget.isServer!)
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: _saveSelected,
                onChanged: (bool? value) {
                  setState(() {
                    _saveSelected = !_saveSelected;
                  });
                },
                subtitle: const Text('下次可免证书登录'),
                title: const Text('是否存储证书'),
              )
          ],
        ),
      );

    },);



  }
}
