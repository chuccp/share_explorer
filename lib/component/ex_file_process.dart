import 'package:flutter/material.dart';

class ExFileProcessList extends StatelessWidget {
  const ExFileProcessList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: const [ExFileProcess(), ExFileProcess(), ExFileProcess()],
    ));
  }
}

class ExFileProcess extends StatelessWidget {
  const ExFileProcess({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 30,
          child: Icon(Icons.file_copy),
        ),
        const Expanded(
            child: Align(
          heightFactor: 1.5,
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              SizedBox(width: double.infinity, child: Text("文件名", style: TextStyle(fontSize: 12))),
              LinearProgressIndicator(minHeight: 5, backgroundColor: Colors.black26, valueColor: AlwaysStoppedAnimation(Colors.blue), value: .5),
              SizedBox(
                  width: double.infinity,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(flex: 1, child: SizedBox(width: double.infinity, child: Text("100MB", style: TextStyle(fontSize: 12)))),
                      Expanded(flex: 1, child: SizedBox(width: double.infinity, child: Text("100k/s", textAlign: TextAlign.end, style: TextStyle(fontSize: 12))))
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
                icon: const Icon(Icons.play_arrow),
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
