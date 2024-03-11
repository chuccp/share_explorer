import 'package:flutter/material.dart';

import '../entry/file.dart';

class ContextMenuButtonConfig {
  String? label;

  ValueChanged<FileItem>? onPressed;

  ContextMenuButtonConfig({this.label, this.onPressed});
}

class GenericContextMenu extends StatefulWidget {
  const GenericContextMenu({super.key, required this.contextMenuButtonConfig, required this.fileItem, required this.voidOnPressCallback});

  final ContextMenuButtonConfig contextMenuButtonConfig;

  final FileItem fileItem;

  final VoidCallback voidOnPressCallback;

  @override
  State<StatefulWidget> createState() => _GenericContextMenuState();
}

class _GenericContextMenuState extends State<GenericContextMenu> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(30, 2, 30, 2)), shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
      onPressed: widget.contextMenuButtonConfig.onPressed == null
          ? null
          : () {
              widget.voidOnPressCallback();
              widget.contextMenuButtonConfig.onPressed!(widget.fileItem);
            },
      child: SizedBox(
        width: double.infinity,
        child: Text(widget.contextMenuButtonConfig.label!),
      ),
    );
  }
}

class ExRightContextMenu extends StatelessWidget {
  ExRightContextMenu({super.key, required this.child, required this.menuChildren, required this.fileItem});

  final FileItem fileItem;
  final Widget child;
  final List<ContextMenuButtonConfig> menuChildren;

  MenuController? controller;

  void openMenu(MenuController controller, Offset offset) {
    this.controller = controller;
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
          fileItem: fileItem,
          voidOnPressCallback: () {
            if (controller != null && controller!.isOpen) {
              controller!.close();
            }
          },
        )
    ];
    return MenuAnchor(
      menuChildren: children,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onSecondaryTapDown: (detail) {
              openMenu(controller, detail.localPosition);
            },
            child: this.child);
      },
    );
  }
}
