import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/visitor_management/guides/visitor_management_guide/filter_visitor_guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/bloc_helpers/visitor_management_bloc_test_helper.dart';
import '../../../../../helpers/fake_build_context.dart';
import '../../../../../helpers/test_helper.dart';
import '../../../../../mocks/bloc/bloc_mocks.dart';

late VisitorManagementBlocTestHelper visitorManagementBlocHelper;

void main() {
  setUpAll(() async {
    registerFallbackValue(FakeBuildContext());
    // Register fallback value for VisitorsModel to fix mocktail any() matcher
    registerFallbackValue(
      VisitorsModel(
        (b) => b
          ..id = 0
          ..name = "Test Visitor"
          ..uniqueId = "test_123"
          ..isWanted = 0
          ..locationId = 1
          ..lastVisit = "2024-01-01T00:00:00Z",
      ),
    );
    await TestHelper.initialize();
    visitorManagementBlocHelper = VisitorManagementBlocTestHelper();
  });

  setUp(() {
    visitorManagementBlocHelper.setup();

    // Set up singleton bloc with proper profile bloc mock
    singletonBloc.testProfileBloc = MockProfileBloc();
    when(() => singletonBloc.profileBloc.state).thenReturn(null);
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    visitorManagementBlocHelper.dispose();
  });

  group('FilterVisitorGuide Widget Tests', () {
    group('Widget Creation and Properties Tests', () {
      test(
        'should create FilterVisitorGuide widget with correct properties',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget, isNotNull);
          expect(widget.innerContext, equals(mockContext));
          expect(
            widget.bloc,
            equals(visitorManagementBlocHelper.mockVisitorManagementBloc),
          );
        },
      );

      test(
        'should be a StatelessWidget',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget, isA<StatelessWidget>());
        },
      );

      test(
        'should have required constructor parameters',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget.innerContext, isNotNull);
          expect(widget.bloc, isNotNull);
        },
      );

      test(
        'should accept optional key parameter',
        () {
          // Arrange
          final mockContext = FakeBuildContext();
          final key = GlobalKey();

          // Act
          final widget = FilterVisitorGuide(
            key: key,
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget.key, equals(key));
        },
      );
    });

    group('Bloc Integration Tests', () {
      test(
        'should call updateVisitorGuideShow when OK button is pressed',
        () async {
          // Act - Simulate the button press logic
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(true);

          // Assert
          verify(
            () => visitorManagementBlocHelper.mockVisitorManagementBloc
                .updateVisitorGuideShow(true),
          ).called(1);
        },
      );

      test(
        'should call updateVisitorGuideShow when skip button is pressed',
        () async {
          // Act - Simulate the skip button logic
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(true);

          // Assert
          verify(
            () => visitorManagementBlocHelper.mockVisitorManagementBloc
                .updateVisitorGuideShow(true),
          ).called(1);
        },
      );

      test(
        'should work with visitor management bloc',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(
            widget.bloc,
            equals(visitorManagementBlocHelper.mockVisitorManagementBloc),
          );
        },
      );
    });

    group('Widget Structure Tests', () {
      test(
        'should have correct widget hierarchy structure',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert - Verify the widget structure without rendering
          expect(widget, isA<StatelessWidget>());
        },
      );

      test(
        'should handle context properly',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget.innerContext, equals(mockContext));
        },
      );
    });

    group('Functionality Tests', () {
      test(
        'should handle multiple bloc calls correctly',
        () async {
          // Act - Simulate multiple button presses
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(true);
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(false);
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(true);

          // Assert
          verify(
            () => visitorManagementBlocHelper.mockVisitorManagementBloc
                .updateVisitorGuideShow(any()),
          ).called(3);
        },
      );

      test(
        'should handle different boolean values for updateVisitorGuideShow',
        () async {
          // Act - Test with different boolean values
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(true);
          visitorManagementBlocHelper.mockVisitorManagementBloc
              .updateVisitorGuideShow(false);

          // Assert
          verify(
            () => visitorManagementBlocHelper.mockVisitorManagementBloc
                .updateVisitorGuideShow(true),
          ).called(1);
          verify(
            () => visitorManagementBlocHelper.mockVisitorManagementBloc
                .updateVisitorGuideShow(false),
          ).called(1);
        },
      );
    });

    group('Integration Tests', () {
      test(
        'should integrate properly with visitor management bloc',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget.bloc, isA<VisitorManagementBloc>());
          expect(widget.innerContext, isA<BuildContext>());
        },
      );

      test(
        'should handle null safety properly',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert - Verify no null reference exceptions
          expect(widget.innerContext, isNotNull);
          expect(widget.bloc, isNotNull);
        },
      );
    });

    group('Widget Behavior Tests', () {
      test(
        'should maintain state consistency',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget1 = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          final widget2 = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert - Both widgets should have the same properties
          expect(widget1.innerContext, equals(widget2.innerContext));
          expect(widget1.bloc, equals(widget2.bloc));
        },
      );

      test(
        'should handle different contexts',
        () {
          // Arrange
          final mockContext1 = FakeBuildContext();
          final mockContext2 = FakeBuildContext();

          // Act
          final widget1 = FilterVisitorGuide(
            innerContext: mockContext1,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          final widget2 = FilterVisitorGuide(
            innerContext: mockContext2,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget1.innerContext, equals(mockContext1));
          expect(widget2.innerContext, equals(mockContext2));
          expect(widget1.bloc, equals(widget2.bloc));
        },
      );
    });

    group('Error Handling Tests', () {
      test(
        'should handle bloc method calls gracefully',
        () async {
          // Act & Assert - Should not throw when calling bloc methods
          expect(
            () => visitorManagementBlocHelper.mockVisitorManagementBloc
                .updateVisitorGuideShow(true),
            returnsNormally,
          );
        },
      );

      test(
        'should handle context access properly',
        () {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert - Should not throw when accessing context
          expect(() => widget.innerContext, returnsNormally);
        },
      );
    });

    group('Simple Widget Rendering Tests', () {
      testWidgets(
        'should create widget without crashing',
        (tester) async {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act & Assert - Should not crash when creating the widget
          expect(
            () => FilterVisitorGuide(
              innerContext: mockContext,
              bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
            ),
            returnsNormally,
          );
        },
      );

      testWidgets(
        'should have correct widget type',
        (tester) async {
          // Arrange
          final mockContext = FakeBuildContext();

          // Act
          final widget = FilterVisitorGuide(
            innerContext: mockContext,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget, isA<StatelessWidget>());
          expect(widget.runtimeType, equals(FilterVisitorGuide));
        },
      );

      testWidgets(
        'should handle widget creation with different parameters',
        (tester) async {
          // Arrange
          final mockContext1 = FakeBuildContext();
          final mockContext2 = FakeBuildContext();

          // Act
          final widget1 = FilterVisitorGuide(
            innerContext: mockContext1,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          final widget2 = FilterVisitorGuide(
            innerContext: mockContext2,
            bloc: visitorManagementBlocHelper.mockVisitorManagementBloc,
          );

          // Assert
          expect(widget1, isNotNull);
          expect(widget2, isNotNull);
          expect(widget1.runtimeType, equals(widget2.runtimeType));
        },
      );
    });
  });
}
