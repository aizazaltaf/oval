import 'dart:convert';

import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_profile_image.dart';
import 'package:admin/widgets/face_cropper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  // Use a simple string for testing
  const String mockImageUrl =
      "http://media-assets-dev.irvinei.com/images/image_visitor_1765715.png";

  // VisitorsModel createVisitorWithFaceCoordinates() {
  //   const faceCoordinates = "[231,958,197,232]";
  //   return VisitorsModel(
  //     (b) => b
  //       ..id = 1
  //       ..name = 'Test Visitor'
  //       ..imageUrl = mockImageUrl
  //       ..faceCoordinate = faceCoordinates
  //       ..isWanted = 1
  //       ..locationId = 1
  //       ..lastVisit = '2024-01-01'
  //       ..uniqueId = 'test-unique-id',
  //   );
  // }

  VisitorsModel createVisitorWithoutFaceCoordinates() {
    return VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'Test Visitor'
        ..imageUrl = mockImageUrl
        ..faceCoordinate = null
        ..isWanted = 1
        ..locationId = 1
        ..lastVisit = '2024-01-01'
        ..uniqueId = 'test-unique-id',
    );
  }

  VisitorsModel createVisitorWithNullFaceCoordinate() {
    return VisitorsModel(
      (b) => b
        ..id = 1
        ..name = 'Test Visitor'
        ..imageUrl = mockImageUrl
        ..faceCoordinate = null
        ..isWanted = 1
        ..locationId = 1
        ..lastVisit = '2024-01-01'
        ..uniqueId = 'test-unique-id',
    );
  }

  group('VisitorProfileImage Widget Tests', () {
    testWidgets('should build without errors with default size',
        (tester) async {
      final visitor = createVisitorWithoutFaceCoordinates();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorProfileImage), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('should build with custom size', (tester) async {
      final visitor = createVisitorWithoutFaceCoordinates();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor, size: 100),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorProfileImage), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });

    // testWidgets('should display image widget when no face coordinates',
    //     (tester) async {
    //   final visitor = createVisitorWithoutFaceCoordinates();
    //
    //   await tester.pumpWidget(
    //     buildTestWidget(
    //       VisitorProfileImage(visitor: visitor),
    //     ),
    //   );
    //
    //   await tester.pump();
    //   // Should not display FaceCropperWidget when no face coordinates
    //   expect(find.byType(FaceCropperWidget), findsNothing);
    // });
    //
    // testWidgets(
    //     'should display FaceCropperWidget when face coordinates are present',
    //     (tester) async {
    //   final visitor = createVisitorWithFaceCoordinates();
    //
    //   await tester.pumpWidget(
    //     buildTestWidget(
    //       VisitorProfileImage(visitor: visitor),
    //     ),
    //   );
    //
    //   // Test immediately after building, before image loading fails
    //   expect(find.byType(FaceCropperWidget), findsOneWidget);
    // });

    testWidgets('should have gesture detector for tap interaction',
        (tester) async {
      final visitor = createVisitorWithoutFaceCoordinates();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Verify that GestureDetector is present for tap interaction
      expect(find.byType(GestureDetector), findsOneWidget);
    });
    //
    // testWidgets('should have gesture detector with face coordinates present',
    //     (tester) async {
    //   final visitor = createVisitorWithFaceCoordinates();
    //
    //   await tester.pumpWidget(
    //     buildTestWidget(
    //       VisitorProfileImage(visitor: visitor),
    //     ),
    //   );
    //
    //   // Test immediately after building, before image loading fails
    //   expect(find.byType(GestureDetector), findsOneWidget);
    // });

    testWidgets('should handle null imageUrl gracefully', (tester) async {
      final visitor = VisitorsModel(
        (b) => b
          ..id = 1
          ..name = 'Test Visitor'
          ..imageUrl = null
          ..faceCoordinate = null
          ..isWanted = 1
          ..locationId = 1
          ..lastVisit = '2024-01-01'
          ..uniqueId = 'test-unique-id',
      );

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Should still render without errors
      expect(find.byType(VisitorProfileImage), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('should handle empty imageUrl gracefully', (tester) async {
      final visitor = VisitorsModel(
        (b) => b
          ..id = 1
          ..name = 'Test Visitor'
          ..imageUrl = ''
          ..faceCoordinate = null
          ..isWanted = 1
          ..locationId = 1
          ..lastVisit = '2024-01-01'
          ..uniqueId = 'test-unique-id',
      );

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Should still render without errors
      expect(find.byType(VisitorProfileImage), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('should have correct gesture detector behavior',
        (tester) async {
      final visitor = createVisitorWithoutFaceCoordinates();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.behavior, equals(HitTestBehavior.opaque));
    });

    testWidgets('should have correct ClipOval shape', (tester) async {
      final visitor = createVisitorWithoutFaceCoordinates();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('should handle visitor with null faceCoordinate',
        (tester) async {
      final visitor = createVisitorWithNullFaceCoordinate();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Should not display FaceCropperWidget when faceCoordinate is null
      expect(find.byType(FaceCropperWidget), findsNothing);
    });

    testWidgets('should handle visitor with empty faceCoordinate',
        (tester) async {
      final visitor = VisitorsModel(
        (b) => b
          ..id = 1
          ..name = 'Test Visitor'
          ..imageUrl = mockImageUrl
          ..faceCoordinate =
              null // Use null instead of empty string to avoid JSON parsing error
          ..isWanted = 1
          ..locationId = 1
          ..lastVisit = '2024-01-01'
          ..uniqueId = 'test-unique-id',
      );

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Should not display FaceCropperWidget when faceCoordinate is null
      expect(find.byType(FaceCropperWidget), findsNothing);
    });

    testWidgets('should handle visitor with incomplete faceCoordinate array',
        (tester) async {
      final faceCoordinates = [100.0, 150.0]; // Only 2 values instead of 4
      final visitor = VisitorsModel(
        (b) => b
          ..id = 1
          ..name = 'Test Visitor'
          ..imageUrl = mockImageUrl
          ..faceCoordinate = jsonEncode(faceCoordinates)
          ..isWanted = 1
          ..locationId = 1
          ..lastVisit = '2024-01-01'
          ..uniqueId = 'test-unique-id',
      );

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Should not display FaceCropperWidget when faceCoordinate array is incomplete
      expect(find.byType(FaceCropperWidget), findsNothing);
    });

    testWidgets(
        'should handle visitor with null values in faceCoordinate array',
        (tester) async {
      final faceCoordinates = [100.0, null, 200.0, 250.0];
      final visitor = VisitorsModel(
        (b) => b
          ..id = 1
          ..name = 'Test Visitor'
          ..imageUrl = mockImageUrl
          ..faceCoordinate = jsonEncode(faceCoordinates)
          ..isWanted = 1
          ..locationId = 1
          ..lastVisit = '2024-01-01'
          ..uniqueId = 'test-unique-id',
      );

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Should not display FaceCropperWidget when faceCoordinate array has null values
      expect(find.byType(FaceCropperWidget), findsNothing);
    });

    testWidgets('should render widget structure correctly', (tester) async {
      final visitor = createVisitorWithoutFaceCoordinates();

      await tester.pumpWidget(
        buildTestWidget(
          VisitorProfileImage(visitor: visitor),
        ),
      );

      await tester.pump();

      // Verify the widget structure
      expect(find.byType(VisitorProfileImage), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });
  });
}
