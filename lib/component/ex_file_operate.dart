import 'package:flutter/material.dart';

import '../entry/file.dart';
import '../entry/path.dart';
import 'ex_transformView.dart';

typedef ExPathCallback = ExPath Function();



class ExFileOperate extends StatefulWidget {

  ExFileOperate({super.key, this.onUpload, this.onCreateNewFile, this.onRefresh,required this.exTransformController});

  VoidCallback? onUpload;
  VoidCallback? onCreateNewFile;
  VoidCallback? onRefresh;



  ExTransformController exTransformController;

  @override
  State<StatefulWidget> createState() => _ExFileOperateState();
}

class _ExFileOperateState extends State<ExFileOperate> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("上传"),
                  onPressed: widget.onUpload,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.create_new_folder),
                    label: const Text("新建文件夹"),
                    onPressed: widget.onCreateNewFile,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.cached),
                    label: const Text("刷新"),
                    onPressed: widget.onRefresh,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
              width: 100,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: MenuAnchor(
                  crossAxisUnconstrained: false,
                  anchorTapClosesMenu: false,
                  style: MenuStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(0)), mouseCursor: MaterialStateProperty.all(SystemMouseCursors.basic)),
                  builder: (BuildContext context, MenuController controller, Widget? child) {
                    return IconButton(
                      icon: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                    );
                  },
                  menuChildren: [ExTransformView(
                    exTransformController: widget.exTransformController,
                  )],
                ),
              ))
        ],
      ),
    );
  }
}
