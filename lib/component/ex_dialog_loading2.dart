import 'package:flutter/material.dart';

import 'ex_load.dart';

Future<bool?> exShowDialogLoading({required BuildContext context,required String tip,TextController? loadingTitleController}) {
  return showDialog<bool>(
      context: context,
      barrierColor: const Color(0x7F000000),
      barrierDismissible: false,

      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("11"),
          contentPadding: EdgeInsets.zero,
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
          content:  SizedBox(
            height: 200,
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(0, 40, 0, 0), child:ExLoading(title: tip, loadingTitleController: loadingTitleController)),
              ],
            ),
          ),
        );
      });
}
