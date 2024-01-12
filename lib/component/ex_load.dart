import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextController extends ValueNotifier<String> {
  TextController(super.value);
}

class ExLoading extends StatelessWidget {
  ExLoading({super.key, this.width, this.height, this.title, this.loadingTitleController});

  TextController? loadingTitleController;

  double? width;
  double? height;
  String? title;

  @override
  Widget build(BuildContext context) {
    if (loadingTitleController != null) {
      return ChangeNotifierProvider(
          create: (context) => loadingTitleController,
          builder: (BuildContext context, Widget? widget) {
            var value = Provider.of<TextController>(context).value;
            return Align(
              child: SizedBox(
                height: height,
                width: width,
                child: Flex(direction: Axis.vertical, children: [
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(value),
                  )
                ]),
              ),
            );
          });
    }

    if (title != null) {
      return Align(
        child: SizedBox(
          height: height,
          width: width,
          child: Flex(direction: Axis.vertical, children: [
            const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(title!),
            )
          ]),
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
