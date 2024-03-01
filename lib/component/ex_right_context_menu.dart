import 'package:flutter/material.dart';

class ContextMenuButtonConfig {
  String? label;

  VoidCallback? onPressed;

  ContextMenuButtonConfig({this.label, this.onPressed});
}

class GenericContextMenu extends StatefulWidget {
  const GenericContextMenu({super.key, required this.contextMenuButtonConfig});

  final ContextMenuButtonConfig contextMenuButtonConfig;

  @override
  State<StatefulWidget> createState() => _GenericContextMenuState();
}

class _GenericContextMenuState extends State<GenericContextMenu> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(padding:MaterialStateProperty.all(const EdgeInsets.fromLTRB(30, 2, 30, 2)),shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
      onPressed: () {},
      child: Text(widget.contextMenuButtonConfig.label!),
    );
  }
}

class ExRightContextMenu extends StatelessWidget {
  const ExRightContextMenu({super.key, required this.child, required this.menuChildren});

  final Widget child;
  final List<ContextMenuButtonConfig> menuChildren;

  void openMenu(MenuController controller, Offset offset) {
    if (!controller.isOpen) {
      controller.open(position: offset);
    } else {
      controller.open(position: offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      for (var item in menuChildren)
        GenericContextMenu(
          contextMenuButtonConfig: item,
        )
    ];
    return MenuAnchor(
      menuChildren: children,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            // onLongPressDown: (detail) {
            //   openMenu(controller, detail.localPosition);
            // },
            onSecondaryTapDown: (detail) {
              openMenu(controller, detail.localPosition);
            },
            child: this.child);
      },
    );
  }
}
