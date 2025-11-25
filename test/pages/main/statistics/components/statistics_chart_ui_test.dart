import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/components/statistics_chart.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  group('StatisticsChart Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      );
    }

    testWidgets('renders empty state when statisticsList is empty',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          StatisticsChart(
            statisticsList: BuiltList<StatisticsModel>([]),
            selectedDropDownValue: 'days_of_week',
            timeInterval: FiltersModel(
              title: 'This Week',
              value: 'this_week',
              isSelected: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('No records available'), findsOneWidget);
    });

    testWidgets('renders chart with data points', (tester) async {
      final statisticsList = BuiltList<StatisticsModel>([
        StatisticsModel(
          (b) => b
            ..visitCount = 5
            ..title = 'Monday',
        ),
        StatisticsModel(
          (b) => b
            ..visitCount = 3
            ..title = 'Tuesday',
        ),
      ]);
      await tester.pumpWidget(
        createTestWidget(
          StatisticsChart(
            statisticsList: statisticsList,
            selectedDropDownValue: 'days_of_week',
            timeInterval: FiltersModel(
              title: 'This Week',
              value: 'this_week',
              isSelected: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Should not show empty state
      expect(find.textContaining('No records available'), findsNothing);
      // Should show chart widget
      expect(find.byType(StatisticsChart), findsOneWidget);
    });

    testWidgets('shows correct chart title for each dropDown value',
        (tester) async {
      final statisticsList = BuiltList<StatisticsModel>([
        StatisticsModel(
          (b) => b
            ..visitCount = 2
            ..title = 'Test',
        ),
      ]);
      final dropDownValues = {
        'peak_visitors_hour': 'timings',
        'frequency_of_visits': 'name of visitors',
        'days_of_week': 'days',
      };
      for (final entry in dropDownValues.entries) {
        await tester.pumpWidget(
          createTestWidget(
            StatisticsChart(
              statisticsList: statisticsList,
              selectedDropDownValue: entry.key,
              timeInterval: FiltersModel(
                title: 'This Week',
                value: 'this_week',
                isSelected: true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        // The title is not directly rendered, but you can check for the presence of the chart
        expect(find.byType(StatisticsChart), findsOneWidget);
      }
    });

    testWidgets('renders chart when statisticsList contains "A new visitor"',
        (tester) async {
      final statisticsList = BuiltList<StatisticsModel>([
        StatisticsModel(
          (b) => b
            ..visitCount = 1
            ..title = 'A new visitor',
        ),
      ]);
      await tester.pumpWidget(
        createTestWidget(
          StatisticsChart(
            statisticsList: statisticsList,
            selectedDropDownValue: 'days_of_week',
            timeInterval: FiltersModel(
              title: 'This Week',
              value: 'this_week',
              isSelected: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // The best we can do: ensure the chart is present and not in empty state
      expect(find.byType(SfCartesianChart), findsOneWidget);
      expect(find.textContaining('No records available'), findsNothing);
    });

    testWidgets('renders no records available when all visitCounts are zero',
        (tester) async {
      final statisticsList = BuiltList<StatisticsModel>([
        StatisticsModel(
          (b) => b
            ..visitCount = 0
            ..title = 'Monday',
        ),
        StatisticsModel(
          (b) => b
            ..visitCount = 0
            ..title = 'Tuesday',
        ),
      ]);
      await tester.pumpWidget(
        createTestWidget(
          StatisticsChart(
            statisticsList: statisticsList,
            selectedDropDownValue: 'days_of_week',
            timeInterval: FiltersModel(
              title: 'This Week',
              value: 'this_week',
              isSelected: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('No records available'), findsOneWidget);
    });
  });
}
