import 'dart:async';
import 'dart:convert';
import 'dart:io';

class StreamConvert extends Converter<List<int>, List<int>> {
  @override
  List<int> convert(List<int> input) {
    // sleep(const Duration(seconds: 3));
    return input;
  }
}

void main() {
  var file = File("C:\\CloudMusic\\222.jpg");

  var stream = file.openRead();

  var stream0 = StreamController();

  stream.listen((event) {
    // sleep(const Duration(seconds: 3));
    print(event.length);

    print(stream);
  }, onDone: () {
    print("onDone");
  });
  print("over");
}
