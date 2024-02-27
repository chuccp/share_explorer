import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_radio_group.dart';

import '../api/user.dart';
import '../component/ex_card.dart';
import '../component/ex_load.dart';
import '../entry/info.dart';
import '../util/cache.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return widget.navigationShell;
  }
}

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    UserOperate.info().then((value) {
      ExCache.saveInfoItem(value);
      if (value.hasInit!) {
        if (value.hasSignIn!) {
          GoRouter.of(context).replace("/file");
        } else {
          if (value.isServer!) {
            GoRouter.of(context).replace("/serverLogin");
          } else {
            GoRouter.of(context).replace("/clientLogin");
          }
        }
      } else {
        GoRouter.of(context).replace("/choose");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExLoading();
  }
}

class ChoosePage extends StatelessWidget {
  const ChoosePage({super.key});

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
