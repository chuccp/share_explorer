import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entry/address.dart';

class AddressController {
  AddressController({required AddressItem addressItem}) {
    _hostController.text = addressItem.host;
    _portController.text = addressItem.port == 0 ? "" : addressItem.port.toString();

    addListener(() {
      addressItem.host = _hostController.text;
      addressItem.port = _portController.text.isNotEmpty ? int.parse(_portController.text) : 0;
    });
  }

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  addListener(VoidCallback listener) {
    _hostController.addListener(listener);
    _portController.addListener(listener);
  }

  dispose() {
    _hostController.dispose();
    _portController.dispose();
  }
}

class AddressInput extends StatefulWidget {
  const AddressInput({super.key, this.addressController, this.autofocus = false, this.onDeletePressed, this.onTestPressed, this.onChangePressed});

  final AddressController? addressController;
  final bool autofocus;

  final VoidCallback? onDeletePressed;

  final VoidCallback? onChangePressed;

  final VoidCallback? onTestPressed;

  @override
  State<StatefulWidget> createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  @override
  Widget build(BuildContext context) {
    var childrenView = <Widget>[];
    childrenView.add(const Spacer(
      flex: 1,
    ));

    childrenView.add(Expanded(
      flex: 7,
      child: TextField(
        controller: widget.addressController?._hostController,
        autofocus: widget.autofocus,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9-.]"))],
        decoration: const InputDecoration(
          labelText: "服务器地址",
        ),
      ),
    ));
    childrenView.add(const Spacer(
      flex: 1,
    ));

    childrenView.add(Expanded(
      flex: 4,
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        controller: widget.addressController?._portController,
        decoration: const InputDecoration(
          labelText: "端口号",
        ),
      ),
    ));

    if (widget.onTestPressed != null) {
      childrenView.add(const Spacer(
        flex: 1,
      ));
      childrenView.add(Expanded(
        flex: 3,
        child: ElevatedButton(
          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            if (widget.onTestPressed != null) {
              widget.onTestPressed!();
            }
          },
          child: const Text("测试"),
        ),
      ));
    }
    if (widget.onDeletePressed != null) {
      childrenView.add(const Spacer(
        flex: 1,
      ));
      childrenView.add(Expanded(
        flex: 3,
        child: OutlinedButton(
          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            if (widget.onDeletePressed != null) {
              widget.onDeletePressed!();
            }
          },
          child: const Text("删除"),
        ),
      ));
    }

    if (widget.onChangePressed != null) {
      childrenView.add(const Spacer(
        flex: 1,
      ));
      childrenView.add(Expanded(
        flex: 3,
        child: OutlinedButton(
          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            if (widget.onChangePressed != null) {
              widget.onChangePressed!();
            }
          },
          child: const Text("更换"),
        ),
      ));
    }
    childrenView.add(const Spacer(
      flex: 1,
    ));
    return SizedBox(
      width: 380,
      child: Flex(direction: Axis.horizontal, children: childrenView),
    );
  }
}

class AddressControllers {
  AddressControllers({required this.addresses});

  final List<AddressItem> addresses;

  void addAddressItem(AddressItem addressItem) {
    addresses.add(addressItem);
  }

  void removeAddressItem(AddressItem addressItem) {
    addresses.remove(addressItem);
  }

  List<String> get addressStr => <String>[for (var ele in addresses) ele.toString()];
}

typedef VoidTestCallback = void Function(AddressItem value);

class AddressInputGroup extends StatefulWidget {
  AddressInputGroup({super.key, required this.addressControllers, this.testCallback});

  final AddressControllers addressControllers;

  VoidTestCallback? testCallback;

  @override
  State<StatefulWidget> createState() => _AddressInputGroupState();
}

class _AddressInputGroupState extends State<AddressInputGroup> {
  _addAddress() {
    setState(() {
      widget.addressControllers.addAddressItem(AddressItem(host: "", port: 0));
    });
  }

  _deleteAddress(AddressItem value) {
    setState(() {
      widget.addressControllers.removeAddressItem(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var addresses = widget.addressControllers.addresses;
    var children = <AddressInput>[
      for (var ele in addresses)
        AddressInput(
            addressController: AddressController(addressItem: ele),
            onDeletePressed: () {
              _deleteAddress(ele);
            },
            onTestPressed: () {
              if (widget.testCallback != null) {
                widget.testCallback!(ele);
              }
            })
    ];

    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("添加"),
              onPressed: () {
                _addAddress();
              },
            )),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: children,
          ),
        ))
      ],
    );
  }
}
