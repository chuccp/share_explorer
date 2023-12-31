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

class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserOperate.info().then((value) {
      ExCache.saveInfoItem(value);
      if (value.hasInit!) {
        if (value.hasSignIn!) {
          GoRouter.of(context).replace("/file", extra: {"info": value});
        } else {
          if (value.isServer!) {
            GoRouter.of(context).replace("/serverLogin", extra: {"info": value});
          } else {
            if (value.hasServer!) {
              GoRouter.of(context).replace("/clientLogin", extra: {"info": value});
            } else {
              GoRouter.of(context).replace("/findServerPage", extra: {"info": value});
            }
          }
        }
      } else {
        GoRouter.of(context).replace("/choose", extra: {"info": value});
      }
    });
    return ExLoading();
  }
}

class ChoosePage extends StatelessWidget {
  const ChoosePage({super.key, required this.infoItem});

  final InfoItem infoItem;

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
                    GoRouter.of(context).push("/clientSetting", extra: {"info": infoItem});
                  } else {
                    GoRouter.of(context).push("/serverSetting", extra: {"info": infoItem});
                  }
                })));
  }
}
