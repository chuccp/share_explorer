import 'package:flutter/material.dart';

class ExLoading extends StatelessWidget {
  ExLoading({super.key, this.width, this.height});

  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        height: height,
        width: width,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
