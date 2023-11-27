import 'package:flutter/material.dart';

class FooterButtonGroup extends StatelessWidget {
  FooterButtonGroup({
    super.key,
    required this.rightButtonText,
    this.leftButtonText,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftFex,
    this.rightFex,
    this.width
  });

  String? leftButtonText;
  String rightButtonText;

  int? leftFex;
  int? rightFex;
  double? width;

  final VoidCallback? onLeftPressed;

  final VoidCallback? onRightPressed;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    leftFex ??= 5;
    rightFex ??= leftFex;
    width ??= 200;
    if (leftButtonText != null && leftButtonText!.isNotEmpty) {
      list.add(Expanded(
          flex: leftFex!,
          child: OutlinedButton(
            onPressed: onLeftPressed,
            child: Text(leftButtonText!),
          )));
    } else {
      list.add(const Spacer(flex: 2));
    }
    list.add(const Spacer());
    if (rightButtonText != null && rightButtonText!.isNotEmpty) {
      list.add(Expanded(
          flex: rightFex!,
          child: ElevatedButton(
            onPressed: onRightPressed,
            child: Text(rightButtonText!),
          )));
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: width!,
        child: Flex(
          direction: Axis.horizontal,
          children: list,
        ),
      ),
    );
  }
}

class ExCardLayout extends StatelessWidget {
  const ExCardLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        const Spacer(
          flex: 1,
        ),
        child,
        const Spacer(
          flex: 2,
        )
      ],
    );
  }
}

class ExCard extends StatelessWidget {
  ExCard(
      {super.key,
      required this.width,
      required this.height,
      required this.body,
      this.title,
      this.footer});

  final double width;
  final double height;
  final String? title;
  final Widget body;
  Widget? footer;

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    if (title != null && title!.isNotEmpty) {
      list.add(ListTile(
        title: Text(title!),
      ));
    }
    // double vHeight = height==null || height!<110 ? 0:height!-110;
    list.add(Expanded(
      child: body,
    ));
    footer ??= FooterButtonGroup(rightButtonText: '下一步');
    if (footer != null) {
      list.add(Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: footer,
      )!);
    }
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          width: width,
          height: height,
          child: Card(
            color: Colors.white,
            child: Column(
              children: list,
            ),
          )),
    );
  }
}
