import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../component/ex_address_input.dart';
import '../../component/ex_card.dart';
import '../../entry/address.dart';
import '../../entry/info.dart';

class ClientSettingPage extends StatelessWidget {
  const ClientSettingPage({super.key, required this.infoItem});

  final InfoItem infoItem;

  @override
  Widget build(BuildContext context) {
    AddressControllers addressControllers = AddressControllers(addresses: infoItem.addresses!);
    return ExCardLayout(
      child: ExCard(
          width: 400,
          height: 360,
          title: "远程节点设置",
          body: AddressInputGroup(
              addressControllers: addressControllers,
              testCallback: (value) {
                print(value);
              }),
          footer: FooterButtonGroup(
            rightButtonText: '设置',
            onRightPressed: () {
              GoRouter.of(context).replace("/clientLogin", extra: {"info": infoItem});
            },
            leftButtonText: '上一步',
            onLeftPressed: () {
              GoRouter.of(context).pop();
            },
          )),
    );
  }
}
