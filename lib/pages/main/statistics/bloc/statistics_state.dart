import 'package:admin/constants.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/filters_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'statistics_state.g.dart';

abstract class StatisticsState
    implements Built<StatisticsState, StatisticsStateBuilder> {
  factory StatisticsState([
    final void Function(StatisticsStateBuilder) updates,
  ]) = _$StatisticsState;

  StatisticsState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final StatisticsStateBuilder b) => b
    ..selectedDropDownValue = Constants.peakVisitorsHourKey
    ..statisticsGuideShow = false
    ..currentGuideKey = ""
    ..selectedTimeInterval =
        FiltersModel(title: "This Week", value: "this_week", isSelected: true)
    ..dropDownItems.replace([
      Constants.peakVisitorsHourKey,
      Constants.daysOfWeekKey,
      Constants.frequencyOfVisitsKey,
      Constants.unknownVisitorsKey,
    ])
    ..statisticsList.replace([]);

  @BlocUpdateField()
  String get selectedDropDownValue;

  @BlocUpdateField()
  FiltersModel get selectedTimeInterval;

  @BlocUpdateField()
  bool get statisticsGuideShow;

  @BlocUpdateField()
  String get currentGuideKey;

  @BlocUpdateField()
  BuiltList<StatisticsModel> get statisticsList;

  @BlocUpdateField()
  BuiltList<String> get dropDownItems;

  ApiState<void> get statisticsVisitorApi;
}
