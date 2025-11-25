import 'package:admin/models/data/brand_model.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' as material;
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'iot_state.g.dart';

abstract class IotState implements Built<IotState, IotStateBuilder> {
  factory IotState([
    final void Function(IotStateBuilder) updates,
  ]) = _$IotState;

  IotState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final IotStateBuilder b) => b
    ..iotApi.isApiPaginationEnabled = true
    ..isEnabled = false
    ..manageDevicesGuideShow = false
    ..threeDotMenuGuideShow = false
    ..isAllStatesExecuted = false
    ..canOpenBottomSheetFormOnStreaming = true
    ..viewAllDevicesScreenIsRoom = true
    ..isScanning = false
    ..isDeviceAdded = false
    ..isDeviceAddedResponse = "Device Added Successfully"
    ..roomName = ""
    ..allDevicesWithSubDevices = ""
    ..selectedFormPosition = "Indoor"
    ..selectedIotIndex = 0
    ..getConstantRooms.replace([
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Living Room",
        "type": "living-room",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Bath Room",
        "type": "bath-room",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Kitchen",
        "type": "kitchen",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Garage",
        "type": "garage",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Backyard",
        "type": "backyard",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Store Room",
        "type": "store-room",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Bedroom",
        "type": "bed-room",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Drawing Room",
        "type": "drawing-room",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
      RoomItemsModel.fromDynamic({
        "id": 0,
        "name": "Guest Room",
        "type": "guest-room",
        "color": [material.Colors.white, material.Colors.white],
        "svgColor": material.Colors.grey,
      }),
    ]);

  @BlocUpdateField()
  bool get manageDevicesGuideShow;

  @BlocUpdateField()
  bool get threeDotMenuGuideShow;

  @BlocUpdateField()
  bool get canOpenBottomSheetFormOnStreaming;

  ApiState<void> get iotApi;

  ApiState<void> get curtainAddAPI;

  ApiState<BuiltList<RoomItemsModel>> get getIotRoomsApi;

  SocketState<Map<String, dynamic>> get deleteIotDevice;

  ApiState<void> get deleteCurtainDevice;

  ApiState<void> get editIotDevice;

  ApiState<void> get updateIotDeviceUsageCountApi;

  ApiState<void> get curtainApis;

  ApiState<BuiltList<Brands>> get getIotBrandsApi;

  @BlocUpdateField()
  RoomItemsModel? get selectedFormRoom;

  @BlocUpdateField()
  String? get selectedFormPosition;

  SocketState<Map<String, dynamic>> get getScannerResponse;

  SocketState<Map<String, dynamic>> get getDeviceDetailConfigResponse;

  SocketState<Map<String, dynamic>> get getAllDeviceDetailConfigResponse;

  @BlocUpdateField()
  bool get isAllStatesExecuted;

  @BlocUpdateField()
  bool get viewAllDevicesScreenIsRoom;

  @BlocUpdateField()
  bool get isScanning;

  @BlocUpdateField()
  bool get isDeviceAdded;

  @BlocUpdateField()
  String? get isDeviceAddedResponse;

  // @BlocUpdateField()
  // Map<String, dynamic>? get setDeviceConfigToDevice;

  SocketState<Map<String, dynamic>> get operateIotDeviceResponse;

  SocketState<Map<String, dynamic>> get getDeviceConfigResponse;

  SocketState<Map<String, dynamic>> get createDeviceResponse;

  SocketState<Map<String, dynamic>> get getAllFlowIdResponse;

  SocketState<Map<String, dynamic>> get getDeviceConfigFlowIdResponse;

  SocketState<Map<String, dynamic>> get getAllDevicesWithSubDevices;

  @BlocUpdateField()
  BuiltList<FeatureModel> get scannedDevices;

  // @BlocUpdateField()
  // BuiltList<FeatureModel> get scannedDialogDevices;

  @BlocUpdateField()
  BuiltList<FeatureModel>? get viewDevicesAll;

  ApiState<void> get postIotRoomsApi;

  BuiltList<RoomItemsModel> get getConstantRooms;

  @BlocUpdateField()
  String? get selectedModes;

  bool get isEnabled;

  @BlocUpdateField()
  String get roomName;

  @BlocUpdateField()
  FeatureModel? get formDevice;

  @BlocUpdateField()
  int? get currentFormStep;

  @BlocUpdateField()
  String? get newFormData;

  @BlocUpdateField()
  String? get newFormDataDeviceName;

  int? get index;

  @BlocUpdateField()
  RoomItemsModel? get selectedRoom;

  @BlocUpdateField()
  int get selectedIotIndex;

  @BlocUpdateField()
  BuiltList<IotDeviceModel>? get iotDeviceModel;

  @BlocUpdateField()
  BuiltList<IotDeviceModel>? get inRoomIotDeviceModel;

  @BlocUpdateField()
  String? get allDevicesWithSubDevices;
}
