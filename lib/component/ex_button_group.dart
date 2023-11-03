import 'package:flutter/material.dart';

typedef IndexCallback = void Function(int index);

class ExButtonGroup extends StatefulWidget {
  ExButtonGroup({super.key, required this.titles, this.indexCallback, this.selectIndex,required this.emptyTitle});

  final List<String> titles;

  IndexCallback? indexCallback;

  final String emptyTitle;

  int? selectIndex;

  @override
  State<StatefulWidget> createState() => _ExButtonGroupState();
}

class _ExButtonGroupState extends State<ExButtonGroup> {
  int _selectIndex = -1;

  _updateSelect(int selectIndex) {
    setState(() {
      _selectIndex = selectIndex;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(widget.titles.isEmpty){
      return  Text(widget.emptyTitle);
    }

    if (widget.selectIndex != null && _selectIndex < 0) {
      _selectIndex = widget.selectIndex!;
    }
    var children = <Widget>[
      for (var i = 0; i < widget.titles.length; i++)
        SizedBox(
          height: 35,
          width: 10,
          child: TextButton(
            onPressed: () {
              _updateSelect(i);
              if (widget.indexCallback != null) {
                widget.indexCallback!(i);
              }
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black87),
              overlayColor: MaterialStateProperty.all(Colors.black12),
              backgroundColor: _selectIndex == i ? MaterialStateProperty.all(Colors.black12) : null,
            ),
            child: Text(widget.titles.elementAt(i)),
          ),
        )
    ];

    return ListView(
      padding: const EdgeInsets.all(10),
      children: children,
    );
  }
}
