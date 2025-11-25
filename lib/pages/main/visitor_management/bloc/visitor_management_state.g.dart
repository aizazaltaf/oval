// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_management_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VisitorManagementState extends VisitorManagementState {
  @override
  final String? search;
  @override
  final String? filterValue;
  @override
  final bool visitHistoryFirstBool;
  @override
  final String? visitorHistorySelectedFilter;
  @override
  final bool visitorGuideShow;
  @override
  final bool historyGuideShow;
  @override
  final String currentGuideKey;
  @override
  final bool visitorNewNotification;
  @override
  final bool visitorNameSaveButtonEnabled;
  @override
  final String? historyFilterValue;
  @override
  final String visitorName;
  @override
  final BuiltList<String>? deleteVisitorHistoryIdsList;
  @override
  final VisitorsModel? selectedVisitor;
  @override
  final BuiltList<StatisticsModel> statisticsList;
  @override
  final SuperTooltipController superToolTipController;
  @override
  final ApiState<PaginatedData<VisitorsModel>> visitorManagementApi;
  @override
  final ApiState<PaginatedData<VisitModel>> visitorHistoryApi;
  @override
  final ApiState<void> visitorManagementDeleteApi;
  @override
  final ApiState<void> visitorHistoryDeleteApi;
  @override
  final ApiState<void> markWantedOrUnwantedVisitorApi;
  @override
  final ApiState<void> editVisitorNameApi;
  @override
  final ApiState<void> statisticsVisitorApi;

  factory _$VisitorManagementState(
          [void Function(VisitorManagementStateBuilder)? updates]) =>
      (VisitorManagementStateBuilder()..update(updates))._build();

  _$VisitorManagementState._(
      {this.search,
      this.filterValue,
      required this.visitHistoryFirstBool,
      this.visitorHistorySelectedFilter,
      required this.visitorGuideShow,
      required this.historyGuideShow,
      required this.currentGuideKey,
      required this.visitorNewNotification,
      required this.visitorNameSaveButtonEnabled,
      this.historyFilterValue,
      required this.visitorName,
      this.deleteVisitorHistoryIdsList,
      this.selectedVisitor,
      required this.statisticsList,
      required this.superToolTipController,
      required this.visitorManagementApi,
      required this.visitorHistoryApi,
      required this.visitorManagementDeleteApi,
      required this.visitorHistoryDeleteApi,
      required this.markWantedOrUnwantedVisitorApi,
      required this.editVisitorNameApi,
      required this.statisticsVisitorApi})
      : super._();
  @override
  VisitorManagementState rebuild(
          void Function(VisitorManagementStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VisitorManagementStateBuilder toBuilder() =>
      VisitorManagementStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VisitorManagementState &&
        search == other.search &&
        filterValue == other.filterValue &&
        visitHistoryFirstBool == other.visitHistoryFirstBool &&
        visitorHistorySelectedFilter == other.visitorHistorySelectedFilter &&
        visitorGuideShow == other.visitorGuideShow &&
        historyGuideShow == other.historyGuideShow &&
        currentGuideKey == other.currentGuideKey &&
        visitorNewNotification == other.visitorNewNotification &&
        visitorNameSaveButtonEnabled == other.visitorNameSaveButtonEnabled &&
        historyFilterValue == other.historyFilterValue &&
        visitorName == other.visitorName &&
        deleteVisitorHistoryIdsList == other.deleteVisitorHistoryIdsList &&
        selectedVisitor == other.selectedVisitor &&
        statisticsList == other.statisticsList &&
        superToolTipController == other.superToolTipController &&
        visitorManagementApi == other.visitorManagementApi &&
        visitorHistoryApi == other.visitorHistoryApi &&
        visitorManagementDeleteApi == other.visitorManagementDeleteApi &&
        visitorHistoryDeleteApi == other.visitorHistoryDeleteApi &&
        markWantedOrUnwantedVisitorApi ==
            other.markWantedOrUnwantedVisitorApi &&
        editVisitorNameApi == other.editVisitorNameApi &&
        statisticsVisitorApi == other.statisticsVisitorApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, filterValue.hashCode);
    _$hash = $jc(_$hash, visitHistoryFirstBool.hashCode);
    _$hash = $jc(_$hash, visitorHistorySelectedFilter.hashCode);
    _$hash = $jc(_$hash, visitorGuideShow.hashCode);
    _$hash = $jc(_$hash, historyGuideShow.hashCode);
    _$hash = $jc(_$hash, currentGuideKey.hashCode);
    _$hash = $jc(_$hash, visitorNewNotification.hashCode);
    _$hash = $jc(_$hash, visitorNameSaveButtonEnabled.hashCode);
    _$hash = $jc(_$hash, historyFilterValue.hashCode);
    _$hash = $jc(_$hash, visitorName.hashCode);
    _$hash = $jc(_$hash, deleteVisitorHistoryIdsList.hashCode);
    _$hash = $jc(_$hash, selectedVisitor.hashCode);
    _$hash = $jc(_$hash, statisticsList.hashCode);
    _$hash = $jc(_$hash, superToolTipController.hashCode);
    _$hash = $jc(_$hash, visitorManagementApi.hashCode);
    _$hash = $jc(_$hash, visitorHistoryApi.hashCode);
    _$hash = $jc(_$hash, visitorManagementDeleteApi.hashCode);
    _$hash = $jc(_$hash, visitorHistoryDeleteApi.hashCode);
    _$hash = $jc(_$hash, markWantedOrUnwantedVisitorApi.hashCode);
    _$hash = $jc(_$hash, editVisitorNameApi.hashCode);
    _$hash = $jc(_$hash, statisticsVisitorApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VisitorManagementState')
          ..add('search', search)
          ..add('filterValue', filterValue)
          ..add('visitHistoryFirstBool', visitHistoryFirstBool)
          ..add('visitorHistorySelectedFilter', visitorHistorySelectedFilter)
          ..add('visitorGuideShow', visitorGuideShow)
          ..add('historyGuideShow', historyGuideShow)
          ..add('currentGuideKey', currentGuideKey)
          ..add('visitorNewNotification', visitorNewNotification)
          ..add('visitorNameSaveButtonEnabled', visitorNameSaveButtonEnabled)
          ..add('historyFilterValue', historyFilterValue)
          ..add('visitorName', visitorName)
          ..add('deleteVisitorHistoryIdsList', deleteVisitorHistoryIdsList)
          ..add('selectedVisitor', selectedVisitor)
          ..add('statisticsList', statisticsList)
          ..add('superToolTipController', superToolTipController)
          ..add('visitorManagementApi', visitorManagementApi)
          ..add('visitorHistoryApi', visitorHistoryApi)
          ..add('visitorManagementDeleteApi', visitorManagementDeleteApi)
          ..add('visitorHistoryDeleteApi', visitorHistoryDeleteApi)
          ..add(
              'markWantedOrUnwantedVisitorApi', markWantedOrUnwantedVisitorApi)
          ..add('editVisitorNameApi', editVisitorNameApi)
          ..add('statisticsVisitorApi', statisticsVisitorApi))
        .toString();
  }
}

