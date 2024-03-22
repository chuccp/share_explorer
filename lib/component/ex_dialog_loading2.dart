import 'package:flutter/material.dart';

import '../entry/message.dart';
import 'ex_load.dart';

Future<Message?> exShowDialogLoading({required BuildContext context,  String? tip, Widget? title, ValueGetter<Future<Message?>>? onLoadData, TextController? loadingTitleController}) {
  return showDialog<Message?>(
      context: context,
      builder: (BuildContext context) {
        return _DialogInfoWidget(
          title: title,
          onLoadData: onLoadData,
          tip: tip,
          loadingTitleController: loadingTitleController,
        );
      });
}

class _DialogInfoWidget extends StatefulWidget {
  const _DialogInfoWidget({this.title, this.onLoadData, this.tip, this.loadingTitleController});

  final Widget? title;

  final String? tip;

  final TextController? loadingTitleController;

  final ValueGetter<Future<Message?>>? onLoadData;

  @override
  State<StatefulWidget> createState() => _DialogInfoState();
}

class _DialogInfoState extends State<_DialogInfoWidget> {
  @override
  void initState() {
    if (widget.onLoadData != null) {
      widget.onLoadData!().then((value) {
        Navigator.of(context).pop(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0), child: ExLoading(title: widget.tip, loadingTitleController: widget.loadingTitleController)),
          ],
        ),
      ),
    );
  }
}
