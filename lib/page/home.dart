import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_load.dart';

import '../api/user.dart';
import '../util/cache.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (mounted) {
      UserOperate.info(context).then((value) {
        ExCache.saveInfoItem(value);
        if (mounted) {
          if (value.hasInit!) {
            if (value.hasSignIn!) {
              GoRouter.of(context).go("/file");
            } else {
              if (value.isServer!) {
                GoRouter.of(context).go("/serverLogin");
              } else {
                GoRouter.of(context).go("/clientLogin");
              }
            }
          } else {
            GoRouter.of(context).go("/setting");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExLoading();
  }
}
