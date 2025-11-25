// ignore_for_file: type=lint, unused_element

part of 'iot_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class IotBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<IotState>? buildWhen;
  final BlocWidgetBuilder<IotState> builder;

  const IotBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<IotBloc, IotState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class IotBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<IotState, T> selector;
  final Widget Function(T state) builder;
  final IotBloc? bloc;

  const IotBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static IotBlocSelector<bool> manageDevicesGuideShow({
    final Key? key,
    required Widget Function(bool manageDevicesGuideShow) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.manageDevicesGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> threeDotMenuGuideShow({
    final Key? key,
    required Widget Function(bool threeDotMenuGuideShow) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.threeDotMenuGuideShow,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> canOpenBottomSheetFormOnStreaming({
    final Key? key,
    required Widget Function(bool canOpenBottomSheetFormOnStreaming) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.canOpenBottomSheetFormOnStreaming,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> iotApi({
    final Key? key,
    required Widget Function(ApiState<void> iotApi) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.iotApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> curtainAddAPI({
    final Key? key,
    required Widget Function(ApiState<void> curtainAddAPI) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.curtainAddAPI,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<BuiltList<RoomItemsModel>>> getIotRoomsApi({
    final Key? key,
    required Widget Function(ApiState<BuiltList<RoomItemsModel>> getIotRoomsApi)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getIotRoomsApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>> deleteIotDevice({
    final Key? key,
    required Widget Function(SocketState<Map<String, dynamic>> deleteIotDevice)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.deleteIotDevice,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> deleteCurtainDevice({
    final Key? key,
    required Widget Function(ApiState<void> deleteCurtainDevice) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.deleteCurtainDevice,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> editIotDevice({
    final Key? key,
    required Widget Function(ApiState<void> editIotDevice) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.editIotDevice,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> updateIotDeviceUsageCountApi({
    final Key? key,
    required Widget Function(ApiState<void> updateIotDeviceUsageCountApi)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.updateIotDeviceUsageCountApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> curtainApis({
    final Key? key,
    required Widget Function(ApiState<void> curtainApis) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.curtainApis,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<BuiltList<Brands>>> getIotBrandsApi({
    final Key? key,
    required Widget Function(ApiState<BuiltList<Brands>> getIotBrandsApi)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getIotBrandsApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<RoomItemsModel?> selectedFormRoom({
    final Key? key,
    required Widget Function(RoomItemsModel? selectedFormRoom) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.selectedFormRoom,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String?> selectedFormPosition({
    final Key? key,
    required Widget Function(String? selectedFormPosition) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.selectedFormPosition,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>> getScannerResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getScannerResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getScannerResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      getDeviceDetailConfigResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getDeviceDetailConfigResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getDeviceDetailConfigResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      getAllDeviceDetailConfigResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getAllDeviceDetailConfigResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getAllDeviceDetailConfigResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> isAllStatesExecuted({
    final Key? key,
    required Widget Function(bool isAllStatesExecuted) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.isAllStatesExecuted,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> viewAllDevicesScreenIsRoom({
    final Key? key,
    required Widget Function(bool viewAllDevicesScreenIsRoom) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.viewAllDevicesScreenIsRoom,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> isScanning({
    final Key? key,
    required Widget Function(bool isScanning) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.isScanning,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> isDeviceAdded({
    final Key? key,
    required Widget Function(bool isDeviceAdded) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.isDeviceAdded,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String?> isDeviceAddedResponse({
    final Key? key,
    required Widget Function(String? isDeviceAddedResponse) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.isDeviceAddedResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      operateIotDeviceResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> operateIotDeviceResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.operateIotDeviceResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      getDeviceConfigResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getDeviceConfigResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getDeviceConfigResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      createDeviceResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> createDeviceResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.createDeviceResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      getAllFlowIdResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getAllFlowIdResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getAllFlowIdResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      getDeviceConfigFlowIdResponse({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getDeviceConfigFlowIdResponse)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getDeviceConfigFlowIdResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<SocketState<Map<String, dynamic>>>
      getAllDevicesWithSubDevices({
    final Key? key,
    required Widget Function(
            SocketState<Map<String, dynamic>> getAllDevicesWithSubDevices)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getAllDevicesWithSubDevices,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<BuiltList<FeatureModel>> scannedDevices({
    final Key? key,
    required Widget Function(BuiltList<FeatureModel> scannedDevices) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.scannedDevices,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<BuiltList<FeatureModel>?> viewDevicesAll({
    final Key? key,
    required Widget Function(BuiltList<FeatureModel>? viewDevicesAll) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.viewDevicesAll,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<ApiState<void>> postIotRoomsApi({
    final Key? key,
    required Widget Function(ApiState<void> postIotRoomsApi) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.postIotRoomsApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<BuiltList<RoomItemsModel>> getConstantRooms({
    final Key? key,
    required Widget Function(BuiltList<RoomItemsModel> getConstantRooms)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.getConstantRooms,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String?> selectedModes({
    final Key? key,
    required Widget Function(String? selectedModes) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.selectedModes,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<bool> isEnabled({
    final Key? key,
    required Widget Function(bool isEnabled) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.isEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String> roomName({
    final Key? key,
    required Widget Function(String roomName) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.roomName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<FeatureModel?> formDevice({
    final Key? key,
    required Widget Function(FeatureModel? formDevice) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.formDevice,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<int?> currentFormStep({
    final Key? key,
    required Widget Function(int? currentFormStep) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.currentFormStep,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String?> newFormData({
    final Key? key,
    required Widget Function(String? newFormData) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.newFormData,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String?> newFormDataDeviceName({
    final Key? key,
    required Widget Function(String? newFormDataDeviceName) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.newFormDataDeviceName,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<int?> index({
    final Key? key,
    required Widget Function(int? index) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.index,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<RoomItemsModel?> selectedRoom({
    final Key? key,
    required Widget Function(RoomItemsModel? selectedRoom) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.selectedRoom,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<int> selectedIotIndex({
    final Key? key,
    required Widget Function(int selectedIotIndex) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.selectedIotIndex,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<BuiltList<IotDeviceModel>?> iotDeviceModel({
    final Key? key,
    required Widget Function(BuiltList<IotDeviceModel>? iotDeviceModel) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.iotDeviceModel,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<BuiltList<IotDeviceModel>?> inRoomIotDeviceModel({
    final Key? key,
    required Widget Function(BuiltList<IotDeviceModel>? inRoomIotDeviceModel)
        builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.inRoomIotDeviceModel,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static IotBlocSelector<String?> allDevicesWithSubDevices({
    final Key? key,
    required Widget Function(String? allDevicesWithSubDevices) builder,
    final IotBloc? bloc,
  }) {
    return IotBlocSelector(
      key: key,
      selector: (state) => state.allDevicesWithSubDevices,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<IotBloc, IotState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _IotBlocMixin on Cubit<IotState> {
  @mustCallSuper
  void updateManageDevicesGuideShow(final bool manageDevicesGuideShow) {
    if (this.state.manageDevicesGuideShow == manageDevicesGuideShow) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.manageDevicesGuideShow = manageDevicesGuideShow));

    $onUpdateManageDevicesGuideShow();
  }

  @protected
  void $onUpdateManageDevicesGuideShow() {}

  @mustCallSuper
  void updateThreeDotMenuGuideShow(final bool threeDotMenuGuideShow) {
    if (this.state.threeDotMenuGuideShow == threeDotMenuGuideShow) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.threeDotMenuGuideShow = threeDotMenuGuideShow));

    $onUpdateThreeDotMenuGuideShow();
  }

  @protected
  void $onUpdateThreeDotMenuGuideShow() {}

  @mustCallSuper
  void updateCanOpenBottomSheetFormOnStreaming(
      final bool canOpenBottomSheetFormOnStreaming) {
    if (this.state.canOpenBottomSheetFormOnStreaming ==
        canOpenBottomSheetFormOnStreaming) {
      return;
    }

    emit(this.state.rebuild((final b) => b.canOpenBottomSheetFormOnStreaming =
        canOpenBottomSheetFormOnStreaming));

    $onUpdateCanOpenBottomSheetFormOnStreaming();
  }

  @protected
  void $onUpdateCanOpenBottomSheetFormOnStreaming() {}

  @mustCallSuper
  void updateSelectedFormRoom(final RoomItemsModel? selectedFormRoom) {
    if (this.state.selectedFormRoom == selectedFormRoom) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (selectedFormRoom == null)
        b.selectedFormRoom = null;
      else
        b.selectedFormRoom.replace(selectedFormRoom);
    }));

    $onUpdateSelectedFormRoom();
  }

  @protected
  void $onUpdateSelectedFormRoom() {}

  @mustCallSuper
  void updateSelectedFormPosition(final String? selectedFormPosition) {
    if (this.state.selectedFormPosition == selectedFormPosition) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.selectedFormPosition = selectedFormPosition));

    $onUpdateSelectedFormPosition();
  }

  @protected
  void $onUpdateSelectedFormPosition() {}

  @mustCallSuper
  void updateIsAllStatesExecuted(final bool isAllStatesExecuted) {
    if (this.state.isAllStatesExecuted == isAllStatesExecuted) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isAllStatesExecuted = isAllStatesExecuted));

    $onUpdateIsAllStatesExecuted();
  }

  @protected
  void $onUpdateIsAllStatesExecuted() {}

  @mustCallSuper
  void updateViewAllDevicesScreenIsRoom(final bool viewAllDevicesScreenIsRoom) {
    if (this.state.viewAllDevicesScreenIsRoom == viewAllDevicesScreenIsRoom) {
      return;
    }

    emit(this.state.rebuild((final b) =>
        b.viewAllDevicesScreenIsRoom = viewAllDevicesScreenIsRoom));

    $onUpdateViewAllDevicesScreenIsRoom();
  }

  @protected
  void $onUpdateViewAllDevicesScreenIsRoom() {}

  @mustCallSuper
  void updateIsScanning(final bool isScanning) {
    if (this.state.isScanning == isScanning) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isScanning = isScanning));

    $onUpdateIsScanning();
  }

  @protected
  void $onUpdateIsScanning() {}

  @mustCallSuper
  void updateIsDeviceAdded(final bool isDeviceAdded) {
    if (this.state.isDeviceAdded == isDeviceAdded) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isDeviceAdded = isDeviceAdded));

    $onUpdateIsDeviceAdded();
  }

  @protected
  void $onUpdateIsDeviceAdded() {}

  @mustCallSuper
  void updateIsDeviceAddedResponse(final String? isDeviceAddedResponse) {
    if (this.state.isDeviceAddedResponse == isDeviceAddedResponse) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isDeviceAddedResponse = isDeviceAddedResponse));

    $onUpdateIsDeviceAddedResponse();
  }

  @protected
  void $onUpdateIsDeviceAddedResponse() {}

  @mustCallSuper
  void updateScannedDevices(final BuiltList<FeatureModel> scannedDevices) {
    if (this.state.scannedDevices == scannedDevices) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.scannedDevices.replace(scannedDevices);
    }));

    $onUpdateScannedDevices();
  }

  @protected
  void $onUpdateScannedDevices() {}

  @mustCallSuper
  void updateViewDevicesAll(final BuiltList<FeatureModel>? viewDevicesAll) {
    if (this.state.viewDevicesAll == viewDevicesAll) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (viewDevicesAll == null)
        b.viewDevicesAll = null;
      else
        b.viewDevicesAll.replace(viewDevicesAll);
    }));

    $onUpdateViewDevicesAll();
  }

  @protected
  void $onUpdateViewDevicesAll() {}

  @mustCallSuper
  void updateSelectedModes(final String? selectedModes) {
    if (this.state.selectedModes == selectedModes) {
      return;
    }

    emit(this.state.rebuild((final b) => b.selectedModes = selectedModes));

    $onUpdateSelectedModes();
  }

  @protected
  void $onUpdateSelectedModes() {}

  @mustCallSuper
  void updateRoomName(final String roomName) {
    if (this.state.roomName == roomName) {
      return;
    }

    emit(this.state.rebuild((final b) => b.roomName = roomName));

    $onUpdateRoomName();
  }

  @protected
  void $onUpdateRoomName() {}

  @mustCallSuper
  void updateFormDevice(final FeatureModel? formDevice) {
    if (this.state.formDevice == formDevice) {
      return;
    }

    emit(this.state.rebuild((final b) => b.formDevice = formDevice));

    $onUpdateFormDevice();
  }

  @protected
  void $onUpdateFormDevice() {}

  @mustCallSuper
  void updateCurrentFormStep(final int? currentFormStep) {
    if (this.state.currentFormStep == currentFormStep) {
      return;
    }

    emit(this.state.rebuild((final b) => b.currentFormStep = currentFormStep));

    $onUpdateCurrentFormStep();
  }

  @protected
  void $onUpdateCurrentFormStep() {}

  @mustCallSuper
  void updateNewFormData(final String? newFormData) {
    if (this.state.newFormData == newFormData) {
      return;
    }

    emit(this.state.rebuild((final b) => b.newFormData = newFormData));

    $onUpdateNewFormData();
  }

  @protected
  void $onUpdateNewFormData() {}

  @mustCallSuper
  void updateNewFormDataDeviceName(final String? newFormDataDeviceName) {
    if (this.state.newFormDataDeviceName == newFormDataDeviceName) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.newFormDataDeviceName = newFormDataDeviceName));

    $onUpdateNewFormDataDeviceName();
  }

  @protected
  void $onUpdateNewFormDataDeviceName() {}

  @mustCallSuper
  void updateSelectedRoom(final RoomItemsModel? selectedRoom) {
    if (this.state.selectedRoom == selectedRoom) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (selectedRoom == null)
        b.selectedRoom = null;
      else
        b.selectedRoom.replace(selectedRoom);
    }));

    $onUpdateSelectedRoom();
  }

  @protected
  void $onUpdateSelectedRoom() {}

  @mustCallSuper
  void updateSelectedIotIndex(final int selectedIotIndex) {
    if (this.state.selectedIotIndex == selectedIotIndex) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.selectedIotIndex = selectedIotIndex));

    $onUpdateSelectedIotIndex();
  }

  @protected
  void $onUpdateSelectedIotIndex() {}

  @mustCallSuper
  void updateIotDeviceModel(final BuiltList<IotDeviceModel>? iotDeviceModel) {
    if (this.state.iotDeviceModel == iotDeviceModel) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (iotDeviceModel == null)
        b.iotDeviceModel = null;
      else
        b.iotDeviceModel.replace(iotDeviceModel);
    }));

    $onUpdateIotDeviceModel();
  }

  @protected
  void $onUpdateIotDeviceModel() {}

  @mustCallSuper
  void updateInRoomIotDeviceModel(
      final BuiltList<IotDeviceModel>? inRoomIotDeviceModel) {
    if (this.state.inRoomIotDeviceModel == inRoomIotDeviceModel) {
      return;
    }

    emit(this.state.rebuild((final b) {
      if (inRoomIotDeviceModel == null)
        b.inRoomIotDeviceModel = null;
      else
        b.inRoomIotDeviceModel.replace(inRoomIotDeviceModel);
    }));

    $onUpdateInRoomIotDeviceModel();
  }

  @protected
  void $onUpdateInRoomIotDeviceModel() {}

  @mustCallSuper
  void updateAllDevicesWithSubDevices(final String? allDevicesWithSubDevices) {
    if (this.state.allDevicesWithSubDevices == allDevicesWithSubDevices) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.allDevicesWithSubDevices = allDevicesWithSubDevices));

    $onUpdateAllDevicesWithSubDevices();
  }

  @protected
  void $onUpdateAllDevicesWithSubDevices() {}
}
