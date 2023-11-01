import 'package:flutter/material.dart';

class CheckboxNode {
  CheckboxNode({this.id, this.name});

  int? id;
  String? name;
  bool select = false;
}

class ExCheckboxController extends ValueNotifier<List<CheckboxNode>> {
  ExCheckboxController(super.value);

}

class ExCheckboxList extends StatefulWidget {
  ExCheckboxList({super.key, required this.exCheckboxController});

  ExCheckboxController exCheckboxController;

  @override
  State<StatefulWidget> createState() => _ExCheckboxListState();
}

class _ExCheckboxListState extends State<ExCheckboxList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.exCheckboxController,
      builder: (BuildContext context, List<CheckboxNode> nodeList, Widget? child) {
        var children = [
          for (var i = 0; i < nodeList.length; i++)
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) {
                setState(() {
                  nodeList.elementAt(i).select = value!;
                });
              },
              title: Text(nodeList.elementAt(i).name!),
              value: nodeList.elementAt(i).select,
            )
        ];
        return ListView(
          children: children,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.exCheckboxController.dispose();
  }
}
