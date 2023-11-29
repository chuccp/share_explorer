import 'package:flutter/material.dart';

class CheckboxNode {
  CheckboxNode({this.id, this.name});

  int? id;
  String? name;
  bool select = false;
}

class ExCheckboxController extends ValueNotifier<List<CheckboxNode>> {
  ExCheckboxController(super._value);

  String _selectIds() {
    String sb = "";
    for (var element in value) {
      if (element.select) {
        sb = "$sb,${element.id}";
      }
    }
    return sb;
  }

   set selectIds(String ids){
    var idArray = ids.split(",");
     for (var element in value) {
       element.select = false;
       for(var id in  idArray){
         if(id.isNotEmpty && element.id==int.parse(id)){
           element.select = true;
           break;
         }
       }
     }
       notifyListeners();
   }

  String get selectIds => _selectIds();
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
