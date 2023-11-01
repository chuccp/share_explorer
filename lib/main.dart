import 'package:flutter/material.dart';
import 'package:share_explorer/route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'share_explorer',
      routerConfig: getRoute(),
    );
  }
}
