// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_onboarding_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeviceOnboardingState extends DeviceOnboardingState {
  @override
  final bool isBluetoothConnected;
  @override
  final bool isDoorbellWifiConnected;
  @override
  final bool checkDoorbellWifiConnection;
  @override
  final bool isWifiConnecting;
  @override
  final bool isBluetoothEnabled;
  @override
  final bool isScanning;
  @override
  final bool isConnecting;
  @override
  final String? connectedDeviceId;
  @override
  final String? connectedSSID;
  @override
  final BuiltList<BluetoothDevice> scannedDevices;
  @override
  final BuiltList<String> wifiNetworks;
  @override
  final String permissionStatus;
  @override
  final bool obscurePassword;
  @override
  final String wifiPassword;
  @override
  final SocketState<Map<String, dynamic>> getWifiResponse;

  factory _$DeviceOnboardingState(
          [void Function(DeviceOnboardingStateBuilder)? updates]) =>
      (DeviceOnboardingStateBuilder()..update(updates))._build();

  _$DeviceOnboardingState._(
      {required this.isBluetoothConnected,
      required this.isDoorbellWifiConnected,
      required this.checkDoorbellWifiConnection,
      required this.isWifiConnecting,
      required this.isBluetoothEnabled,
      required this.isScanning,
      required this.isConnecting,
      this.connectedDeviceId,
      this.connectedSSID,
      required this.scannedDevices,
      required this.wifiNetworks,
      required this.permissionStatus,
      required this.obscurePassword,
      required this.wifiPassword,
      required this.getWifiResponse})
      : super._();
  @override
  DeviceOnboardingState rebuild(
          void Function(DeviceOnboardingStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeviceOnboardingStateBuilder toBuilder() =>
      DeviceOnboardingStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeviceOnboardingState &&
        isBluetoothConnected == other.isBluetoothConnected &&
        isDoorbellWifiConnected == other.isDoorbellWifiConnected &&
        checkDoorbellWifiConnection == other.checkDoorbellWifiConnection &&
        isWifiConnecting == other.isWifiConnecting &&
        isBluetoothEnabled == other.isBluetoothEnabled &&
        isScanning == other.isScanning &&
        isConnecting == other.isConnecting &&
        connectedDeviceId == other.connectedDeviceId &&
        connectedSSID == other.connectedSSID &&
        scannedDevices == other.scannedDevices &&
        wifiNetworks == other.wifiNetworks &&
        permissionStatus == other.permissionStatus &&
        obscurePassword == other.obscurePassword &&
        wifiPassword == other.wifiPassword &&
        getWifiResponse == other.getWifiResponse;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isBluetoothConnected.hashCode);
    _$hash = $jc(_$hash, isDoorbellWifiConnected.hashCode);
    _$hash = $jc(_$hash, checkDoorbellWifiConnection.hashCode);
    _$hash = $jc(_$hash, isWifiConnecting.hashCode);
    _$hash = $jc(_$hash, isBluetoothEnabled.hashCode);
    _$hash = $jc(_$hash, isScanning.hashCode);
    _$hash = $jc(_$hash, isConnecting.hashCode);
    _$hash = $jc(_$hash, connectedDeviceId.hashCode);
    _$hash = $jc(_$hash, connectedSSID.hashCode);
    _$hash = $jc(_$hash, scannedDevices.hashCode);
    _$hash = $jc(_$hash, wifiNetworks.hashCode);
    _$hash = $jc(_$hash, permissionStatus.hashCode);
    _$hash = $jc(_$hash, obscurePassword.hashCode);
    _$hash = $jc(_$hash, wifiPassword.hashCode);
    _$hash = $jc(_$hash, getWifiResponse.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeviceOnboardingState')
          ..add('isBluetoothConnected', isBluetoothConnected)
          ..add('isDoorbellWifiConnected', isDoorbellWifiConnected)
          ..add('checkDoorbellWifiConnection', checkDoorbellWifiConnection)
          ..add('isWifiConnecting', isWifiConnecting)
          ..add('isBluetoothEnabled', isBluetoothEnabled)
          ..add('isScanning', isScanning)
          ..add('isConnecting', isConnecting)
          ..add('connectedDeviceId', connectedDeviceId)
          ..add('connectedSSID', connectedSSID)
          ..add('scannedDevices', scannedDevices)
          ..add('wifiNetworks', wifiNetworks)
          ..add('permissionStatus', permissionStatus)
          ..add('obscurePassword', obscurePassword)
          ..add('wifiPassword', wifiPassword)
          ..add('getWifiResponse', getWifiResponse))
        .toString();
  }
}

