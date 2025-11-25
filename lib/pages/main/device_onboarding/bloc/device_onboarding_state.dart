import 'package:admin/models/states/api_state.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'device_onboarding_state.g.dart';

abstract class DeviceOnboardingState
    implements Built<DeviceOnboardingState, DeviceOnboardingStateBuilder> {
  factory DeviceOnboardingState([
    final void Function(DeviceOnboardingStateBuilder) updates,
  ]) = _$DeviceOnboardingState;

  DeviceOnboardingState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final DeviceOnboardingStateBuilder b) => b
    ..isBluetoothConnected = false
    ..isBluetoothEnabled = false
    ..isWifiConnecting = false
    ..isDoorbellWifiConnected = false
    ..checkDoorbellWifiConnection = false
    ..obscurePassword = true
    ..wifiPassword = ""
    ..isScanning = false
    ..isConnecting = false
    ..connectedDeviceId = null
    ..scannedDevices = ListBuilder<BluetoothDevice>()
    ..wifiNetworks = ListBuilder<String>()
    ..permissionStatus = 'denied';

  @BlocUpdateField()
  bool get isBluetoothConnected;

  @BlocUpdateField()
  bool get isDoorbellWifiConnected;

  @BlocUpdateField()
  bool get checkDoorbellWifiConnection;

  @BlocUpdateField()
  bool get isWifiConnecting;

  @BlocUpdateField()
  bool get isBluetoothEnabled;

  @BlocUpdateField()
  bool get isScanning;

  @BlocUpdateField()
  bool get isConnecting;

  @BlocUpdateField()
  String? get connectedDeviceId;

  @BlocUpdateField()
  String? get connectedSSID;

  @BlocUpdateField()
  BuiltList<BluetoothDevice> get scannedDevices;

  @BlocUpdateField()
  BuiltList<String> get wifiNetworks;

  @BlocUpdateField()
  String get permissionStatus;

  @BlocUpdateField()
  bool get obscurePassword;

  @BlocUpdateField()
  String get wifiPassword;

  SocketState<Map<String, dynamic>> get getWifiResponse;
}
