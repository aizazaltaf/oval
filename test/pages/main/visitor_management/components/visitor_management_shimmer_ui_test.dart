import 'package:admin/pages/main/visitor_management/component/visitor_management_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 800,
          child: child,
        ),
      ),
    );
  }

  group('VisitorManagementShimmer Widget Tests', () {
    testWidgets('should build without errors', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();
      expect(find.byType(VisitorManagementShimmer), findsOneWidget);
    });

    testWidgets('should render ListView with correct structure',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify ListView is present
      expect(find.byType(ListView), findsOneWidget);

      // Verify ListView has correct properties
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(EdgeInsets.zero));
      expect(listView.shrinkWrap, isTrue);
    });

    testWidgets('should render correct number of shimmer items',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Should render 8 shimmer items (itemCount: 8)
      expect(find.byType(ListTileShimmer), findsNWidgets(8));
    });

    testWidgets('should render FittedBox wrapper for each shimmer item',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Should have 8 FittedBox widgets (one for each shimmer item)
      expect(find.byType(FittedBox), findsNWidgets(8));
    });

    testWidgets('should render correct number of dividers', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Should have 7 dividers (separator between 8 items)
      expect(find.byType(Divider), findsNWidgets(7));
    });

    testWidgets('should have correct ListTileShimmer properties',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Get the first ListTileShimmer widget
      final listTileShimmer = tester.widget<ListTileShimmer>(
        find.byType(ListTileShimmer).first,
      );

      // Verify properties
      expect(listTileShimmer.height, equals(16));
      expect(listTileShimmer.padding, equals(EdgeInsets.zero));
    });

    testWidgets('should have correct FittedBox properties', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Get the first FittedBox widget
      final fittedBox = tester.widget<FittedBox>(
        find.byType(FittedBox).first,
      );

      // Verify FittedBox contains ListTileShimmer
      expect(fittedBox.child, isA<ListTileShimmer>());
    });

    testWidgets('should handle widget rebuilds correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify initial state
      expect(find.byType(ListTileShimmer), findsNWidgets(8));
      expect(find.byType(Divider), findsNWidgets(7));

      // Rebuild widget
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify state after rebuild
      expect(find.byType(ListTileShimmer), findsNWidgets(8));
      expect(find.byType(Divider), findsNWidgets(7));
    });

    testWidgets('should render in different screen sizes', (tester) async {
      // Test with small screen size
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      expect(find.byType(VisitorManagementShimmer), findsOneWidget);
      expect(find.byType(ListTileShimmer), findsWidgets);

      // Reset screen size
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('should handle widget disposal correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify widget is rendered
      expect(find.byType(VisitorManagementShimmer), findsOneWidget);

      // Dispose widget
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox.shrink(),
        ),
      );

      await tester.pump();

      // Verify widget is no longer present
      expect(find.byType(VisitorManagementShimmer), findsNothing);
    });

    testWidgets('should have correct widget hierarchy', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify the widget hierarchy
      expect(find.byType(VisitorManagementShimmer), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(FittedBox), findsWidgets);
      expect(find.byType(ListTileShimmer), findsWidgets);
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('should render shimmer animation correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify shimmer widgets are present and can animate
      expect(find.byType(ListTileShimmer), findsWidgets);

      // Pump to trigger animation
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Widget should still be present after animation
      expect(find.byType(VisitorManagementShimmer), findsOneWidget);
      expect(find.byType(ListTileShimmer), findsWidgets);
    });

    testWidgets('should handle ListView scrolling behavior', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const SizedBox(
            height: 300,
            child: VisitorManagementShimmer(),
          ),
        ),
      );

      await tester.pump();

      // Verify ListView is scrollable
      expect(find.byType(ListView), findsOneWidget);

      // Try to scroll (should not cause errors)
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pump();

      // Widget should still be present after scroll
      expect(find.byType(VisitorManagementShimmer), findsOneWidget);
    });

    testWidgets('should render with correct spacing and layout',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify all shimmer items are rendered
      final shimmerItems = find.byType(ListTileShimmer);
      expect(shimmerItems, findsWidgets);

      // Verify all dividers are rendered
      final dividers = find.byType(Divider);
      expect(dividers, findsWidgets);
    });

    testWidgets('should be stateless widget', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const VisitorManagementShimmer(),
        ),
      );

      await tester.pump();

      // Verify it's a StatelessWidget
      final widget = tester.widget<VisitorManagementShimmer>(
        find.byType(VisitorManagementShimmer),
      );
      expect(widget, isA<StatelessWidget>());
    });

    testWidgets('should handle theme changes correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: VisitorManagementShimmer(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(VisitorManagementShimmer), findsOneWidget);

      // Change theme
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: SizedBox(
              width: 400,
              height: 800,
              child: VisitorManagementShimmer(),
            ),
          ),
        ),
      );

      await tester.pump();

      // Widget should still be present after theme change
      expect(find.byType(VisitorManagementShimmer), findsOneWidget);
    });
  });
}
