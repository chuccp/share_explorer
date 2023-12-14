import 'dart:async';

List<int> splitNumber(int total, int parts) {
  if (total < 10) {
    return List.generate(total, (i) => 1);
  }
  if (total % parts == 0) {
    int partSize = total ~/ parts;
    return List.generate(parts, (i) => partSize);
  } else {
    int v = total % parts;
    int firstPart = (total / parts).floor();
    return List.generate(parts, (i) {
      if (i < v) {
        return firstPart + 1;
      }
      return firstPart;
    });
  }
}

Stream<List<int>> limitStream(Stream<List<int>> stream) {
  var list2 = List<int>.empty(growable: true);
  var stream0 = StreamController<List<int>>();
  int max = 20000;
  int total = 0;
  int totalNum = 0;
  bool end = false;
  Timer.periodic(const Duration(milliseconds: 50), (timer) {
    if (list2.length <= max) {
      stream0.add(list2);
      totalNum = totalNum + list2.length;
    } else {
      stream0.add(list2.sublist(0, max));
      list2.removeRange(0, max);
      totalNum = totalNum + max;
    }
    if (end && totalNum >= total) {
      stream0.close();
      timer.cancel();
    }
  });
  stream.listen((event) {
    list2.addAll(event);
    total = total + event.length;
  }, onDone: () {
    end = true;
  });
  return stream0.stream;
}
