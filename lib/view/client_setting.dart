import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../api/user.dart';
import '../component/ex_address_input.dart';
import '../component/ex_card.dart';
import '../entry/info.dart';
import '../util/cache.dart';

class ClientSettingPage extends StatelessWidget {
  const ClientSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    InfoItem? infoItem = ExCache.getInfoItem();
    AddressControllers addressControllers = AddressControllers(addresses: infoItem!.addresses!);
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 360,
          title: "远程节点设置",
          body: AddressInputGroup(
              addressControllers: addressControllers!,
              testCallback: (value) {
                UserOperate.ping(address: value.toString(), context: context);
              }),
          footer: FooterButtonGroup(
            rightButtonText: '设置',
            onRightPressed: () {
              UserOperate.addClient(addresses: addressControllers!.addressStr).then((value) => {GoRouter.of(context).push("/certUploadPage")});
            },
            leftButtonText: '上一步',
            onLeftPressed: () {
              GoRouter.of(context).pop();
            },
          )),
    );
  }
}
