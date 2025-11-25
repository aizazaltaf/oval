import 'package:built_collection/built_collection.dart';

extension XList<E> on List<E> {
  Iterable<E> subset(final int maxCount) {
    if (length > maxCount) {
      return sublist(0, maxCount);
    }
    return this;
  }
}

extension XBuiltList<E> on BuiltList<E> {
  BuiltList<E> subset(final int maxCount) {
    if (length > maxCount) {
      return sublist(0, maxCount);
    }
    return this;
  }
}
