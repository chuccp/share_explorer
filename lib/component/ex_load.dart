import 'package:flutter/material.dart';

class ExLoading extends StatelessWidget {
  ExLoading({super.key, this.width, this.height, this.title});

  double? width;
  double? height;
  String? title;

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Align(
        child: SizedBox(
          height: height,
          width: width,
          child: Flex(direction: Axis.vertical, children: [const CircularProgressIndicator(), Padding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),child: Text(title!),)]),
        ),
      );
    }

    return Align(
      child: SizedBox(
        height: height,
        width: width,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
