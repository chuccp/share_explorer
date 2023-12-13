List<int> splitNumber(int total, int parts) {
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
