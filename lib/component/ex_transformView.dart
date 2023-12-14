import 'package:flutter/material.dart';

import '../entry/progress.dart';
import 'ex_button_group.dart';
import 'ex_file_process.dart';

class ExTransformController extends ValueNotifier<List<Progress>> {
  ExTransformController() : super(List.empty(growable: true));

  add(Progress progress) {
    progress.isDone = false;
    progress.voidCallback = (){
      notifyListeners();
    };
    value.add(progress);

    notifyListeners();
  }
}

class ExTransformView extends StatefulWidget {
  const ExTransformView({super.key, required this.exTransformController});

  final ExTransformController exTransformController;

  @override
  State<StatefulWidget> createState() => _ExTransformViewState();
}

class _ExTransformViewState extends State<ExTransformView> {
  int? selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.exTransformController,
      builder: (BuildContext context, value, Widget? child) {
        var noFinish = widget.exTransformController.value.where((element) => element.isDone!=true);
        var finish = widget.exTransformController.value.where((value) =>  value.isDone == true);
        return SizedBox(
          width: 500,
          height: 400,
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: ExButtonGroup(
                    titles: ["文件上传(${noFinish.length})", "上传完成(${finish.length})"],
                    emptyTitle: '',
                    indexCallback: (index) {
                      setState(() {
                        selectIndex = index;
                      });
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                height: 400,
                child: const VerticalDivider(width: 3, color: Colors.black26, indent: 1),
              ),
              ExFileProcessList(
                progresses: ( selectIndex==0 ? noFinish : finish),
              ),
            ],
          ),
        );
      },
    );
  }
}
