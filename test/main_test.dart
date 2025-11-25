import 'dart:io';

import 'package:admin/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyHttpOverrides Tests', () {
    test('should correctly set global HttpOverrides', () {
      final MyHttpOverrides overrides = MyHttpOverrides();
      HttpOverrides.global = overrides;

      expect(HttpOverrides.current, equals(overrides));
    });
  });
}
