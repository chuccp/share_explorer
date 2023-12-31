import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:share_explorer/component/ex_load.dart';
import '../../api/discover.dart';
import '../../api/user.dart';
import '../../component/ex_address_input.dart';
import '../../component/ex_card.dart';
import '../../component/ex_dialog.dart';
import '../../component/ex_file_select.dart';
import '../../entry/address.dart';
import '../../entry/info.dart';
import 'package:file_picker/file_picker.dart';

class ClientSettingPage extends StatefulWidget {
  const ClientSettingPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  State<StatefulWidget> createState() => _ClientSettingPageState();
}

class _ClientSettingPageState extends State<ClientSettingPage> {
  AddressControllers? addressControllers;

  @override
  void initState() {
    addressControllers = AddressControllers(addresses: widget.infoItem.addresses!);
  }

  @override
  Widget build(BuildContext context) {
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 360,
          title: "远程节点设置",
          body: AddressInputGroup(
              addressControllers: addressControllers!,
              testCallback: (value) {
                UserOperate.connect(address: value.toString()).then((value) => {
                      if (value.isOK()) {alertDialog(context: context, msg: value.data)}
                    });
              }),
          footer: FooterButtonGroup(
            rightButtonText: '下一步',
            onRightPressed: () {
              GoRouter.of(context).push("/certUploadPage", extra: {"info": widget.infoItem, "addresses": addressControllers!.addressStr});
            },
            leftButtonText: '上一步',
            onLeftPressed: () {
              GoRouter.of(context).pop();
            },
          )),
    );
  }
}

class CertUploadPage extends StatelessWidget {
  const CertUploadPage({super.key, required this.infoItem, required this.addresses});

  final InfoItem infoItem;

  final List<String> addresses;

  @override
  Widget build(BuildContext context) {
    FilePickerResult? filePickerResult;
    return ExCardLayout(
        child: ExCard(
      title: "证书上传",
      width: 400,
      height: 360,
      footer: FooterButtonGroup(
        rightButtonText: '上传',
        onRightPressed: () {
          if (filePickerResult != null) {
            UserOperate.uploadUserCert(pickerResult: filePickerResult, progressCallback: (int count, int total) {}, addresses: addresses).then((value) {
              if (value) {
                GoRouter.of(context).push("/findServerPage", extra: {"info": infoItem});
              }
            });
          }
        },
        leftButtonText: '上一步',
        onLeftPressed: () {
          GoRouter.of(context).pop();
        },
      ),
      body: SizedBox(
        width: 360,
        child: Column(
          children: [
            ExFileSelect(
              labelText: '证书文件',
              filePickerCallback: (FilePickerResult? value) {
                filePickerResult = value;
              },
            )
          ],
        ),
      ),
    ));
  }
}

class FindServerPage extends StatefulWidget {
  const FindServerPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  State<StatefulWidget> createState() => _FindServerPageState();
}

class _FindServerPageState extends State<FindServerPage> {
  Future<dynamic>? future;

  bool hasDispose = false;

  query(BuildContext context) {
    future = Future.delayed(const Duration(seconds: 2)).then((value) => {
          if (!hasDispose)
            {
              DiscoverOperate.nodeStatus().then((value) => {
                    if (value)
                      {
                        GoRouter.of(context).replace("/clientLogin", extra: {"info": widget.infoItem})
                      }
                    else
                      {
                        if (!hasDispose) {query(context)}
                      }
                  })
            }
        });
  }

  @override
  void dispose() {
    hasDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    hasDispose = false;
    query(context);
    return ExCardLayout(
        child: ExCard(
      width: 400,
      height: 220,
      title: "查找节点",
      body: SizedBox(
        width: 200,
        child: Column(
          children: [
            ExLoading(
              title: "查找服务节点中....",
            ),
          ],
        ),
      ),
    ));
  }
}
