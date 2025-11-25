// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doorbell_management_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DoorbellManagementState extends DoorbellManagementState {
  @override
  final LatLng? center;
  @override
  final bool mapGuideShow;
  @override
  final String currentGuideKey;
  @override
  final bool doorbellNameSaveLoading;
  @override
  final LatLng? markerPosition;
  @override
  final double radiusInMeters;
  @override
  final bool backPress;
  @override
  final bool proceedButtonEnabled;
  @override
  final String locationName;
  @override
  final String? deviceId;
  @override
  final String? doorbellName;
  @override
  final String customDoorbellName;
  @override
  final DoorbellLocations? selectedLocation;
  @override
  final String companyAddress;
  @override
  final String streetBlockName;
  @override
  final Placemark? placeMark;
  @override
  final SuperTooltipController superToolTipController;
  @override
  final ApiState<void> createLocationApi;
  @override
  final ApiState<void> assignDoorbellApi;
  @override
  final ApiState<void> scanDoorBellApi;
  @override
  final ApiState<void> updateLocationApi;

  factory _$DoorbellManagementState(
          [void Function(DoorbellManagementStateBuilder)? updates]) =>
      (DoorbellManagementStateBuilder()..update(updates))._build();

  _$DoorbellManagementState._(
      {this.center,
      required this.mapGuideShow,
      required this.currentGuideKey,
      required this.doorbellNameSaveLoading,
      this.markerPosition,
      required this.radiusInMeters,
      required this.backPress,
      required this.proceedButtonEnabled,
      required this.locationName,
      this.deviceId,
      this.doorbellName,
      required this.customDoorbellName,
      this.selectedLocation,
      required this.companyAddress,
      required this.streetBlockName,
      this.placeMark,
      required this.superToolTipController,
      required this.createLocationApi,
      required this.assignDoorbellApi,
      required this.scanDoorBellApi,
      required this.updateLocationApi})
      : super._();
  @override
  DoorbellManagementState rebuild(
          void Function(DoorbellManagementStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DoorbellManagementStateBuilder toBuilder() =>
      DoorbellManagementStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DoorbellManagementState &&
        center == other.center &&
        mapGuideShow == other.mapGuideShow &&
        currentGuideKey == other.currentGuideKey &&
        doorbellNameSaveLoading == other.doorbellNameSaveLoading &&
        markerPosition == other.markerPosition &&
        radiusInMeters == other.radiusInMeters &&
        backPress == other.backPress &&
        proceedButtonEnabled == other.proceedButtonEnabled &&
        locationName == other.locationName &&
        deviceId == other.deviceId &&
        doorbellName == other.doorbellName &&
        customDoorbellName == other.customDoorbellName &&
        selectedLocation == other.selectedLocation &&
        companyAddress == other.companyAddress &&
        streetBlockName == other.streetBlockName &&
        placeMark == other.placeMark &&
        superToolTipController == other.superToolTipController &&
        createLocationApi == other.createLocationApi &&
        assignDoorbellApi == other.assignDoorbellApi &&
        scanDoorBellApi == other.scanDoorBellApi &&
        updateLocationApi == other.updateLocationApi;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, center.hashCode);
    _$hash = $jc(_$hash, mapGuideShow.hashCode);
    _$hash = $jc(_$hash, currentGuideKey.hashCode);
    _$hash = $jc(_$hash, doorbellNameSaveLoading.hashCode);
    _$hash = $jc(_$hash, markerPosition.hashCode);
    _$hash = $jc(_$hash, radiusInMeters.hashCode);
    _$hash = $jc(_$hash, backPress.hashCode);
    _$hash = $jc(_$hash, proceedButtonEnabled.hashCode);
    _$hash = $jc(_$hash, locationName.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, doorbellName.hashCode);
    _$hash = $jc(_$hash, customDoorbellName.hashCode);
    _$hash = $jc(_$hash, selectedLocation.hashCode);
    _$hash = $jc(_$hash, companyAddress.hashCode);
    _$hash = $jc(_$hash, streetBlockName.hashCode);
    _$hash = $jc(_$hash, placeMark.hashCode);
    _$hash = $jc(_$hash, superToolTipController.hashCode);
    _$hash = $jc(_$hash, createLocationApi.hashCode);
    _$hash = $jc(_$hash, assignDoorbellApi.hashCode);
    _$hash = $jc(_$hash, scanDoorBellApi.hashCode);
    _$hash = $jc(_$hash, updateLocationApi.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DoorbellManagementState')
          ..add('center', center)
          ..add('mapGuideShow', mapGuideShow)
          ..add('currentGuideKey', currentGuideKey)
          ..add('doorbellNameSaveLoading', doorbellNameSaveLoading)
          ..add('markerPosition', markerPosition)
          ..add('radiusInMeters', radiusInMeters)
          ..add('backPress', backPress)
          ..add('proceedButtonEnabled', proceedButtonEnabled)
          ..add('locationName', locationName)
          ..add('deviceId', deviceId)
          ..add('doorbellName', doorbellName)
          ..add('customDoorbellName', customDoorbellName)
          ..add('selectedLocation', selectedLocation)
          ..add('companyAddress', companyAddress)
          ..add('streetBlockName', streetBlockName)
          ..add('placeMark', placeMark)
          ..add('superToolTipController', superToolTipController)
          ..add('createLocationApi', createLocationApi)
          ..add('assignDoorbellApi', assignDoorbellApi)
          ..add('scanDoorBellApi', scanDoorBellApi)
          ..add('updateLocationApi', updateLocationApi))
        .toString();
  }
}

