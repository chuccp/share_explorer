import 'package:flutter/material.dart';

import 'ex_card.dart';
import 'ex_load.dart';

typedef FutureBoolCallback = Future<bool> Function();

typedef FutureValueCallback = Future<dynamic> Function();

typedef VoidValueCallback = void Function(dynamic);

Future<bool?> exShowDialogLoading(
    {required BuildContext context,
     FutureBoolCallback? onLoading,
    FutureBoolCallback? onClose,
       FutureValueCallback? onLoadingData,
      VoidValueCallback? onFinish,
    FutureBoolCallback? onCancel,
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
        onLoadingData: onLoadingData,
        onFinish: onFinish,
      );
    },
  );
}

class _DialogInfoWidget extends StatelessWidget {
  const _DialogInfoWidget({this.title, this.tip, this.onLoading, this.onClose, this.onCancel, this.onSucceed, this.loadingTitleController, this.onLoadingData, this.onFinish});

  final Widget? title;
  final String? tip;
  final FutureBoolCallback? onLoading;
  final FutureValueCallback? onLoadingData;
  final FutureBoolCallback? onClose;
  final FutureBoolCallback? onCancel;
  final VoidCallback? onSucceed;
  final VoidValueCallback? onFinish;
  final TextController? loadingTitleController;

  @override
  Widget build(BuildContext context) {
    if (onLoading != null) {
      onLoading!().then((value) {
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
    } else if (onLoadingData != null) {
      onLoadingData!().then((value) {
        Navigator.of(context).pop(true);
        if (onFinish != null) {
          onFinish!(value);
        }
      });
    }
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
