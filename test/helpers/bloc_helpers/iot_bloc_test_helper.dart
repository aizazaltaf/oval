import 'dart:async';

import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/brand_model.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_state.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';

class IotBlocTestHelper {
  late MockIotBloc mockIotBloc;
  late IotState currentIotState;

  void setup() {
    mockIotBloc = MockIotBloc();
    currentIotState = MockIotState();

    when(() => mockIotBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockIotBloc.state).thenReturn(currentIotState);

    // Setup default state properties
    setupDefaultState();
  }

  void setupDefaultState() {
    // Stub all required IotState properties
    when(() => currentIotState.manageDevicesGuideShow).thenReturn(false);
    when(() => currentIotState.threeDotMenuGuideShow).thenReturn(false);
    when(() => currentIotState.iotApi).thenReturn(ApiState<void>());
    when(() => currentIotState.curtainAddAPI).thenReturn(ApiState<void>());
    when(() => currentIotState.getIotRoomsApi)
        .thenReturn(ApiState<BuiltList<RoomItemsModel>>());
    when(() => currentIotState.deleteIotDevice)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.deleteCurtainDevice)
        .thenReturn(ApiState<void>());
    when(() => currentIotState.editIotDevice).thenReturn(ApiState<void>());
    when(() => currentIotState.updateIotDeviceUsageCountApi)
        .thenReturn(ApiState<void>());
    when(() => currentIotState.curtainApis).thenReturn(ApiState<void>());
    when(() => currentIotState.getIotBrandsApi)
        .thenReturn(ApiState<BuiltList<Brands>>());
    when(() => currentIotState.selectedFormRoom).thenReturn(null);
    when(() => currentIotState.getScannerResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.getDeviceDetailConfigResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.getAllDeviceDetailConfigResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.operateIotDeviceResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.getDeviceConfigResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.createDeviceResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.getAllFlowIdResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.getDeviceConfigFlowIdResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.scannedDevices)
        .thenReturn(BuiltList<FeatureModel>([]));
    when(() => currentIotState.postIotRoomsApi).thenReturn(ApiState<void>());
    when(() => currentIotState.getConstantRooms)
        .thenReturn(BuiltList<RoomItemsModel>([]));
    when(() => currentIotState.selectedModes).thenReturn(null);
    when(() => currentIotState.isEnabled).thenReturn(false);
    when(() => currentIotState.roomName).thenReturn("");
    when(() => currentIotState.formDevice).thenReturn(null);
    when(() => currentIotState.newFormData).thenReturn(null);
    when(() => currentIotState.newFormDataDeviceName).thenReturn(null);
    when(() => currentIotState.index).thenReturn(null);
    when(() => currentIotState.selectedRoom).thenReturn(null);
    when(() => currentIotState.selectedIotIndex).thenReturn(0);
    when(() => currentIotState.iotDeviceModel)
        .thenReturn(BuiltList<IotDeviceModel>([]));
    when(() => currentIotState.inRoomIotDeviceModel)
        .thenReturn(BuiltList<IotDeviceModel>([]));
    when(() => currentIotState.getAllDevicesWithSubDevices)
        .thenReturn(SocketState<Map<String, dynamic>>());
    when(() => currentIotState.selectedFormPosition)
        .thenReturn("Indoor");
  }

  void setupWithDevices() {
    // Setup state with some IoT devices that will pass the filtering
    // The entityId should not be a camera, thermostat, hub, or switchbot
    final mockDevice = IotDeviceModel(
      (b) => b
        ..id = 1
        ..deviceName = "Test Light Bulb"
        ..entityId = "light.living_room_light"
        ..roomId = 1
        ..locationId = 1
        ..stateAvailable = 1
        ..usageCount = 5,
    );

    when(() => currentIotState.iotDeviceModel)
        .thenReturn(BuiltList([mockDevice]));
    when(() => currentIotState.inRoomIotDeviceModel)
        .thenReturn(BuiltList([mockDevice]));
  }

  void setupWithDevicesDifferentLocation() {
    // Setup state with IoT devices that have a different locationId
    // This will not pass the filtering in CommonFunctions.getIotFilteredList
    final mockDevice = IotDeviceModel(
      (b) => b
        ..id = 1
        ..deviceName = "Test Light Bulb"
        ..entityId = "light.living_room_light"
        ..roomId = 1
        ..locationId = 2  // Different from selected doorbell locationId (1)
        ..stateAvailable = 1
        ..usageCount = 5,
    );

    when(() => currentIotState.iotDeviceModel)
        .thenReturn(BuiltList([mockDevice]));
    when(() => currentIotState.inRoomIotDeviceModel)
        .thenReturn(BuiltList([mockDevice]));
  }

  void setupWithEmptyDevices() {
    // Setup state with empty IoT devices list
    // This will ensure no devices pass filtering
    when(() => currentIotState.iotDeviceModel)
        .thenReturn(BuiltList<IotDeviceModel>([]));
    when(() => currentIotState.inRoomIotDeviceModel)
        .thenReturn(BuiltList<IotDeviceModel>([]));
  }

  void setupWithRooms() {
    // Setup state with some rooms
    final mockRoom = RoomItemsModel(
      (b) => b
        ..roomId = 1
        ..roomName = "Test Room"
        ..selectedValue = false,
    );

    when(() => currentIotState.getIotRoomsApi.data)
        .thenReturn(BuiltList([mockRoom]));
    when(() => currentIotState.getConstantRooms)
        .thenReturn(BuiltList([mockRoom]));
  }

  void setupWithBrands() {
    // Setup state with some brands
    final mockBrand = Brands(
      (b) => b
        ..id = 1
        ..brand = "test_brand"
        ..type = "bulb"
        ..companyName = "Test Company"
        ..isActive = 1
        ..isSelected = false,
    );

    when(() => currentIotState.getIotBrandsApi.data)
        .thenReturn(BuiltList([mockBrand]));
  }

  void setupWithScannedDevices() {
    // Setup state with scanned devices
    final mockScannedDevice = FeatureModel(
      title: "Test Device",
      value: "test_mac",
      brand: "Test Brand",
      image: "test_icon",
    );

    when(() => currentIotState.scannedDevices)
        .thenReturn(BuiltList([mockScannedDevice]));
  }

  void setupLoadingState() {
    // Setup loading state
    when(() => currentIotState.iotApi.isApiInProgress).thenReturn(true);
    when(() => currentIotState.getIotRoomsApi.isApiInProgress).thenReturn(true);
    when(() => currentIotState.getIotBrandsApi.isApiInProgress)
        .thenReturn(true);
  }

  void setupErrorState() {
    // Setup error state
    final mockError = ApiMetaData(
      (b) => b
        ..message = "Test error"
        ..statusCode = 400,
    );
    when(() => currentIotState.iotApi.error).thenReturn(mockError);
  }

  void dispose() {
    // No stream controller to dispose
  }
}
