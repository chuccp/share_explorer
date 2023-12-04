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
                        final Map<String, InfoItem> params = state.extra! as Map<String, InfoItem>;
                        final InfoItem info = params['info']!;
                        return ChoosePage(infoItem: info);
                      }),
                  GoRoute(
                      path: 'clientSetting',
                      builder: (context, state) {
                        final Map<String, InfoItem> params = state.extra! as Map<String, InfoItem>;
                        final InfoItem info = params['info']!;
                        return ClientSettingPage(infoItem: info);
                      }),
                  GoRoute(
                      path: 'certUploadPage',
                      builder: (context, state) {
                        final Map<String, dynamic> params = state.extra! as Map<String, dynamic>;
                        final InfoItem info = params['info']!;
                        final List<String> addresses = params['addresses']!;
                        return CertUploadPage(infoItem: info, addresses: addresses,);
                      }),
                  GoRoute(
                      path: 'clientLogin',
                      builder: (context, state) {
                        final Map<String, InfoItem> params = state.extra! as Map<String, InfoItem>;
                        final InfoItem info = params['info']!;
                        return ClientLoginPage(infoItem: info);
                      }),
                  GoRoute(
                      path: 'serverSetting',
                      builder: (context, state) {
                        final Map<String, InfoItem> params = state.extra! as Map<String, InfoItem>;
                        final InfoItem info = params['info']!;
                        return ServerSetting(infoItem: info);
                      }),
                  GoRoute(
                      path: 'serverNetSetting',
                      builder: (context, state) {
                        final Map<String, dynamic> params = state.extra! as Map<String, dynamic>;
                        final InfoItem info = params['info']!;
                        final ServerSettingItem signUpInfo = params['signUpInfo']!;
                        return NetSetPage(infoItem: info,signUpInfo:signUpInfo);
                      }),
                  GoRoute(
                      path: 'certPage',
                      builder: (context, state) {
                        final Map<String, InfoItem> params = state.extra! as Map<String, InfoItem>;
                        final InfoItem info = params['info']!;
                        return CertPage(infoItem: info);
                      }),
                  GoRoute(
                      path: 'serverLogin',
                      builder: (context, state) {
                        final Map<String, InfoItem> params = state.extra! as Map<String, InfoItem>;
                        final InfoItem info = params['info']!;
                        return ServerLoginPage(infoItem: info);
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
