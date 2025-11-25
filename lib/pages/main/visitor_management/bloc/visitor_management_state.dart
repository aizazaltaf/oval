import 'package:admin/models/data/paginated_data.dart';
import 'package:admin/models/data/statistics_model.dart';
import 'package:admin/models/data/visit_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'visitor_management_state.g.dart';

abstract class VisitorManagementState
    implements Built<VisitorManagementState, VisitorManagementStateBuilder> {
  factory VisitorManagementState([
    final void Function(VisitorManagementStateBuilder) updates,
  ]) = _$VisitorManagementState;

  VisitorManagementState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final VisitorManagementStateBuilder b) => b
    ..superToolTipController = SuperTooltipController()
    ..visitorName = ""
    ..visitHistoryFirstBool = false
    ..visitorNameSaveButtonEnabled = false
    ..statisticsList.replace([])
    ..currentGuideKey = ""
    ..visitorGuideShow = false
    ..historyGuideShow =
        false // false => guide should be shown now, true => guide has shown
    ..visitorNewNotification = false
    ..deleteVisitorHistoryIdsList;

  @BlocUpdateField()
  String? get search;

  @BlocUpdateField()
  String? get filterValue;

  @BlocUpdateField()
  bool get visitHistoryFirstBool;

  @BlocUpdateField()
  String? get visitorHistorySelectedFilter;

  @BlocUpdateField()
  bool get visitorGuideShow;

  @BlocUpdateField()
  bool get historyGuideShow;

  @BlocUpdateField()
  String get currentGuideKey;

  @BlocUpdateField()
  bool get visitorNewNotification;

  @BlocUpdateField()
  bool get visitorNameSaveButtonEnabled;

  @BlocUpdateField()
  String? get historyFilterValue;

  @BlocUpdateField()
  String get visitorName;

  @BlocUpdateField()
  BuiltList<String>? get deleteVisitorHistoryIdsList;

  @BlocUpdateField()
  VisitorsModel? get selectedVisitor;

  @BlocUpdateField()
  BuiltList<StatisticsModel> get statisticsList;

  SuperTooltipController get superToolTipController;

  ApiState<PaginatedData<VisitorsModel>> get visitorManagementApi;

  ApiState<PaginatedData<VisitModel>> get visitorHistoryApi;

  ApiState<void> get visitorManagementDeleteApi;

  ApiState<void> get visitorHistoryDeleteApi;

  ApiState<void> get markWantedOrUnwantedVisitorApi;

  ApiState<void> get editVisitorNameApi;

  ApiState<void> get statisticsVisitorApi;
}
