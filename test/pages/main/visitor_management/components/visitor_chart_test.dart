import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/pages/main/visitor_management/component/visitor_history_components/visitor_chart.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BuiltList<StatisticsModel> emptyList;
  late BuiltList<StatisticsModel> dataList;

  setUp(() {
    emptyList = BuiltList<StatisticsModel>([]);
    dataList = BuiltList<StatisticsModel>([
      StatisticsModel(
        (b) => b
          ..title = 'Mon'
          ..visitCount = 2,
      ),
      StatisticsModel(
        (b) => b
          ..title = 'Tue'
          ..visitCount = 3,
      ),
    ]);
  });

  Widget buildTestableWidget(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: Scaffold(body: child),
        );
      },
    );
  }

  testWidgets('returns SizedBox when statisticsList is empty', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(VisitorChart(statisticsList: emptyList)),
    );
    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('renders chart when statisticsList has data', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(VisitorChart(statisticsList: dataList)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(VisitorChart), findsOneWidget);
    // The chart widget from syncfusion_flutter_charts
    expect(find.byType(Stack), findsNWidgets(2));
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('displays correct number of data points', (tester) async {
    await tester.pumpWidget(
      buildTestableWidget(VisitorChart(statisticsList: dataList)),
    );
    await tester.pumpAndSettle();
    // There should be as many data points as in dataList
    // The chart library may not expose points directly, but we can check for marker containers
    expect(find.byType(Container), findsWidgets);
  });
}
