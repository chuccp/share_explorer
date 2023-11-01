import 'package:flutter/material.dart';

class ExInfoCard extends StatelessWidget {
  ExInfoCard({super.key, required this.title, required this.children, this.subtitle});

  final String title;

  String? subtitle;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var childrenView = <Widget>[];
    childrenView.add(ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    ));

    for (var ele in children) {
      childrenView.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ele,
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: childrenView,
      ),
    );
  }
}
