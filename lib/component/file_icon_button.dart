import 'package:flutter/material.dart';

import '../entry/file.dart';
import 'ex_right_context_menu.dart';

class FileIconButton extends TextButton {
  FileIconButton({
    super.key,
    required VoidCallback? onTap,
    required VoidCallback? onDoubleTap,
    required FileItem fileItem,
    bool? autofocus,
    FocusNode? focusNode,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
    List<ContextMenuButtonConfig>? fileMenuChildren,
    List<ContextMenuButtonConfig>? dirMenuChildren,
  }) : super(
          onPressed: null,
          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          autofocus: autofocus ?? false,
          child: _FileIconButtonChild(
            onDoubleTap: onDoubleTap,
            onTap: onTap,
            icon: icon,
            label: label,
            focusNode: focusNode,
            fileItem: fileItem,
            fileMenuChildren: fileMenuChildren,
            dirMenuChildren: dirMenuChildren,
          ),
        );

  factory FileIconButton.fileItem({
    Key? key,
    bool? autofocus,
    FocusNode? focusNode,
    required FileItem fileItem,
    required VoidCallback? onPressed,
    required VoidCallback? onDoubleTap,
    required List<ContextMenuButtonConfig>? fileMenuChildren,
    required List<ContextMenuButtonConfig>? dirMenuChildren,
  }) {
    IconData iconData = Icons.folder;
    if (!fileItem.isDir!) {
      iconData = Icons.file_copy;
    }
    String? title = fileItem.name;
    return FileIconButton(
        autofocus: autofocus,
        focusNode: focusNode,
        onDoubleTap: onDoubleTap,
        fileItem: fileItem,
        onTap: onPressed,
        fileMenuChildren: fileMenuChildren,
        dirMenuChildren: dirMenuChildren,
        icon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Icon(
              color: Colors.amberAccent,
              iconData,
              size: 50,
            )),
        label: Text(title!, maxLines: 1, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 12.0)));
  }
}

class _FileIconButtonChild extends StatelessWidget {
  const _FileIconButtonChild({
    required this.label,
    required this.icon,
    required this.onDoubleTap,
    required this.onTap,
    required this.focusNode,
    required this.fileItem,
    this.fileMenuChildren,
    this.dirMenuChildren,
  });

  final Widget label;
  final Widget icon;
  final VoidCallback? onDoubleTap;

  final VoidCallback? onTap;

  final FocusNode? focusNode;

  final FileItem fileItem;

  final List<ContextMenuButtonConfig>? fileMenuChildren;

  final List<ContextMenuButtonConfig>? dirMenuChildren;

  @override
  Widget build(BuildContext context) {
    List<ContextMenuButtonConfig>? menuChildren = fileMenuChildren ?? List.empty();
    if (fileItem.isDir!) {
      menuChildren = dirMenuChildren ?? List.empty();
    }
    if (fileItem.isDisk!) {
      menuChildren = List.empty();
    }

    return ExRightContextMenu(
      menuChildren: menuChildren,
      fileItem: fileItem,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return InkWell(
            onDoubleTap: onDoubleTap,
            onTap: onTap,
            focusNode: focusNode,
            child: Container(
                color: Colors.transparent,
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[icon, Flexible(child: label)],
                )),
          );
        },
      ),
    );
  }
}
