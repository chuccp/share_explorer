import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_load.dart';
import 'package:share_explorer/view/client_login.dart';
import 'package:share_explorer/view/file/file_manage.dart';
import 'package:share_explorer/view/file/file_setting.dart';
import 'package:share_explorer/view/setting/client_setting.dart';
import 'package:share_explorer/view/home.dart';
import 'package:share_explorer/view/server_login.dart';
import 'package:share_explorer/view/setting/server_setting.dart';

import 'entry/info.dart';
import 'entry/setting.dart';

GoRouter getRoute() {
  var router = GoRouter(routes: [
    StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/',
                builder: (context, state) {
                  return const LoadPage();
                },
                routes: [
                  GoRoute(
                      path: 'choose',
                      builder: (context, state) {
                        return const ChoosePage();
                      }),
                  GoRoute(
                      path: 'clientSetting',
                      builder: (context, state) {
                        return const ClientSettingPage();
                      }),
                  GoRoute(
                      path: 'certUploadPage',
                      builder: (context, state) {
                        return const CertUploadPage( );
                      }),
                  GoRoute(
                      path: 'clientLogin',
                      builder: (context, state) {
                        return const ClientLoginPage();
                      }),
                  GoRoute(
                      path: 'serverSetting',
                      builder: (context, state) {
                        return const ServerSetting();
                      }),
                  GoRoute(
                      path: 'serverNetSetting',
                      builder: (context, state) {
                        final Map<String, dynamic> params = state.extra! as Map<String, dynamic>;
                        final ServerSettingItem signUpInfo = params['signUpInfo']!;
                        return NetSetPage(signUpInfo: signUpInfo);
                      }),
                  GoRoute(
                      path: 'findServerPage',
                      builder: (context, state) {
                        return const FindServerPage();
                      }),
                  GoRoute(
                      path: 'certPage',
                      builder: (context, state) {
                        return const CertPage();
                      }),
                  GoRoute(
                      path: 'serverLogin',
                      builder: (context, state) {
                        return const ServerLoginPage();
                      }),
                ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/file',
                builder: (context, state) {
                  return const FileManagePage();
                }),
            GoRoute(
                path: '/fileSetting',
                builder: (context, state) {
                  return const FileSettingPage();
                })
          ])
        ],
        builder: (context, state, navigationShell) {
          return HomePage(navigationShell: navigationShell);
        }),
  ]);
  return router;
}
