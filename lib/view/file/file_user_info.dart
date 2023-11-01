import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("用户名:AAAAA"),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: OutlinedButton(
              child: const Text("修改密码"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
