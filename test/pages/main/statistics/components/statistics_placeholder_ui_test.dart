import 'package:admin/pages/main/statistics/components/place_holder/statistics_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('StatisticsPlaceHolder renders without error', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(const StatisticsPlaceHolder()));
    expect(find.byType(StatisticsPlaceHolder), findsOneWidget);
  });

  testWidgets('StatisticsPlaceHolder contains shimmer effect', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(const StatisticsPlaceHolder()));
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('StatisticsPlaceHolder shows 5 shimmer bars', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(const StatisticsPlaceHolder()));
    // Each shimmer bar is a SizedBox of width 20.0
    final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
    // The first SizedBox is the main container, the next 5 are bars
    final barBoxes = sizedBoxes.where((box) => box.width == 20.0);
    expect(barBoxes.length, 5);
  });

  testWidgets('StatisticsPlaceHolder shimmer bars have correct structure',
      (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp(const StatisticsPlaceHolder()));
    // Each shimmer bar contains a Container with a border radius
    final containers = tester.widgetList<Container>(find.byType(Container));
    final barContainers = containers.where((c) {
      final decoration = c.decoration;
      return decoration is BoxDecoration &&
          decoration.borderRadius != null &&
          decoration.color == Colors.grey;
    });
    expect(barContainers.length, 5);
  });
}
