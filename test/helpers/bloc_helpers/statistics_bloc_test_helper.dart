import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:admin/pages/main/statistics/bloc/statistics_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class StatisticsBlocTestHelper {
  late MockStatisticsBloc mockStatisticsBloc;
  late StatisticsState currentStatisticsState;

  void setup() {
    mockStatisticsBloc = MockStatisticsBloc();
    currentStatisticsState = MockStatisticsState();

    when(() => mockStatisticsBloc.stream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockStatisticsBloc.state).thenReturn(currentStatisticsState);

    // Mock GlobalKeys and ScrollController
    when(() => mockStatisticsBloc.statisticsChipsGuideKey)
        .thenReturn(GlobalKey());
    when(() => mockStatisticsBloc.statisticsDropdownGuideKey)
        .thenReturn(GlobalKey());
    when(() => mockStatisticsBloc.statisticsCalendarGuideKey)
        .thenReturn(GlobalKey());
    when(() => mockStatisticsBloc.statisticsFilterScrollController)
        .thenReturn(ScrollController());

    // Mock async and void methods used by the widget
    when(() => mockStatisticsBloc.callStatistics()).thenAnswer((_) async {});
    when(() => mockStatisticsBloc.updateSelectedTimeInterval(any()))
        .thenAnswer((_) {});
    when(() => mockStatisticsBloc.scrollToIndex(any(), any())).thenAnswer((_) {});

    setupDefaultState();
  }

  void setupDefaultState() {
    when(() => currentStatisticsState.selectedDropDownValue)
        .thenReturn('peak_visitors_hour');
    when(() => currentStatisticsState.selectedTimeInterval).thenReturn(
      FiltersModel(title: 'This Week', value: 'this_week', isSelected: true),
    );
    when(() => currentStatisticsState.statisticsGuideShow).thenReturn(false);
    when(() => currentStatisticsState.currentGuideKey).thenReturn('');
    when(() => currentStatisticsState.statisticsList)
        .thenReturn(BuiltList<StatisticsModel>([]));
    when(() => currentStatisticsState.dropDownItems).thenReturn(
      BuiltList<String>([
        'peak_visitors_hour',
        'days_of_week',
        'frequency_of_visits',
        'unknown_visitors',
      ]),
    );
    // Always return a real ApiState<void>
    final apiState = ApiState<void>((b) => b..isApiInProgress = false);
    when(() => currentStatisticsState.statisticsVisitorApi)
        .thenReturn(apiState);
  }

  void dispose() {
    // No stream controller to dispose
  }
}
