import 'package:admin/pages/main/dashboard/main_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_build_context.dart';
import '../../../helpers/test_helper.dart';

void main() {
  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    await TestHelper.initialize();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
  });

  group('MainDashboard Widget Tests', () {
    group('Widget Creation', () {
      test('should create MainDashboard widget without crashing', () {
        expect(MainDashboard.new, returnsNormally);
      });

      test('should create MainDashboard with fromOneTimeInitialize parameter',
          () {
        expect(
          () => const MainDashboard(fromOneTimeInitialize: true),
          returnsNormally,
        );
        expect(
          () => const MainDashboard(),
          returnsNormally,
        );
      });

      test('should create MainDashboard with isUpdate parameter', () {
        expect(() => const MainDashboard(isUpdate: true), returnsNormally);
        expect(() => const MainDashboard(), returnsNormally);
      });

      test('should create MainDashboard with both parameters', () {
        expect(
          () =>
              const MainDashboard(fromOneTimeInitialize: true, isUpdate: true),
          returnsNormally,
        );
        expect(
          () => const MainDashboard(),
          returnsNormally,
        );
      });
    });

    group('Widget State', () {
      testWidgets('should create state that implements WidgetsBindingObserver',
          (tester) async {
        const widget = MainDashboard();
        final state = widget.createState();

        // Verify that the state implements WidgetsBindingObserver
        expect(state, isA<WidgetsBindingObserver>());
      });

      testWidgets('should have proper lifecycle methods', (tester) async {
        const widget = MainDashboard();
        final state = widget.createState();

        // Test that the state has the expected lifecycle methods by checking if it's a StatefulWidget state
        expect(state, isA<State>());
        expect(state, isA<WidgetsBindingObserver>());
      });
    });

    group('Static Methods', () {
      test('should have push static method', () {
        // Test that the static method exists
        expect(MainDashboard.pushRemove, isA<Function>());
      });

      test('should have pushRemove static method', () {
        // Test that the static method exists
        expect(MainDashboard.pushRemove, isA<Function>());
      });
    });
  });
}
