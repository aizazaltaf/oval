import 'dart:collection';

class Cache<K, V> {
  Cache(this.limit);

  final int limit;

  final LinkedHashMap<K, V> _internal = LinkedHashMap<K, V>();

  bool containsKey(final String key) => _internal.containsKey(key);

  // void remove(final K key) => _internal.remove;

  V? operator [](final K key) {
    final val = _internal[key];

    if (val != null) {
      _internal.remove(key);
      _internal[key] = val;
    }

    return val;
  }

  void operator []=(final K key, final V val) {
    _internal[key] = val;

    if (_internal.length > limit) {
      _internal.remove(_internal.values.first);
    }
  }

  V doCache(final K key, final V Function() f) {
    if (_internal.containsKey(key)) {
      return this[key]!;
    }

    final val = f();
    this[key] = val;
    return val;
  }
}
