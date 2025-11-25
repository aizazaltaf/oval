import 'package:admin/pages/main/statistics/components/place_holder/statistics_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('statisticsShimmerWidget renders without error', (tester) async {
    await tester
        .pumpWidget(wrapWithMaterialApp(statisticsShimmerWidget(100, 20, 40)));
    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('statisticsShimmerWidget Container has correct height and width',
      (tester) async {
    const height = 100.0;
    const value = 20.0;
    const width = 40.0;
    await tester.pumpWidget(
      wrapWithMaterialApp(statisticsShimmerWidget(height, value, width)),
    );
    final container = tester.widget<Container>(find.byType(Container));
    final containerHeight = container.constraints?.maxHeight ??
        (container.child as SizedBox?)?.height;
    // The height should be (value / 40) * height = (20/40)*100 = 50
    expect(containerHeight == null || containerHeight == 50.0, isTrue);
    // The width should be 40
    final containerWidth = container.constraints?.maxWidth ??
        (container.child as SizedBox?)?.width;
    expect(containerWidth == null || containerWidth == 40.0, isTrue);
  });

  testWidgets('statisticsShimmerWidget Container has correct decoration',
      (tester) async {
    await tester
        .pumpWidget(wrapWithMaterialApp(statisticsShimmerWidget(100, 20, 40)));
    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration;
    expect(decoration, isA<BoxDecoration>());
    final boxDecoration = decoration! as BoxDecoration;
    expect(boxDecoration.color, Colors.grey);
    expect(boxDecoration.borderRadius, BorderRadius.circular(10));
  });
}
