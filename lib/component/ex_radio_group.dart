import 'package:flutter/material.dart';

class ExRadioValue {
  ExRadioValue({required this.label, required this.value});

  final String label;
  final String value;
}

class ExRadioEditingController extends ValueNotifier<ExRadioValue> {
  ExRadioEditingController({this.values, this.selectValue}) : super(ExRadioValue(label: '', value: ''));

  List<ExRadioValue>? values;

  String? selectValue;
}

class ExRadioGroup extends StatefulWidget {
  const ExRadioGroup({super.key, required this.controller});

  final ExRadioEditingController controller;

  @override
  State<StatefulWidget> createState() => _ExRadioGroupState();
}

class _ExRadioGroupState extends State<ExRadioGroup> {
  _updateValue(String selectValue) {
    setState(() {
      widget.controller.selectValue = selectValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.selectValue == null || widget.controller.selectValue!.isEmpty) {
      if (widget.controller.values != null && widget.controller.values!.isNotEmpty) {
        widget.controller.selectValue = widget.controller.values![0].value;
      }
    }
    var exRadioEditingValues = widget.controller.values;
    var children = <Widget>[
      if (exRadioEditingValues != null)
        for (var i = 0; i < exRadioEditingValues!.length; i++)
          RadioListTile<String>(
            title: Text(exRadioEditingValues.elementAt(i).label),
            value: exRadioEditingValues.elementAt(i).value,
            groupValue: widget.controller.selectValue,
            onChanged: (value) {
              _updateValue(value!);
            },
          )
    ];

    return Column(
      children: children,
    );
  }
}
