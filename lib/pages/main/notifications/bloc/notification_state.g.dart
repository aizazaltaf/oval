// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationState extends NotificationState {
  @override
  final BuiltList<FeatureModel> dateFilters;
  @override
  final BuiltList<FeatureModel> aiAlertsFilters;
  @override
  final BuiltList<FeatureModel> aiAlertsSubFilters;
  @override
  final BuiltList<FeatureModel> deviceFilters;
  @override
  final bool notificationGuideShow;
  @override
  final String currentGuideKey;
  @override
  final String noDeviceAvailable;
  @override
  final DateTime? customDate;
  @override
  final bool filter;
  @override
  final bool newNotification;
  @override
  final String filterParam;
  @override
  final String deviceId;
  @override
  final ApiState<PaginatedData<NotificationData>> notificationApi;
  @override
  final ApiState<void> updateDoorbellSchedule;
  @override
  final ApiState<PaginatedData<NotificationData>> unReadNotificationApi;
  @override
  final Map<String, bool>? notificationDeviceStatus;

  factory _$NotificationState(
          [void Function(NotificationStateBuilder)? updates]) =>
      (NotificationStateBuilder()..update(updates))._build();

  _$NotificationState._(
      {required this.dateFilters,
      required this.aiAlertsFilters,
      required this.aiAlertsSubFilters,
      required this.deviceFilters,
      required this.notificationGuideShow,
      required this.currentGuideKey,
      required this.noDeviceAvailable,
      this.customDate,
      required this.filter,
      required this.newNotification,
      required this.filterParam,
      required this.deviceId,
      required this.notificationApi,
      required this.updateDoorbellSchedule,
      required this.unReadNotificationApi,
      this.notificationDeviceStatus})
      : super._();
  @override
  NotificationState rebuild(void Function(NotificationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationStateBuilder toBuilder() =>
      NotificationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationState &&
        dateFilters == other.dateFilters &&
        aiAlertsFilters == other.aiAlertsFilters &&
        aiAlertsSubFilters == other.aiAlertsSubFilters &&
        deviceFilters == other.deviceFilters &&
        notificationGuideShow == other.notificationGuideShow &&
        currentGuideKey == other.currentGuideKey &&
        noDeviceAvailable == other.noDeviceAvailable &&
        customDate == other.customDate &&
        filter == other.filter &&
        newNotification == other.newNotification &&
        filterParam == other.filterParam &&
        deviceId == other.deviceId &&
        notificationApi == other.notificationApi &&
        updateDoorbellSchedule == other.updateDoorbellSchedule &&
        unReadNotificationApi == other.unReadNotificationApi &&
        notificationDeviceStatus == other.notificationDeviceStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dateFilters.hashCode);
    _$hash = $jc(_$hash, aiAlertsFilters.hashCode);
    _$hash = $jc(_$hash, aiAlertsSubFilters.hashCode);
    _$hash = $jc(_$hash, deviceFilters.hashCode);
    _$hash = $jc(_$hash, notificationGuideShow.hashCode);
    _$hash = $jc(_$hash, currentGuideKey.hashCode);
    _$hash = $jc(_$hash, noDeviceAvailable.hashCode);
    _$hash = $jc(_$hash, customDate.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jc(_$hash, newNotification.hashCode);
    _$hash = $jc(_$hash, filterParam.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, notificationApi.hashCode);
    _$hash = $jc(_$hash, updateDoorbellSchedule.hashCode);
    _$hash = $jc(_$hash, unReadNotificationApi.hashCode);
    _$hash = $jc(_$hash, notificationDeviceStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationState')
          ..add('dateFilters', dateFilters)
          ..add('aiAlertsFilters', aiAlertsFilters)
          ..add('aiAlertsSubFilters', aiAlertsSubFilters)
          ..add('deviceFilters', deviceFilters)
          ..add('notificationGuideShow', notificationGuideShow)
          ..add('currentGuideKey', currentGuideKey)
          ..add('noDeviceAvailable', noDeviceAvailable)
          ..add('customDate', customDate)
          ..add('filter', filter)
          ..add('newNotification', newNotification)
          ..add('filterParam', filterParam)
          ..add('deviceId', deviceId)
          ..add('notificationApi', notificationApi)
          ..add('updateDoorbellSchedule', updateDoorbellSchedule)
          ..add('unReadNotificationApi', unReadNotificationApi)
          ..add('notificationDeviceStatus', notificationDeviceStatus))
        .toString();
  }
}

