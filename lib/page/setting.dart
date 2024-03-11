import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../component/ex_card.dart';
import '../component/ex_radio_group.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    ExRadioEditingController exRadioEditingController = ExRadioEditingController(values: [ExRadioValue(label: '服务器模式', value: 'server'), ExRadioValue(label: '客户端模式', value: 'client')]);
    return ExCardLayout(
        child: ExCard(
            width: 400,
            height: 220,
            title: "模式选择",
            body: SizedBox(
              width: 200,
              child: ExRadioGroup(controller: exRadioEditingController),
            ),
            footer: FooterButtonGroup(
                rightButtonText: '下一步',
                onRightPressed: () {
                  if (exRadioEditingController.selectValue == "client") {
                    GoRouter.of(context).push("/clientSetting");
                  } else {
                    GoRouter.of(context).push("/serverSetting");
                  }
                })));
  }
}
