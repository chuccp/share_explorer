import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_explorer/route.dart';

import 'api/user.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    BrowserContextMenu.disableContextMenu();



    // js.context.callMethod('addEventListener', ['popstate', () {
    //   // 处理返回按钮事件
    // }]);

    return MaterialApp.router(
      showSemanticsDebugger: false,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate, S.delegate],
      title: "share_explorer",
      routerConfig: getRoute(),
    );
  }
}