class NotificationStateBuilder
    implements Builder<NotificationState, NotificationStateBuilder> {
  _$NotificationState? _$v;

  ListBuilder<FeatureModel>? _dateFilters;
  ListBuilder<FeatureModel> get dateFilters =>
      _$this._dateFilters ??= ListBuilder<FeatureModel>();
  set dateFilters(ListBuilder<FeatureModel>? dateFilters) =>
      _$this._dateFilters = dateFilters;

  ListBuilder<FeatureModel>? _aiAlertsFilters;
  ListBuilder<FeatureModel> get aiAlertsFilters =>
      _$this._aiAlertsFilters ??= ListBuilder<FeatureModel>();
  set aiAlertsFilters(ListBuilder<FeatureModel>? aiAlertsFilters) =>
      _$this._aiAlertsFilters = aiAlertsFilters;

  ListBuilder<FeatureModel>? _aiAlertsSubFilters;
  ListBuilder<FeatureModel> get aiAlertsSubFilters =>
      _$this._aiAlertsSubFilters ??= ListBuilder<FeatureModel>();
  set aiAlertsSubFilters(ListBuilder<FeatureModel>? aiAlertsSubFilters) =>
      _$this._aiAlertsSubFilters = aiAlertsSubFilters;

  ListBuilder<FeatureModel>? _deviceFilters;
  ListBuilder<FeatureModel> get deviceFilters =>
      _$this._deviceFilters ??= ListBuilder<FeatureModel>();
  set deviceFilters(ListBuilder<FeatureModel>? deviceFilters) =>
      _$this._deviceFilters = deviceFilters;

  bool? _notificationGuideShow;
  bool? get notificationGuideShow => _$this._notificationGuideShow;
  set notificationGuideShow(bool? notificationGuideShow) =>
      _$this._notificationGuideShow = notificationGuideShow;

  String? _currentGuideKey;
  String? get currentGuideKey => _$this._currentGuideKey;
  set currentGuideKey(String? currentGuideKey) =>
      _$this._currentGuideKey = currentGuideKey;

  String? _noDeviceAvailable;
  String? get noDeviceAvailable => _$this._noDeviceAvailable;
  set noDeviceAvailable(String? noDeviceAvailable) =>
      _$this._noDeviceAvailable = noDeviceAvailable;

  DateTime? _customDate;
  DateTime? get customDate => _$this._customDate;
  set customDate(DateTime? customDate) => _$this._customDate = customDate;

  bool? _filter;
  bool? get filter => _$this._filter;
  set filter(bool? filter) => _$this._filter = filter;

  bool? _newNotification;
  bool? get newNotification => _$this._newNotification;
  set newNotification(bool? newNotification) =>
      _$this._newNotification = newNotification;

  String? _filterParam;
  String? get filterParam => _$this._filterParam;
  set filterParam(String? filterParam) => _$this._filterParam = filterParam;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  ApiStateBuilder<PaginatedData<NotificationData>>? _notificationApi;
  ApiStateBuilder<PaginatedData<NotificationData>> get notificationApi =>
      _$this._notificationApi ??=
          ApiStateBuilder<PaginatedData<NotificationData>>();
  set notificationApi(
          ApiStateBuilder<PaginatedData<NotificationData>>? notificationApi) =>
      _$this._notificationApi = notificationApi;

  ApiStateBuilder<void>? _updateDoorbellSchedule;
  ApiStateBuilder<void> get updateDoorbellSchedule =>
      _$this._updateDoorbellSchedule ??= ApiStateBuilder<void>();
  set updateDoorbellSchedule(ApiStateBuilder<void>? updateDoorbellSchedule) =>
      _$this._updateDoorbellSchedule = updateDoorbellSchedule;

  ApiStateBuilder<PaginatedData<NotificationData>>? _unReadNotificationApi;
  ApiStateBuilder<PaginatedData<NotificationData>> get unReadNotificationApi =>
      _$this._unReadNotificationApi ??=
          ApiStateBuilder<PaginatedData<NotificationData>>();
  set unReadNotificationApi(
          ApiStateBuilder<PaginatedData<NotificationData>>?
              unReadNotificationApi) =>
      _$this._unReadNotificationApi = unReadNotificationApi;

  Map<String, bool>? _notificationDeviceStatus;
  Map<String, bool>? get notificationDeviceStatus =>
      _$this._notificationDeviceStatus;
  set notificationDeviceStatus(Map<String, bool>? notificationDeviceStatus) =>
      _$this._notificationDeviceStatus = notificationDeviceStatus;

  NotificationStateBuilder() {
    NotificationState._initialize(this);
  }

  NotificationStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dateFilters = $v.dateFilters.toBuilder();
      _aiAlertsFilters = $v.aiAlertsFilters.toBuilder();
      _aiAlertsSubFilters = $v.aiAlertsSubFilters.toBuilder();
      _deviceFilters = $v.deviceFilters.toBuilder();
      _notificationGuideShow = $v.notificationGuideShow;
      _currentGuideKey = $v.currentGuideKey;
      _noDeviceAvailable = $v.noDeviceAvailable;
      _customDate = $v.customDate;
      _filter = $v.filter;
      _newNotification = $v.newNotification;
      _filterParam = $v.filterParam;
      _deviceId = $v.deviceId;
      _notificationApi = $v.notificationApi.toBuilder();
      _updateDoorbellSchedule = $v.updateDoorbellSchedule.toBuilder();
      _unReadNotificationApi = $v.unReadNotificationApi.toBuilder();
      _notificationDeviceStatus = $v.notificationDeviceStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationState other) {
    _$v = other as _$NotificationState;
  }

  @override
  void update(void Function(NotificationStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationState build() => _build();

  _$NotificationState _build() {
    _$NotificationState _$result;
    try {
      _$result = _$v ??
          _$NotificationState._(
            dateFilters: dateFilters.build(),
            aiAlertsFilters: aiAlertsFilters.build(),
            aiAlertsSubFilters: aiAlertsSubFilters.build(),
            deviceFilters: deviceFilters.build(),
            notificationGuideShow: BuiltValueNullFieldError.checkNotNull(
                notificationGuideShow,
                r'NotificationState',
                'notificationGuideShow'),
            currentGuideKey: BuiltValueNullFieldError.checkNotNull(
                currentGuideKey, r'NotificationState', 'currentGuideKey'),
            noDeviceAvailable: BuiltValueNullFieldError.checkNotNull(
                noDeviceAvailable, r'NotificationState', 'noDeviceAvailable'),
            customDate: customDate,
            filter: BuiltValueNullFieldError.checkNotNull(
                filter, r'NotificationState', 'filter'),
            newNotification: BuiltValueNullFieldError.checkNotNull(
                newNotification, r'NotificationState', 'newNotification'),
            filterParam: BuiltValueNullFieldError.checkNotNull(
                filterParam, r'NotificationState', 'filterParam'),
            deviceId: BuiltValueNullFieldError.checkNotNull(
                deviceId, r'NotificationState', 'deviceId'),
            notificationApi: notificationApi.build(),
            updateDoorbellSchedule: updateDoorbellSchedule.build(),
            unReadNotificationApi: unReadNotificationApi.build(),
            notificationDeviceStatus: notificationDeviceStatus,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dateFilters';
        dateFilters.build();
        _$failedField = 'aiAlertsFilters';
        aiAlertsFilters.build();
        _$failedField = 'aiAlertsSubFilters';
        aiAlertsSubFilters.build();
        _$failedField = 'deviceFilters';
        deviceFilters.build();

        _$failedField = 'notificationApi';
        notificationApi.build();
        _$failedField = 'updateDoorbellSchedule';
        updateDoorbellSchedule.build();
        _$failedField = 'unReadNotificationApi';
        unReadNotificationApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NotificationState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
