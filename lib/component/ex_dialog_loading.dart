import 'package:flutter/material.dart';

import 'ex_card.dart';
import 'ex_load.dart';

typedef FutureValueCallback = Future<bool> Function();

Future<bool?> exShowDialogLoading(
    {required BuildContext context,
    required FutureValueCallback onLoading,
    FutureValueCallback? onClose,
    FutureValueCallback? onCancel,
    VoidCallback? onSucceed,
    Widget? title,
    String? tip,
      TextController? loadingTitleController}) {
  return showDialog<bool>(
    context: context,
    barrierColor: const Color(0x7F000000),
    barrierDismissible: false,
    builder: (context) {
      return _DialogInfoWidget(
        title: title,
        tip: tip,
        onLoading: onLoading,
        onClose: onClose,
        onCancel: onCancel,
        onSucceed: onSucceed,
        loadingTitleController: loadingTitleController,
      );
    },
  );
}

class _DialogInfoWidget extends StatelessWidget {
  const _DialogInfoWidget({this.title, this.tip, required this.onLoading, this.onClose, this.onCancel, this.onSucceed, this.loadingTitleController});

  final Widget? title;
  final String? tip;
  final FutureValueCallback onLoading;
  final FutureValueCallback? onClose;
  final FutureValueCallback? onCancel;
  final VoidCallback? onSucceed;
  final TextController? loadingTitleController;

  @override
  Widget build(BuildContext context) {
    onLoading().then((value) {
      if (value) {
        if (onClose != null) {
          onClose!().then((value) {
            if (value) {
              Navigator.of(context).pop(true);
              if (onSucceed != null) {
                onSucceed!();
              }
            }
          });
        } else {
          Navigator.of(context).pop(true);
          if (onSucceed != null) {
            onSucceed!();
          }
        }
      }
    });
    return AlertDialog(
      title: title,
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            if (onCancel != null) {
              onCancel!().then((value) {
                if (value) {
                  Navigator.of(context).pop(true);
                }
              });
            } else {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0), child: ExLoading(title: tip, loadingTitleController: loadingTitleController)),
          ],
        ),
      ),
    );
  }
}
