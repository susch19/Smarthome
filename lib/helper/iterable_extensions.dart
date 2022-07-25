extension Linq<E> on List<E> {
  bool sequenceEquals<K>(final List<K> other) {
    if (other.length != length) return false;

    for (var i = 0; i < length; i++) {
      if (other[i] != this[i]) return false;
    }
    return true;
  }

  bool removeElements(final Iterable<E> elements) {
    bool b = true;
    for (final e in elements) {
      if (!b) return b;
      b = remove(e);
    }
    return b;
  }

  List<E> copy() {
    final List<E> items = [];
    forEach((final element) {
      items.add(element);
    });
    return items;
  }
}

extension MoreMath on double {
  double clamp(final double lower, final double maximum) {
    if (this <= lower) return lower;
    if (this >= maximum) return maximum;
    return this;
  }
}

extension Maps<K, E> on Map<K, E> {
  List<T> select<T>(final T Function(K, E) keyFunction) {
    final retList = <T>[];
    for (final entry in entries) {
      retList.add(keyFunction(entry.key, entry.value));
    }
    return retList;
  }

  MapEntry<K, E>? elementAt(final int index, {final MapEntry<K, E>? orElse}) {
    int i = 0;
    for (final el in entries) {
      if (index == i) return el;
      i++;
    }
    return orElse;
  }
}

extension StringShortcuts on String {
  String substringReverse(final int end, {final int start = 0}) {
    return substring(start, length - start - end);
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(final K Function(E) keyFunction) => fold(<K, List<E>>{},
      (final Map<K, List<E>> map, final E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));

  Map<K, List<E>> groupManyBy<K>(final List<K> Function(E) keyFunction) =>
      fold(<K, List<E>>{}, (final Map<K, List<E>> map, final E element) {
        for (final r in keyFunction(element)) {
          map.putIfAbsent(r, () => <E>[]).add(element);
        }
        return map;
      });

  E? firstOrNull(final bool Function(E element) keyFunction) {
    for (final item in this) {
      if (keyFunction(item)) return item;
    }
    return null;
  }

  Iterable<E> injectForIndex(final E? Function(int index) indexFunc) sync* {
    int index = 0;
    for (final item in [...this]) {
      final res = indexFunc(index);
      if (res != null) yield res;
      yield item;
      index++;
    }
  }

  int sum(final int Function(E element) keyFunction) {
    int sum = 0;
    for (final item in [...this]) {
      sum += keyFunction(item);
    }
    return sum;
  }

  int bitOr(final int Function(E element) keyFunction) {
    int sum = 0;
    for (final item in [...this]) {
      sum |= keyFunction(item);
    }
    return sum;
  }

  int bitAnd(final int Function(E element) keyFunction) {
    int sum = 0;
    for (final item in [...this]) {
      sum &= keyFunction(item);
    }
    return sum;
  }

  int bitXor(final int Function(E element) keyFunction) {
    int sum = 0;
    for (final item in [...this]) {
      sum ^= keyFunction(item);
    }
    return sum;
  }

  Map<TKey, TValue> toMap<TKey, TValue>(
      final TKey Function(E element) keyFunction, final TValue Function(E element) valueFunction) {
    final map = <TKey, TValue>{};
    for (final item in [...this]) {
      map[keyFunction(item)] = valueFunction(item);
    }
    return map;
  }
}