class DeviceOnboardingStateBuilder
    implements Builder<DeviceOnboardingState, DeviceOnboardingStateBuilder> {
  _$DeviceOnboardingState? _$v;

  bool? _isBluetoothConnected;
  bool? get isBluetoothConnected => _$this._isBluetoothConnected;
  set isBluetoothConnected(bool? isBluetoothConnected) =>
      _$this._isBluetoothConnected = isBluetoothConnected;

  bool? _isDoorbellWifiConnected;
  bool? get isDoorbellWifiConnected => _$this._isDoorbellWifiConnected;
  set isDoorbellWifiConnected(bool? isDoorbellWifiConnected) =>
      _$this._isDoorbellWifiConnected = isDoorbellWifiConnected;

  bool? _checkDoorbellWifiConnection;
  bool? get checkDoorbellWifiConnection => _$this._checkDoorbellWifiConnection;
  set checkDoorbellWifiConnection(bool? checkDoorbellWifiConnection) =>
      _$this._checkDoorbellWifiConnection = checkDoorbellWifiConnection;

  bool? _isWifiConnecting;
  bool? get isWifiConnecting => _$this._isWifiConnecting;
  set isWifiConnecting(bool? isWifiConnecting) =>
      _$this._isWifiConnecting = isWifiConnecting;

  bool? _isBluetoothEnabled;
  bool? get isBluetoothEnabled => _$this._isBluetoothEnabled;
  set isBluetoothEnabled(bool? isBluetoothEnabled) =>
      _$this._isBluetoothEnabled = isBluetoothEnabled;

  bool? _isScanning;
  bool? get isScanning => _$this._isScanning;
  set isScanning(bool? isScanning) => _$this._isScanning = isScanning;

  bool? _isConnecting;
  bool? get isConnecting => _$this._isConnecting;
  set isConnecting(bool? isConnecting) => _$this._isConnecting = isConnecting;

  String? _connectedDeviceId;
  String? get connectedDeviceId => _$this._connectedDeviceId;
  set connectedDeviceId(String? connectedDeviceId) =>
      _$this._connectedDeviceId = connectedDeviceId;

  String? _connectedSSID;
  String? get connectedSSID => _$this._connectedSSID;
  set connectedSSID(String? connectedSSID) =>
      _$this._connectedSSID = connectedSSID;

  ListBuilder<BluetoothDevice>? _scannedDevices;
  ListBuilder<BluetoothDevice> get scannedDevices =>
      _$this._scannedDevices ??= ListBuilder<BluetoothDevice>();
  set scannedDevices(ListBuilder<BluetoothDevice>? scannedDevices) =>
      _$this._scannedDevices = scannedDevices;

  ListBuilder<String>? _wifiNetworks;
  ListBuilder<String> get wifiNetworks =>
      _$this._wifiNetworks ??= ListBuilder<String>();
  set wifiNetworks(ListBuilder<String>? wifiNetworks) =>
      _$this._wifiNetworks = wifiNetworks;

  String? _permissionStatus;
  String? get permissionStatus => _$this._permissionStatus;
  set permissionStatus(String? permissionStatus) =>
      _$this._permissionStatus = permissionStatus;

  bool? _obscurePassword;
  bool? get obscurePassword => _$this._obscurePassword;
  set obscurePassword(bool? obscurePassword) =>
      _$this._obscurePassword = obscurePassword;

  String? _wifiPassword;
  String? get wifiPassword => _$this._wifiPassword;
  set wifiPassword(String? wifiPassword) => _$this._wifiPassword = wifiPassword;

  SocketStateBuilder<Map<String, dynamic>>? _getWifiResponse;
  SocketStateBuilder<Map<String, dynamic>> get getWifiResponse =>
      _$this._getWifiResponse ??= SocketStateBuilder<Map<String, dynamic>>();
  set getWifiResponse(
          SocketStateBuilder<Map<String, dynamic>>? getWifiResponse) =>
      _$this._getWifiResponse = getWifiResponse;

  DeviceOnboardingStateBuilder() {
    DeviceOnboardingState._initialize(this);
  }

  DeviceOnboardingStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isBluetoothConnected = $v.isBluetoothConnected;
      _isDoorbellWifiConnected = $v.isDoorbellWifiConnected;
      _checkDoorbellWifiConnection = $v.checkDoorbellWifiConnection;
      _isWifiConnecting = $v.isWifiConnecting;
      _isBluetoothEnabled = $v.isBluetoothEnabled;
      _isScanning = $v.isScanning;
      _isConnecting = $v.isConnecting;
      _connectedDeviceId = $v.connectedDeviceId;
      _connectedSSID = $v.connectedSSID;
      _scannedDevices = $v.scannedDevices.toBuilder();
      _wifiNetworks = $v.wifiNetworks.toBuilder();
      _permissionStatus = $v.permissionStatus;
      _obscurePassword = $v.obscurePassword;
      _wifiPassword = $v.wifiPassword;
      _getWifiResponse = $v.getWifiResponse.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeviceOnboardingState other) {
    _$v = other as _$DeviceOnboardingState;
  }

  @override
  void update(void Function(DeviceOnboardingStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeviceOnboardingState build() => _build();

  _$DeviceOnboardingState _build() {
    _$DeviceOnboardingState _$result;
    try {
      _$result = _$v ??
          _$DeviceOnboardingState._(
            isBluetoothConnected: BuiltValueNullFieldError.checkNotNull(
                isBluetoothConnected,
                r'DeviceOnboardingState',
                'isBluetoothConnected'),
            isDoorbellWifiConnected: BuiltValueNullFieldError.checkNotNull(
                isDoorbellWifiConnected,
                r'DeviceOnboardingState',
                'isDoorbellWifiConnected'),
            checkDoorbellWifiConnection: BuiltValueNullFieldError.checkNotNull(
                checkDoorbellWifiConnection,
                r'DeviceOnboardingState',
                'checkDoorbellWifiConnection'),
            isWifiConnecting: BuiltValueNullFieldError.checkNotNull(
                isWifiConnecting, r'DeviceOnboardingState', 'isWifiConnecting'),
            isBluetoothEnabled: BuiltValueNullFieldError.checkNotNull(
                isBluetoothEnabled,
                r'DeviceOnboardingState',
                'isBluetoothEnabled'),
            isScanning: BuiltValueNullFieldError.checkNotNull(
                isScanning, r'DeviceOnboardingState', 'isScanning'),
            isConnecting: BuiltValueNullFieldError.checkNotNull(
                isConnecting, r'DeviceOnboardingState', 'isConnecting'),
            connectedDeviceId: connectedDeviceId,
            connectedSSID: connectedSSID,
            scannedDevices: scannedDevices.build(),
            wifiNetworks: wifiNetworks.build(),
            permissionStatus: BuiltValueNullFieldError.checkNotNull(
                permissionStatus, r'DeviceOnboardingState', 'permissionStatus'),
            obscurePassword: BuiltValueNullFieldError.checkNotNull(
                obscurePassword, r'DeviceOnboardingState', 'obscurePassword'),
            wifiPassword: BuiltValueNullFieldError.checkNotNull(
                wifiPassword, r'DeviceOnboardingState', 'wifiPassword'),
            getWifiResponse: getWifiResponse.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scannedDevices';
        scannedDevices.build();
        _$failedField = 'wifiNetworks';
        wifiNetworks.build();

        _$failedField = 'getWifiResponse';
        getWifiResponse.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DeviceOnboardingState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