class DoorbellManagementStateBuilder
    implements
        Builder<DoorbellManagementState, DoorbellManagementStateBuilder> {
  _$DoorbellManagementState? _$v;

  LatLng? _center;
  LatLng? get center => _$this._center;
  set center(LatLng? center) => _$this._center = center;

  bool? _mapGuideShow;
  bool? get mapGuideShow => _$this._mapGuideShow;
  set mapGuideShow(bool? mapGuideShow) => _$this._mapGuideShow = mapGuideShow;

  String? _currentGuideKey;
  String? get currentGuideKey => _$this._currentGuideKey;
  set currentGuideKey(String? currentGuideKey) =>
      _$this._currentGuideKey = currentGuideKey;

  bool? _doorbellNameSaveLoading;
  bool? get doorbellNameSaveLoading => _$this._doorbellNameSaveLoading;
  set doorbellNameSaveLoading(bool? doorbellNameSaveLoading) =>
      _$this._doorbellNameSaveLoading = doorbellNameSaveLoading;

  LatLng? _markerPosition;
  LatLng? get markerPosition => _$this._markerPosition;
  set markerPosition(LatLng? markerPosition) =>
      _$this._markerPosition = markerPosition;

  double? _radiusInMeters;
  double? get radiusInMeters => _$this._radiusInMeters;
  set radiusInMeters(double? radiusInMeters) =>
      _$this._radiusInMeters = radiusInMeters;

  bool? _backPress;
  bool? get backPress => _$this._backPress;
  set backPress(bool? backPress) => _$this._backPress = backPress;

  bool? _proceedButtonEnabled;
  bool? get proceedButtonEnabled => _$this._proceedButtonEnabled;
  set proceedButtonEnabled(bool? proceedButtonEnabled) =>
      _$this._proceedButtonEnabled = proceedButtonEnabled;

  String? _locationName;
  String? get locationName => _$this._locationName;
  set locationName(String? locationName) => _$this._locationName = locationName;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _doorbellName;
  String? get doorbellName => _$this._doorbellName;
  set doorbellName(String? doorbellName) => _$this._doorbellName = doorbellName;

  String? _customDoorbellName;
  String? get customDoorbellName => _$this._customDoorbellName;
  set customDoorbellName(String? customDoorbellName) =>
      _$this._customDoorbellName = customDoorbellName;

  DoorbellLocationsBuilder? _selectedLocation;
  DoorbellLocationsBuilder get selectedLocation =>
      _$this._selectedLocation ??= DoorbellLocationsBuilder();
  set selectedLocation(DoorbellLocationsBuilder? selectedLocation) =>
      _$this._selectedLocation = selectedLocation;

  String? _companyAddress;
  String? get companyAddress => _$this._companyAddress;
  set companyAddress(String? companyAddress) =>
      _$this._companyAddress = companyAddress;

  String? _streetBlockName;
  String? get streetBlockName => _$this._streetBlockName;
  set streetBlockName(String? streetBlockName) =>
      _$this._streetBlockName = streetBlockName;

  Placemark? _placeMark;
  Placemark? get placeMark => _$this._placeMark;
  set placeMark(Placemark? placeMark) => _$this._placeMark = placeMark;

  SuperTooltipController? _superToolTipController;
  SuperTooltipController? get superToolTipController =>
      _$this._superToolTipController;
  set superToolTipController(SuperTooltipController? superToolTipController) =>
      _$this._superToolTipController = superToolTipController;

  ApiStateBuilder<void>? _createLocationApi;
  ApiStateBuilder<void> get createLocationApi =>
      _$this._createLocationApi ??= ApiStateBuilder<void>();
  set createLocationApi(ApiStateBuilder<void>? createLocationApi) =>
      _$this._createLocationApi = createLocationApi;

  ApiStateBuilder<void>? _assignDoorbellApi;
  ApiStateBuilder<void> get assignDoorbellApi =>
      _$this._assignDoorbellApi ??= ApiStateBuilder<void>();
  set assignDoorbellApi(ApiStateBuilder<void>? assignDoorbellApi) =>
      _$this._assignDoorbellApi = assignDoorbellApi;

  ApiStateBuilder<void>? _scanDoorBellApi;
  ApiStateBuilder<void> get scanDoorBellApi =>
      _$this._scanDoorBellApi ??= ApiStateBuilder<void>();
  set scanDoorBellApi(ApiStateBuilder<void>? scanDoorBellApi) =>
      _$this._scanDoorBellApi = scanDoorBellApi;

  ApiStateBuilder<void>? _updateLocationApi;
  ApiStateBuilder<void> get updateLocationApi =>
      _$this._updateLocationApi ??= ApiStateBuilder<void>();
  set updateLocationApi(ApiStateBuilder<void>? updateLocationApi) =>
      _$this._updateLocationApi = updateLocationApi;

  DoorbellManagementStateBuilder() {
    DoorbellManagementState._initialize(this);
  }

  DoorbellManagementStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _center = $v.center;
      _mapGuideShow = $v.mapGuideShow;
      _currentGuideKey = $v.currentGuideKey;
      _doorbellNameSaveLoading = $v.doorbellNameSaveLoading;
      _markerPosition = $v.markerPosition;
      _radiusInMeters = $v.radiusInMeters;
      _backPress = $v.backPress;
      _proceedButtonEnabled = $v.proceedButtonEnabled;
      _locationName = $v.locationName;
      _deviceId = $v.deviceId;
      _doorbellName = $v.doorbellName;
      _customDoorbellName = $v.customDoorbellName;
      _selectedLocation = $v.selectedLocation?.toBuilder();
      _companyAddress = $v.companyAddress;
      _streetBlockName = $v.streetBlockName;
      _placeMark = $v.placeMark;
      _superToolTipController = $v.superToolTipController;
      _createLocationApi = $v.createLocationApi.toBuilder();
      _assignDoorbellApi = $v.assignDoorbellApi.toBuilder();
      _scanDoorBellApi = $v.scanDoorBellApi.toBuilder();
      _updateLocationApi = $v.updateLocationApi.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DoorbellManagementState other) {
    _$v = other as _$DoorbellManagementState;
  }

  @override
  void update(void Function(DoorbellManagementStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DoorbellManagementState build() => _build();

  _$DoorbellManagementState _build() {
    _$DoorbellManagementState _$result;
    try {
      _$result = _$v ??
          _$DoorbellManagementState._(
            center: center,
            mapGuideShow: BuiltValueNullFieldError.checkNotNull(
                mapGuideShow, r'DoorbellManagementState', 'mapGuideShow'),
            currentGuideKey: BuiltValueNullFieldError.checkNotNull(
                currentGuideKey, r'DoorbellManagementState', 'currentGuideKey'),
            doorbellNameSaveLoading: BuiltValueNullFieldError.checkNotNull(
                doorbellNameSaveLoading,
                r'DoorbellManagementState',
                'doorbellNameSaveLoading'),
            markerPosition: markerPosition,
            radiusInMeters: BuiltValueNullFieldError.checkNotNull(
                radiusInMeters, r'DoorbellManagementState', 'radiusInMeters'),
            backPress: BuiltValueNullFieldError.checkNotNull(
                backPress, r'DoorbellManagementState', 'backPress'),
            proceedButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                proceedButtonEnabled,
                r'DoorbellManagementState',
                'proceedButtonEnabled'),
            locationName: BuiltValueNullFieldError.checkNotNull(
                locationName, r'DoorbellManagementState', 'locationName'),
            deviceId: deviceId,
            doorbellName: doorbellName,
            customDoorbellName: BuiltValueNullFieldError.checkNotNull(
                customDoorbellName,
                r'DoorbellManagementState',
                'customDoorbellName'),
            selectedLocation: _selectedLocation?.build(),
            companyAddress: BuiltValueNullFieldError.checkNotNull(
                companyAddress, r'DoorbellManagementState', 'companyAddress'),
            streetBlockName: BuiltValueNullFieldError.checkNotNull(
                streetBlockName, r'DoorbellManagementState', 'streetBlockName'),
            placeMark: placeMark,
            superToolTipController: BuiltValueNullFieldError.checkNotNull(
                superToolTipController,
                r'DoorbellManagementState',
                'superToolTipController'),
            createLocationApi: createLocationApi.build(),
            assignDoorbellApi: assignDoorbellApi.build(),
            scanDoorBellApi: scanDoorBellApi.build(),
            updateLocationApi: updateLocationApi.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'selectedLocation';
        _selectedLocation?.build();

        _$failedField = 'createLocationApi';
        createLocationApi.build();
        _$failedField = 'assignDoorbellApi';
        assignDoorbellApi.build();
        _$failedField = 'scanDoorBellApi';
        scanDoorBellApi.build();
        _$failedField = 'updateLocationApi';
        updateLocationApi.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DoorbellManagementState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
