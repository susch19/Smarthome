extension Linq<E> on List<E> {
  bool removeElements(Iterable<E> elements) {
    bool b = true;
    for (var e in elements) {
      if (!b) return b;
      b = this.remove(e);
    }
    return b;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(<K, List<E>>{},
      (Map<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));

  E? firstOrNull(bool Function(E element) keyFunction) {
    for (var item in [...this]) {
      if (keyFunction(item)) return item;
    }
    return null;
  }

  int sum(int Function(E element) keyFunction) {
    int sum = 0;
    for (var item in [...this]) {
      sum += keyFunction(item);
    }
    return sum;
  }

  int bitOr(int Function(E element) keyFunction) {
    int sum = 0;
    for (var item in [...this]) {
      sum |= keyFunction(item);
    }
    return sum;
  }

  int bitAnd(int Function(E element) keyFunction) {
    int sum = 0;
    for (var item in [...this]) {
      sum &= keyFunction(item);
    }
    return sum;
  }

  int bitXor(int Function(E element) keyFunction) {
    int sum = 0;
    for (var item in [...this]) {
      sum ^= keyFunction(item);
    }
    return sum;
  }
}
