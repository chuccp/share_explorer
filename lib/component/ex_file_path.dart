import 'package:flutter/material.dart';

import '../entry/file.dart';
import 'ex_path_button.dart';

typedef VoidStringCallback = void Function(String);

class ExFilePathController extends ValueNotifier<String> {
  ExFilePathController() : super("");
}

class ExFilePath extends StatefulWidget {
  ExFilePath({super.key, required this.exFilePathController, required this.title, this.onPressed});

  final ExFilePathController exFilePathController;

  final String title;

  VoidStringCallback? onPressed;

  @override
  State<StatefulWidget> createState() => _ExFilePathState();
}

class _ExFilePathState extends State<ExFilePath> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.exFilePathController,
      builder: (BuildContext context, value, Widget? child) {
        var path = widget.exFilePathController.value;

        List<PathItem> list = PathItem.splitPath(path);
        var len = list.length;
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(children: [
            ExPathButton(
              title: "返回上一级",
              hasPress: len > 1,
              onPressed: () {
                if(len > 1 && widget.onPressed!=null){
                  widget.onPressed!(list.elementAt(len-2).path);
                }
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 12,
              child: const VerticalDivider(width: 3, color: Colors.black26, indent: 1),
            ),
            _PathView(pathItems: list, title: widget.title,onPressed:widget.onPressed)
          ]),
        );
      },
    );
  }
}

class _PathView extends StatelessWidget {
  _PathView({super.key, required this.pathItems, required this.title, this.onPressed});

  final List<PathItem> pathItems;

  final String title;

  VoidStringCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    var len = pathItems.length;
    children.add(
      ExPathButton(
        hasPress: len > 1,
        onPressed: () {
          if (onPressed != null) {
            onPressed!("\\");
          }
        },
        title: title,
      ),
    );
    children.add(const Text(">"));
    for (var i = 1; i < len; i++) {
      children.add(ExPathButton(
        hasPress: i < (len - 1),
        onPressed: () {
          if (onPressed != null) {
            onPressed!(pathItems[i].path);
          }
        },
        title: pathItems[i].name,
      ));
      children.add(const Text(">"));
    }
    return Row(children: children);
  }
}