class VisitorManagementStateBuilder
    implements Builder<VisitorManagementState, VisitorManagementStateBuilder> {
  _$VisitorManagementState? _$v;

  String? _search;
  String? get search => _$this._search;
  set search(String? search) => _$this._search = search;

  String? _filterValue;
  String? get filterValue => _$this._filterValue;
  set filterValue(String? filterValue) => _$this._filterValue = filterValue;

  bool? _visitHistoryFirstBool;
  bool? get visitHistoryFirstBool => _$this._visitHistoryFirstBool;
  set visitHistoryFirstBool(bool? visitHistoryFirstBool) =>
      _$this._visitHistoryFirstBool = visitHistoryFirstBool;

  String? _visitorHistorySelectedFilter;
  String? get visitorHistorySelectedFilter =>
      _$this._visitorHistorySelectedFilter;
  set visitorHistorySelectedFilter(String? visitorHistorySelectedFilter) =>
      _$this._visitorHistorySelectedFilter = visitorHistorySelectedFilter;

  bool? _visitorGuideShow;
  bool? get visitorGuideShow => _$this._visitorGuideShow;
  set visitorGuideShow(bool? visitorGuideShow) =>
      _$this._visitorGuideShow = visitorGuideShow;

  bool? _historyGuideShow;
  bool? get historyGuideShow => _$this._historyGuideShow;
  set historyGuideShow(bool? historyGuideShow) =>
      _$this._historyGuideShow = historyGuideShow;

  String? _currentGuideKey;
  String? get currentGuideKey => _$this._currentGuideKey;
  set currentGuideKey(String? currentGuideKey) =>
      _$this._currentGuideKey = currentGuideKey;

  bool? _visitorNewNotification;
  bool? get visitorNewNotification => _$this._visitorNewNotification;
  set visitorNewNotification(bool? visitorNewNotification) =>
      _$this._visitorNewNotification = visitorNewNotification;

  bool? _visitorNameSaveButtonEnabled;
  bool? get visitorNameSaveButtonEnabled =>
      _$this._visitorNameSaveButtonEnabled;
  set visitorNameSaveButtonEnabled(bool? visitorNameSaveButtonEnabled) =>
      _$this._visitorNameSaveButtonEnabled = visitorNameSaveButtonEnabled;

  String? _historyFilterValue;
  String? get historyFilterValue => _$this._historyFilterValue;
  set historyFilterValue(String? historyFilterValue) =>
      _$this._historyFilterValue = historyFilterValue;

  String? _visitorName;
  String? get visitorName => _$this._visitorName;
  set visitorName(String? visitorName) => _$this._visitorName = visitorName;

  ListBuilder<String>? _deleteVisitorHistoryIdsList;
  ListBuilder<String> get deleteVisitorHistoryIdsList =>
      _$this._deleteVisitorHistoryIdsList ??= ListBuilder<String>();
  set deleteVisitorHistoryIdsList(
          ListBuilder<String>? deleteVisitorHistoryIdsList) =>
      _$this._deleteVisitorHistoryIdsList = deleteVisitorHistoryIdsList;

  VisitorsModelBuilder? _selectedVisitor;
  VisitorsModelBuilder get selectedVisitor =>
      _$this._selectedVisitor ??= VisitorsModelBuilder();
  set selectedVisitor(VisitorsModelBuilder? selectedVisitor) =>
      _$this._selectedVisitor = selectedVisitor;

  ListBuilder<StatisticsModel>? _statisticsList;
  ListBuilder<StatisticsModel> get statisticsList =>
      _$this._statisticsList ??= ListBuilder<StatisticsModel>();
  set statisticsList(ListBuilder<StatisticsModel>? statisticsList) =>
      _$this._statisticsList = statisticsList;

  SuperTooltipController? _superToolTipController;
  SuperTooltipController? get superToolTipController =>
      _$this._superToolTipController;
  set superToolTipController(SuperTooltipController? superToolTipController) =>
      _$this._superToolTipController = superToolTipController;

  ApiStateBuilder<PaginatedData<VisitorsModel>>? _visitorManagementApi;
  ApiStateBuilder<PaginatedData<VisitorsModel>> get visitorManagementApi =>
      _$this._visitorManagementApi ??=
          ApiStateBuilder<PaginatedData<VisitorsModel>>();
  set visitorManagementApi(
          ApiStateBuilder<PaginatedData<VisitorsModel>>?
              visitorManagementApi) =>
      _$this._visitorManagementApi = visitorManagementApi;

  ApiStateBuilder<PaginatedData<VisitModel>>? _visitorHistoryApi;
  ApiStateBuilder<PaginatedData<VisitModel>> get visitorHistoryApi =>
      _$this._visitorHistoryApi ??=
          ApiStateBuilder<PaginatedData<VisitModel>>();
  set visitorHistoryApi(
          ApiStateBuilder<PaginatedData<VisitModel>>? visitorHistoryApi) =>
      _$this._visitorHistoryApi = visitorHistoryApi;

  ApiStateBuilder<void>? _visitorManagementDeleteApi;
  ApiStateBuilder<void> get visitorManagementDeleteApi =>
      _$this._visitorManagementDeleteApi ??= ApiStateBuilder<void>();
  set visitorManagementDeleteApi(
          ApiStateBuilder<void>? visitorManagementDeleteApi) =>
      _$this._visitorManagementDeleteApi = visitorManagementDeleteApi;

  ApiStateBuilder<void>? _visitorHistoryDeleteApi;
  ApiStateBuilder<void> get visitorHistoryDeleteApi =>
      _$this._visitorHistoryDeleteApi ??= ApiStateBuilder<void>();
  set visitorHistoryDeleteApi(ApiStateBuilder<void>? visitorHistoryDeleteApi) =>
      _$this._visitorHistoryDeleteApi = visitorHistoryDeleteApi;

  ApiStateBuilder<void>? _markWantedOrUnwantedVisitorApi;
  ApiStateBuilder<void> get markWantedOrUnwantedVisitorApi =>
      _$this._markWantedOrUnwantedVisitorApi ??= ApiStateBuilder<void>();
  set markWantedOrUnwantedVisitorApi(
          ApiStateBuilder<void>? markWantedOrUnwantedVisitorApi) =>
      _$this._markWantedOrUnwantedVisitorApi = markWantedOrUnwantedVisitorApi;

  ApiStateBuilder<void>? _editVisitorNameApi;
  ApiStateBuilder<void> get editVisitorNameApi =>
      _$this._editVisitorNameApi ??= ApiStateBuilder<void>();
  set editVisitorNameApi(ApiStateBuilder<void>? editVisitorNameApi) =>
      _$this._editVisitorNameApi = editVisitorNameApi;

  ApiStateBuilder<void>? _statisticsVisitorApi;
  ApiStateBuilder<void> get statisticsVisitorApi =>
      _$this._statisticsVisitorApi ??= ApiStateBuilder<void>();
  set statisticsVisitorApi(ApiStateBuilder<void>? statisticsVisitorApi) =>
      _$this._statisticsVisitorApi = statisticsVisitorApi;

  VisitorManagementStateBuilder() {
    VisitorManagementState._initialize(this);
  }

  VisitorManagementStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _search = $v.search;
      _filterValue = $v.filterValue;
      _visitHistoryFirstBool = $v.visitHistoryFirstBool;
      _visitorHistorySelectedFilter = $v.visitorHistorySelectedFilter;
      _visitorGuideShow = $v.visitorGuideShow;
      _historyGuideShow = $v.historyGuideShow;
      _currentGuideKey = $v.currentGuideKey;
      _visitorNewNotification = $v.visitorNewNotification;
      _visitorNameSaveButtonEnabled = $v.visitorNameSaveButtonEnabled;
      _historyFilterValue = $v.historyFilterValue;
      _visitorName = $v.visitorName;
      _deleteVisitorHistoryIdsList =
          $v.deleteVisitorHistoryIdsList?.toBuilder();
      _selectedVisitor = $v.selectedVisitor?.toBuilder();
      _statisticsList = $v.statisticsList.toBuilder();
      _superToolTipController = $v.superToolTipController;
      _visitorManagementApi = $v.visitorManagementApi.toBuilder();
      _visitorHistoryApi = $v.visitorHistoryApi.toBuilder();
      _visitorManagementDeleteApi = $v.visitorManagementDeleteApi.toBuilder();
      _visitorHistoryDeleteApi = $v.visitorHistoryDeleteApi.toBuilder();
      _markWantedOrUnwantedVisitorApi =
          $v.markWantedOrUnwantedVisitorApi.toBuilder();
      _editVisitorNameApi = $v.editVisitorNameApi.toBuilder();
      _statisticsVisitorApi = $v.statisticsVisitorApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VisitorManagementState other) {
    _$v = other as _$VisitorManagementState;
  }

  @override
  void update(void Function(VisitorManagementStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VisitorManagementState build() => _build();

  _$VisitorManagementState _build() {
    _$VisitorManagementState _$result;
    try {
      _$result = _$v ??
          _$VisitorManagementState._(
            search: search,
            filterValue: filterValue,
            visitHistoryFirstBool: BuiltValueNullFieldError.checkNotNull(
                visitHistoryFirstBool,
                r'VisitorManagementState',
                'visitHistoryFirstBool'),
            visitorHistorySelectedFilter: visitorHistorySelectedFilter,
            visitorGuideShow: BuiltValueNullFieldError.checkNotNull(
                visitorGuideShow,
                r'VisitorManagementState',
                'visitorGuideShow'),
            historyGuideShow: BuiltValueNullFieldError.checkNotNull(
                historyGuideShow,
                r'VisitorManagementState',
                'historyGuideShow'),
            currentGuideKey: BuiltValueNullFieldError.checkNotNull(
                currentGuideKey, r'VisitorManagementState', 'currentGuideKey'),
            visitorNewNotification: BuiltValueNullFieldError.checkNotNull(
                visitorNewNotification,
                r'VisitorManagementState',
                'visitorNewNotification'),
            visitorNameSaveButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                visitorNameSaveButtonEnabled,
                r'VisitorManagementState',
                'visitorNameSaveButtonEnabled'),
            historyFilterValue: historyFilterValue,
            visitorName: BuiltValueNullFieldError.checkNotNull(
                visitorName, r'VisitorManagementState', 'visitorName'),
            deleteVisitorHistoryIdsList: _deleteVisitorHistoryIdsList?.build(),
            selectedVisitor: _selectedVisitor?.build(),
            statisticsList: statisticsList.build(),
            superToolTipController: BuiltValueNullFieldError.checkNotNull(
                superToolTipController,
                r'VisitorManagementState',
                'superToolTipController'),
            visitorManagementApi: visitorManagementApi.build(),
            visitorHistoryApi: visitorHistoryApi.build(),
            visitorManagementDeleteApi: visitorManagementDeleteApi.build(),
            visitorHistoryDeleteApi: visitorHistoryDeleteApi.build(),
            markWantedOrUnwantedVisitorApi:
                markWantedOrUnwantedVisitorApi.build(),
            editVisitorNameApi: editVisitorNameApi.build(),
            statisticsVisitorApi: statisticsVisitorApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'deleteVisitorHistoryIdsList';
        _deleteVisitorHistoryIdsList?.build();
        _$failedField = 'selectedVisitor';
        _selectedVisitor?.build();
        _$failedField = 'statisticsList';
        statisticsList.build();

        _$failedField = 'visitorManagementApi';
        visitorManagementApi.build();
        _$failedField = 'visitorHistoryApi';
        visitorHistoryApi.build();
        _$failedField = 'visitorManagementDeleteApi';
        visitorManagementDeleteApi.build();
        _$failedField = 'visitorHistoryDeleteApi';
        visitorHistoryDeleteApi.build();
        _$failedField = 'markWantedOrUnwantedVisitorApi';
        markWantedOrUnwantedVisitorApi.build();
        _$failedField = 'editVisitorNameApi';
        editVisitorNameApi.build();
        _$failedField = 'statisticsVisitorApi';
        statisticsVisitorApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VisitorManagementState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
