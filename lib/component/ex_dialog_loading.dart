import 'package:flutter/material.dart';

import 'ex_card.dart';
import 'ex_load.dart';

typedef FutureBoolCallback = Future<bool> Function();

typedef FutureBoolBuildContextCallback = Future<bool> Function(BuildContext);

typedef FutureValueCallback = Future<dynamic> Function();

typedef VoidValueCallback = void Function(dynamic);

typedef FutureBoolValueCallback = Future<bool> Function(dynamic);

Future<bool?> exShowDialogLoading(
    {required BuildContext context,
    FutureBoolCallback? onLoading,
    FutureBoolCallback? onClose,
    FutureValueCallback? onLoadingData,
    VoidValueCallback? onFinish,
      VoidCallback? onCancel,
    VoidCallback? onSucceed,
    Widget? title,
    String? tip,
    TextController? loadingTitleController}) {
  return showDialog<bool>(
    context: context,
    barrierColor: const Color(0x7F000000),
    barrierDismissible: false,
    builder: (context0) {
      return _DialogInfoWidget(
        title: title,
        tip: tip,
        onLoading: onLoading,
        onClose: onClose,
        onCancel: onCancel,
        onSucceed: onSucceed,
        loadingTitleController: loadingTitleController,
        onLoadingData: onLoadingData,
        onFinish: onFinish,
        context0: context0,
      );
    },
  );
}

class _DialogInfoWidget extends StatefulWidget {
  const _DialogInfoWidget({this.title, this.tip, this.onLoading, this.onClose, this.onCancel, this.onSucceed, this.loadingTitleController, this.onLoadingData, this.onFinish, required this.context0});

  final BuildContext context0;
  final Widget? title;
  final String? tip;
  final FutureBoolCallback? onLoading;
  final FutureValueCallback? onLoadingData;
  final FutureBoolCallback? onClose;
  final VoidCallback? onCancel;
  final VoidCallback? onSucceed;
  final VoidValueCallback? onFinish;
  final TextController? loadingTitleController;

  @override
  State<StatefulWidget> createState() => _DialogInfoState();
}

class _DialogInfoState extends State<_DialogInfoWidget> {
  @override
  void initState() {
    if (widget.onLoading != null) {
      Future.delayed(const Duration(microseconds: 5)).then((value) {
        widget.onLoading!().then((value) {
          Navigator.of(context).pop(value);
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
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
