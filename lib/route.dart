import 'package:go_router/go_router.dart';
import 'package:share_explorer/page/client_setting.dart';
import 'package:share_explorer/page/home.dart';
import 'package:share_explorer/page/server_setting.dart';
import 'package:share_explorer/page/setting.dart';
import 'package:share_explorer/view/client_login.dart';
import 'package:share_explorer/view/file/file_manage.dart';
import 'package:share_explorer/view/file/file_setting.dart';
import 'package:share_explorer/view/server_login.dart';

import 'entry/setting.dart';

GoRouter getRoute() {
  var router = GoRouter(routes: [
    GoRoute(name: "home", path: '/', builder: (context, state) => const HomePage()),
    GoRoute
      (name: "setting", path: '/setting', builder: (context, state) => const SettingPage())
    ,
    GoRoute(name: "clientSetting", path: '/clientSetting', builder: (context, state) => const ClientSettingPage()),
    GoRoute(name: "serverSetting", path: '/serverSetting', builder: (context, state) => const ServerSettingPage()),
    GoRoute(
        name: "serverNetSetting",
        path: '/serverNetSetting',
        builder: (context, state) {
          if (state.extra == null) {
            return const ServerSettingPage();
          }
          final Map<String, dynamic> params = state.extra! as Map<String, dynamic>;
          final ServerSettingItem signUpInfo = params['signUpInfo']!;
          return ServerNetSetPage(signUpInfo: signUpInfo);
        }),
    GoRoute(
        name: "certPage",
        path: '/certPage',
        builder: (context, state) {
          return const CertPage();
        }),
    GoRoute(
        path: '/file',
        name: "file",
        builder: (context, state) {
          return const FileManagePage();
        }),
    GoRoute(
        path: '/fileSetting',
        name: "fileSetting",
        builder: (context, state) {
          return const FileSettingPage();
        }),
    GoRoute(
        path: '/serverLogin',
        name: "serverLogin",
        builder: (context, state) {
          return const ServerLoginPage();
        }),
    GoRoute(
        path: '/clientLogin',
        name: "clientLogin",
        builder: (context, state) {
          return const ClientLoginPage();
        }),
  ]
  );
  return
    router;
}
