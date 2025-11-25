// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatisticsState extends StatisticsState {
  @override
  final String selectedDropDownValue;
  @override
  final FiltersModel selectedTimeInterval;
  @override
  final bool statisticsGuideShow;
  @override
  final String currentGuideKey;
  @override
  final BuiltList<StatisticsModel> statisticsList;
  @override
  final BuiltList<String> dropDownItems;
  @override
  final ApiState<void> statisticsVisitorApi;

  factory _$StatisticsState([void Function(StatisticsStateBuilder)? updates]) =>
      (StatisticsStateBuilder()..update(updates))._build();

  _$StatisticsState._(
      {required this.selectedDropDownValue,
      required this.selectedTimeInterval,
      required this.statisticsGuideShow,
      required this.currentGuideKey,
      required this.statisticsList,
      required this.dropDownItems,
      required this.statisticsVisitorApi})
      : super._();
  @override
  StatisticsState rebuild(void Function(StatisticsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatisticsStateBuilder toBuilder() => StatisticsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatisticsState &&
        selectedDropDownValue == other.selectedDropDownValue &&
        selectedTimeInterval == other.selectedTimeInterval &&
        statisticsGuideShow == other.statisticsGuideShow &&
        currentGuideKey == other.currentGuideKey &&
        statisticsList == other.statisticsList &&
        dropDownItems == other.dropDownItems &&
        statisticsVisitorApi == other.statisticsVisitorApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, selectedDropDownValue.hashCode);
    _$hash = $jc(_$hash, selectedTimeInterval.hashCode);
    _$hash = $jc(_$hash, statisticsGuideShow.hashCode);
    _$hash = $jc(_$hash, currentGuideKey.hashCode);
    _$hash = $jc(_$hash, statisticsList.hashCode);
    _$hash = $jc(_$hash, dropDownItems.hashCode);
    _$hash = $jc(_$hash, statisticsVisitorApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatisticsState')
          ..add('selectedDropDownValue', selectedDropDownValue)
          ..add('selectedTimeInterval', selectedTimeInterval)
          ..add('statisticsGuideShow', statisticsGuideShow)
          ..add('currentGuideKey', currentGuideKey)
          ..add('statisticsList', statisticsList)
          ..add('dropDownItems', dropDownItems)
          ..add('statisticsVisitorApi', statisticsVisitorApi))
        .toString();
  }
}

class StatisticsStateBuilder
    implements Builder<StatisticsState, StatisticsStateBuilder> {
  _$StatisticsState? _$v;

  String? _selectedDropDownValue;
  String? get selectedDropDownValue => _$this._selectedDropDownValue;
  set selectedDropDownValue(String? selectedDropDownValue) =>
      _$this._selectedDropDownValue = selectedDropDownValue;

  FiltersModel? _selectedTimeInterval;
  FiltersModel? get selectedTimeInterval => _$this._selectedTimeInterval;
  set selectedTimeInterval(FiltersModel? selectedTimeInterval) =>
      _$this._selectedTimeInterval = selectedTimeInterval;

  bool? _statisticsGuideShow;
  bool? get statisticsGuideShow => _$this._statisticsGuideShow;
  set statisticsGuideShow(bool? statisticsGuideShow) =>
      _$this._statisticsGuideShow = statisticsGuideShow;

  String? _currentGuideKey;
  String? get currentGuideKey => _$this._currentGuideKey;
  set currentGuideKey(String? currentGuideKey) =>
      _$this._currentGuideKey = currentGuideKey;

  ListBuilder<StatisticsModel>? _statisticsList;
  ListBuilder<StatisticsModel> get statisticsList =>
      _$this._statisticsList ??= ListBuilder<StatisticsModel>();
  set statisticsList(ListBuilder<StatisticsModel>? statisticsList) =>
      _$this._statisticsList = statisticsList;

  ListBuilder<String>? _dropDownItems;
  ListBuilder<String> get dropDownItems =>
      _$this._dropDownItems ??= ListBuilder<String>();
  set dropDownItems(ListBuilder<String>? dropDownItems) =>
      _$this._dropDownItems = dropDownItems;

  ApiStateBuilder<void>? _statisticsVisitorApi;
  ApiStateBuilder<void> get statisticsVisitorApi =>
      _$this._statisticsVisitorApi ??= ApiStateBuilder<void>();
  set statisticsVisitorApi(ApiStateBuilder<void>? statisticsVisitorApi) =>
      _$this._statisticsVisitorApi = statisticsVisitorApi;

  StatisticsStateBuilder() {
    StatisticsState._initialize(this);
  }

  StatisticsStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _selectedDropDownValue = $v.selectedDropDownValue;
      _selectedTimeInterval = $v.selectedTimeInterval;
      _statisticsGuideShow = $v.statisticsGuideShow;
      _currentGuideKey = $v.currentGuideKey;
      _statisticsList = $v.statisticsList.toBuilder();
      _dropDownItems = $v.dropDownItems.toBuilder();
      _statisticsVisitorApi = $v.statisticsVisitorApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatisticsState other) {
    _$v = other as _$StatisticsState;
  }

  @override
  void update(void Function(StatisticsStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatisticsState build() => _build();

  _$StatisticsState _build() {
    _$StatisticsState _$result;
    try {
      _$result = _$v ??
          _$StatisticsState._(
            selectedDropDownValue: BuiltValueNullFieldError.checkNotNull(
                selectedDropDownValue,
                r'StatisticsState',
                'selectedDropDownValue'),
            selectedTimeInterval: BuiltValueNullFieldError.checkNotNull(
                selectedTimeInterval,
                r'StatisticsState',
                'selectedTimeInterval'),
            statisticsGuideShow: BuiltValueNullFieldError.checkNotNull(
                statisticsGuideShow, r'StatisticsState', 'statisticsGuideShow'),
            currentGuideKey: BuiltValueNullFieldError.checkNotNull(
                currentGuideKey, r'StatisticsState', 'currentGuideKey'),
            statisticsList: statisticsList.build(),
            dropDownItems: dropDownItems.build(),
            statisticsVisitorApi: statisticsVisitorApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'statisticsList';
        statisticsList.build();
        _$failedField = 'dropDownItems';
        dropDownItems.build();
        _$failedField = 'statisticsVisitorApi';
        statisticsVisitorApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StatisticsState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
