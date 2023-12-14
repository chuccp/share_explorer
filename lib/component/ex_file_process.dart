import 'package:flutter/material.dart';

import '../entry/progress.dart';

class ExFileProcessList extends StatelessWidget {
  const ExFileProcessList({super.key, required this.progresses,});

  final Iterable<Progress> progresses;


  @override
  Widget build(BuildContext context) {

    var children =  <Widget>[for (var element in progresses)
        ExFileProcess(progress:element)
    ];
    return Expanded(
        child: ListView(
      children: children,
    ));
  }
}

class ExFileProcess extends StatelessWidget {
  const ExFileProcess({super.key, required this.progress});

  final Progress progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 30,
          child: Icon(Icons.file_copy),
        ),
         Expanded(
            child: Align(
          heightFactor: 1.5,
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              SizedBox(width: double.infinity, child: Text(progress.name!, style: const TextStyle(fontSize: 12))),
              LinearProgressIndicator(minHeight: 5, backgroundColor: Colors.black26, valueColor: const AlwaysStoppedAnimation(Colors.blue), value: (progress.count!.toDouble()/progress.total!.toDouble())),
               SizedBox(
                  width: double.infinity,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(flex: 1, child: SizedBox(width: double.infinity, child: Text(progress.size, style: const TextStyle(fontSize: 12)))),
                       Expanded(flex: 1, child: SizedBox(width: double.infinity, child: Text("${progress.speed}/s", textAlign: TextAlign.end, style: const TextStyle(fontSize: 12))))
                    ],
                  )),
            ],
          ),
        )),
        SizedBox(
          width: 80,
          child: Row(
            children: [
              IconButton(
                splashRadius: 15,
                icon:  progress.isDone!?const Icon(Icons.check):const Icon(Icons.play_arrow),
                onPressed: () {},
              ),
              IconButton(
                splashRadius: 15,
                icon: const Icon(Icons.clear),
                onPressed: () {},
              )
            ],
          ),
        )
      ],
    );
  }
}
