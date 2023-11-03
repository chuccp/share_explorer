import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../api/user.dart';
import '../../component/ex_address_input.dart';
import '../../component/ex_card.dart';
import '../../component/ex_dialog.dart';
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
                UserOperate.connect(address: value.toString()).then((value) => {
                  if (value.isOK())
                    {alertDialog(context: context, msg: value.data)}
                });
              }),
          footer: FooterButtonGroup(
            rightButtonText: '设置',
            onRightPressed: () {
              UserOperate.addClient(
                  addresses: addressControllers.addressStr).then((value){
                    if(value.isOK()){
                      GoRouter.of(context).replace("/clientLogin", extra: {"info": infoItem});
                    }
              } );
            },
            leftButtonText: '上一步',
            onLeftPressed: () {
              GoRouter.of(context).pop();
            },
          )),
    );
  }
}
