import 'package:flutter/material.dart';

import '../entry/file.dart';
import 'ex_right_context_menu.dart';

class FileIconButton extends TextButton {
  FileIconButton({
    super.key,
    required VoidCallback? onTap,
    required VoidCallback? onDoubleTap,
    bool? autofocus,
    FocusNode? focusNode,
    Clip? clipBehavior,
    required Widget icon,
    required Widget label,
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
          ),
        );

  factory FileIconButton.fileItem({
    Key? key,
    bool? autofocus,
    FocusNode? focusNode,
    required FileItem fileItem,
    required VoidCallback? onPressed,
    required VoidCallback? onDoubleTap,
  }) {
    IconData iconData = Icons.folder;
    if (!fileItem.isDir!) {
      iconData = Icons.file_copy;
    }

    Widget child = Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Icon(
          color: Colors.amberAccent,
          iconData,
          size: 50,
        ));
    if (!fileItem.isDir!) {
      child = ExRightContextMenu(
        menuChildren: [ContextMenuButtonConfig(label: "下载"), ContextMenuButtonConfig(label: "删除")],
        child: child,
      );
    }
    String? title = fileItem.name;
    return FileIconButton(
        autofocus: autofocus,
        focusNode: focusNode,
        onDoubleTap: onDoubleTap,
        onTap: onPressed,
        icon: child,
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
  });

  final Widget label;
  final Widget icon;
  final VoidCallback? onDoubleTap;

  final VoidCallback? onTap;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
    );
  }
}
