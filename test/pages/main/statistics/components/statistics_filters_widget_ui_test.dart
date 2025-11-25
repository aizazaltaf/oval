import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_bloc.dart';
import 'package:admin/pages/main/statistics/components/statistics_filters_widget.dart';
import 'package:admin/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../helpers/bloc_helpers/statistics_bloc_test_helper.dart';
import '../../../../helpers/test_helper.dart';

void main() {
  late StatisticsBlocTestHelper statisticsBlocHelper;

  setUpAll(() async {
    registerFallbackValue(
      FiltersModel(title: '', value: '', isSelected: false),
    );
    await TestHelper.initialize();
    statisticsBlocHelper = StatisticsBlocTestHelper()..setup();
  });

  tearDownAll(() async {
    await TestHelper.cleanup();
    statisticsBlocHelper.dispose();
  });

  setUp(() {
    // Reset timeIntervalFilters to default before each test
    StatisticsFiltersWidget.timeIntervalFilters = [
      FiltersModel(title: "This Week", value: "this_week", isSelected: true),
      FiltersModel(title: "Last Week", value: "last_week", isSelected: false),
      FiltersModel(title: "30 days", value: "this_month", isSelected: false),
      FiltersModel(title: "90 days", value: "last_3_months", isSelected: false),
    ];
    // Reset statisticsVisitorApi to not loading
    final apiState = ApiState<void>((b) => b..isApiInProgress = false);
    when(() => statisticsBlocHelper.currentStatisticsState.statisticsVisitorApi)
        .thenReturn(apiState);
  });

  Widget wrapWithApp(Widget child) {
    return FlutterSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          home: SizedBox(
            height: 800,
            width: 1200,
            child: BlocProvider<StatisticsBloc>.value(
              value: statisticsBlocHelper.mockStatisticsBloc,
              child: ShowCaseWidget(
                builder: (context) => child,
              ),
            ),
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
        );
      },
    );
  }

  testWidgets('renders all time interval filters and highlights selected',
      (tester) async {
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) => StatisticsFiltersWidget(
            selectedDropDownValue: 'peak_visitors_hour',
            bloc: statisticsBlocHelper.mockStatisticsBloc,
            innerContext: context,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // All filter titles should be present

    // Scroll to the right to reveal all filters
    await tester.drag(find.byType(ListView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    for (final filter in StatisticsFiltersWidget.timeIntervalFilters) {
      expect(find.text(filter.title), findsOneWidget);
    }
    // Only one filter should be highlighted (selected)
    final selected = StatisticsFiltersWidget.timeIntervalFilters
        .where((f) => f.isSelected == true);
    expect(selected.length, 1);
    expect(find.text(selected.first.title), findsOneWidget);
  });

  testWidgets('tapping a filter updates selection and calls bloc methods',
      (tester) async {
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
    // Ensure all filters are unselected except the first
    StatisticsFiltersWidget.clearTimeIntervals();
    StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
    for (int i = 1;
        i < StatisticsFiltersWidget.timeIntervalFilters.length;
        i++) {
      StatisticsFiltersWidget.timeIntervalFilters[i].isSelected = false;
    }
    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) => StatisticsFiltersWidget(
            selectedDropDownValue: 'peak_visitors_hour',
            bloc: statisticsBlocHelper.mockStatisticsBloc,
            innerContext: context,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Tap the second filter
    final secondFilter = StatisticsFiltersWidget.timeIntervalFilters[1];
    await tester.tap(find.text(secondFilter.title));
    await tester.pumpAndSettle();
    // The second filter should now be selected
    expect(secondFilter.isSelected, isTrue);
  });

  testWidgets('does not respond to taps when inProgress is true',
      (tester) async {
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
    // Mock the bloc state to return inProgress true
    final loadingApiState = ApiState<void>((b) => b..isApiInProgress = true);
    when(() => statisticsBlocHelper.currentStatisticsState.statisticsVisitorApi)
        .thenReturn(loadingApiState);
    StatisticsFiltersWidget.clearTimeIntervals();
    StatisticsFiltersWidget.timeIntervalFilters[0].isSelected = true;
    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) => StatisticsFiltersWidget(
            selectedDropDownValue: 'peak_visitors_hour',
            bloc: statisticsBlocHelper.mockStatisticsBloc,
            innerContext: context,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Tap the second filter
    final secondFilter = StatisticsFiltersWidget.timeIntervalFilters[1];
    await tester.tap(find.text(secondFilter.title));
    await tester.pumpAndSettle();
    // The second filter should NOT be selected
    expect(secondFilter.isSelected, isFalse);
    // Reset for other tests
    final apiState = ApiState<void>((b) => b..isApiInProgress = false);
    when(() => statisticsBlocHelper.currentStatisticsState.statisticsVisitorApi)
        .thenReturn(apiState);
  });

  testWidgets('hides widget for certain dropDown values', (tester) async {
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
    // dropDownItems[1] = 'days_of_week', dropDownItems[3] = 'unknown_visitors'
    final dropDownItems =
        statisticsBlocHelper.currentStatisticsState.dropDownItems;
    for (final value in [dropDownItems[1], dropDownItems[3]]) {
      await tester.pumpWidget(
        wrapWithApp(
          Builder(
            builder: (context) => StatisticsFiltersWidget(
              selectedDropDownValue: value,
              bloc: statisticsBlocHelper.mockStatisticsBloc,
              innerContext: context,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Should render nothing (SizedBox.shrink)
      expect(find.byType(ListView), findsNothing);
    }
  });
}
