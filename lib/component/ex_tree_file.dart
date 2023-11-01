import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

import '../entry/file.dart';

typedef RootFileItemCall = Future<List<FileItem>> Function();

typedef PathFileItemCall = Future<List<FileItem>> Function(String key);

class ExTreeFile extends StatefulWidget {
  const ExTreeFile({super.key, this.rootCall, this.pathCall, required this.onChanged});

  final RootFileItemCall? rootCall;

  final PathFileItemCall? pathCall;

  final ValueChanged<String> onChanged;

  @override
  State<StatefulWidget> createState() => _ExTreeFileState();
}

Node _fileItemToNode(FileItem fileItem) {
  var iconData = Icons.file_copy;
  if (fileItem.isDir!) {
    iconData = Icons.folder;
    if (fileItem.isDisk!) {
      iconData = Icons.storage;
    }
  }
  return Node(key: fileItem.path!, label: fileItem.name!, icon: iconData,parent:true);
}

class _ExTreeFileState extends State<ExTreeFile> {
  TreeViewController _treeViewController = TreeViewController(children: <Node>[
    const Node(key: '', label: '此电脑', icon: Icons.computer, parent: true)
  ]);

  void updateItem(List<FileItem> value, String parent) {
    setState(() {
      var parentNode = _treeViewController.getNode(parent);
      var children = <Node>[];
      for (var element in value) {
        children.add(_fileItemToNode(element));
      }
      var node = parentNode?.copyWith(children:children );
      List<Node<dynamic>> nodes =  _treeViewController.updateNode(parent, node!);
      _treeViewController = TreeViewController(children: nodes);
    });
  }

  String selectKey = "";

  void updateSelectKey(String selectKey) {
    setState(() {
      this.selectKey = selectKey;
    });
    widget.onChanged(selectKey);
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[
      Expanded(
          child: TreeView(
              onExpansionChanged: (key, isOpen) {
                if (isOpen) {
                  if (key == "") {
                    if (widget.rootCall != null) {
                      widget.rootCall!().then((value) {
                        updateItem(value, key);
                      });
                    }
                  } else {
                    if (widget.pathCall != null) {
                      widget.pathCall!(key).then((value) {
                        updateItem(value, key);
                      });
                    }
                  }
                }
              },
              onNodeTap: (key) {
                if (key.isNotEmpty) {
                  updateSelectKey(key);
                }
              },
              controller: _treeViewController,
              nodeBuilder: (BuildContext context, Node<dynamic> node) {
                return _FileTreeNode(
                  node: node,
                  selectKey: selectKey,
                  onChanged: (String? key) {
                    if (key != null && key.isNotEmpty) {
                      updateSelectKey(key);
                    }
                  },
                );
              }))
    ];
    return Expanded(child: Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: list,
    )) ;
  }
}

class _FileTreeNode extends StatelessWidget {
  const _FileTreeNode(
      {required this.node, required this.selectKey, required this.onChanged});
  final Node<dynamic> node;
  final String selectKey;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (node.key != "")
          Radio<String>(
            value: node.key,
            groupValue: selectKey,
            onChanged: (key) {
              onChanged(key);
            },
          ),
        Icon(node.icon),
        Expanded(child: SingleChildScrollView(child: Text(node.label),))
      ],
    );
  }
}
