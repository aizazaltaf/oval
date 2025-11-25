// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IotState extends IotState {
  @override
  final bool manageDevicesGuideShow;
  @override
  final bool threeDotMenuGuideShow;
  @override
  final bool canOpenBottomSheetFormOnStreaming;
  @override
  final ApiState<void> iotApi;
  @override
  final ApiState<void> curtainAddAPI;
  @override
  final ApiState<BuiltList<RoomItemsModel>> getIotRoomsApi;
  @override
  final SocketState<Map<String, dynamic>> deleteIotDevice;
  @override
  final ApiState<void> deleteCurtainDevice;
  @override
  final ApiState<void> editIotDevice;
  @override
  final ApiState<void> updateIotDeviceUsageCountApi;
  @override
  final ApiState<void> curtainApis;
  @override
  final ApiState<BuiltList<Brands>> getIotBrandsApi;
  @override
  final RoomItemsModel? selectedFormRoom;
  @override
  final String? selectedFormPosition;
  @override
  final SocketState<Map<String, dynamic>> getScannerResponse;
  @override
  final SocketState<Map<String, dynamic>> getDeviceDetailConfigResponse;
  @override
  final SocketState<Map<String, dynamic>> getAllDeviceDetailConfigResponse;
  @override
  final bool isAllStatesExecuted;
  @override
  final bool viewAllDevicesScreenIsRoom;
  @override
  final bool isScanning;
  @override
  final bool isDeviceAdded;
  @override
  final String? isDeviceAddedResponse;
  @override
  final SocketState<Map<String, dynamic>> operateIotDeviceResponse;
  @override
  final SocketState<Map<String, dynamic>> getDeviceConfigResponse;
  @override
  final SocketState<Map<String, dynamic>> createDeviceResponse;
  @override
  final SocketState<Map<String, dynamic>> getAllFlowIdResponse;
  @override
  final SocketState<Map<String, dynamic>> getDeviceConfigFlowIdResponse;
  @override
  final SocketState<Map<String, dynamic>> getAllDevicesWithSubDevices;
  @override
  final BuiltList<FeatureModel> scannedDevices;
  @override
  final BuiltList<FeatureModel>? viewDevicesAll;
  @override
  final ApiState<void> postIotRoomsApi;
  @override
  final BuiltList<RoomItemsModel> getConstantRooms;
  @override
  final String? selectedModes;
  @override
  final bool isEnabled;
  @override
  final String roomName;
  @override
  final FeatureModel? formDevice;
  @override
  final int? currentFormStep;
  @override
  final String? newFormData;
  @override
  final String? newFormDataDeviceName;
  @override
  final int? index;
  @override
  final RoomItemsModel? selectedRoom;
  @override
  final int selectedIotIndex;
  @override
  final BuiltList<IotDeviceModel>? iotDeviceModel;
  @override
  final BuiltList<IotDeviceModel>? inRoomIotDeviceModel;
  @override
  final String? allDevicesWithSubDevices;

  factory _$IotState([void Function(IotStateBuilder)? updates]) =>
      (IotStateBuilder()..update(updates))._build();

  _$IotState._(
      {required this.manageDevicesGuideShow,
      required this.threeDotMenuGuideShow,
      required this.canOpenBottomSheetFormOnStreaming,
      required this.iotApi,
      required this.curtainAddAPI,
      required this.getIotRoomsApi,
      required this.deleteIotDevice,
      required this.deleteCurtainDevice,
      required this.editIotDevice,
      required this.updateIotDeviceUsageCountApi,
      required this.curtainApis,
      required this.getIotBrandsApi,
      this.selectedFormRoom,
      this.selectedFormPosition,
      required this.getScannerResponse,
      required this.getDeviceDetailConfigResponse,
      required this.getAllDeviceDetailConfigResponse,
      required this.isAllStatesExecuted,
      required this.viewAllDevicesScreenIsRoom,
      required this.isScanning,
      required this.isDeviceAdded,
      this.isDeviceAddedResponse,
      required this.operateIotDeviceResponse,
      required this.getDeviceConfigResponse,
      required this.createDeviceResponse,
      required this.getAllFlowIdResponse,
      required this.getDeviceConfigFlowIdResponse,
      required this.getAllDevicesWithSubDevices,
      required this.scannedDevices,
      this.viewDevicesAll,
      required this.postIotRoomsApi,
      required this.getConstantRooms,
      this.selectedModes,
      required this.isEnabled,
      required this.roomName,
      this.formDevice,
      this.currentFormStep,
      this.newFormData,
      this.newFormDataDeviceName,
      this.index,
      this.selectedRoom,
      required this.selectedIotIndex,
      this.iotDeviceModel,
      this.inRoomIotDeviceModel,
      this.allDevicesWithSubDevices})
      : super._();
  @override
  IotState rebuild(void Function(IotStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IotStateBuilder toBuilder() => IotStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IotState &&
        manageDevicesGuideShow == other.manageDevicesGuideShow &&
        threeDotMenuGuideShow == other.threeDotMenuGuideShow &&
        canOpenBottomSheetFormOnStreaming ==
            other.canOpenBottomSheetFormOnStreaming &&
        iotApi == other.iotApi &&
        curtainAddAPI == other.curtainAddAPI &&
        getIotRoomsApi == other.getIotRoomsApi &&
        deleteIotDevice == other.deleteIotDevice &&
        deleteCurtainDevice == other.deleteCurtainDevice &&
        editIotDevice == other.editIotDevice &&
        updateIotDeviceUsageCountApi == other.updateIotDeviceUsageCountApi &&
        curtainApis == other.curtainApis &&
        getIotBrandsApi == other.getIotBrandsApi &&
        selectedFormRoom == other.selectedFormRoom &&
        selectedFormPosition == other.selectedFormPosition &&
        getScannerResponse == other.getScannerResponse &&
        getDeviceDetailConfigResponse == other.getDeviceDetailConfigResponse &&
        getAllDeviceDetailConfigResponse ==
            other.getAllDeviceDetailConfigResponse &&
        isAllStatesExecuted == other.isAllStatesExecuted &&
        viewAllDevicesScreenIsRoom == other.viewAllDevicesScreenIsRoom &&
        isScanning == other.isScanning &&
        isDeviceAdded == other.isDeviceAdded &&
        isDeviceAddedResponse == other.isDeviceAddedResponse &&
        operateIotDeviceResponse == other.operateIotDeviceResponse &&
        getDeviceConfigResponse == other.getDeviceConfigResponse &&
        createDeviceResponse == other.createDeviceResponse &&
        getAllFlowIdResponse == other.getAllFlowIdResponse &&
        getDeviceConfigFlowIdResponse == other.getDeviceConfigFlowIdResponse &&
        getAllDevicesWithSubDevices == other.getAllDevicesWithSubDevices &&
        scannedDevices == other.scannedDevices &&
        viewDevicesAll == other.viewDevicesAll &&
        postIotRoomsApi == other.postIotRoomsApi &&
        getConstantRooms == other.getConstantRooms &&
        selectedModes == other.selectedModes &&
        isEnabled == other.isEnabled &&
        roomName == other.roomName &&
        formDevice == other.formDevice &&
        currentFormStep == other.currentFormStep &&
        newFormData == other.newFormData &&
        newFormDataDeviceName == other.newFormDataDeviceName &&
        index == other.index &&
        selectedRoom == other.selectedRoom &&
        selectedIotIndex == other.selectedIotIndex &&
        iotDeviceModel == other.iotDeviceModel &&
        inRoomIotDeviceModel == other.inRoomIotDeviceModel &&
        allDevicesWithSubDevices == other.allDevicesWithSubDevices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, manageDevicesGuideShow.hashCode);
    _$hash = $jc(_$hash, threeDotMenuGuideShow.hashCode);
    _$hash = $jc(_$hash, canOpenBottomSheetFormOnStreaming.hashCode);
    _$hash = $jc(_$hash, iotApi.hashCode);
    _$hash = $jc(_$hash, curtainAddAPI.hashCode);
    _$hash = $jc(_$hash, getIotRoomsApi.hashCode);
    _$hash = $jc(_$hash, deleteIotDevice.hashCode);
    _$hash = $jc(_$hash, deleteCurtainDevice.hashCode);
    _$hash = $jc(_$hash, editIotDevice.hashCode);
    _$hash = $jc(_$hash, updateIotDeviceUsageCountApi.hashCode);
    _$hash = $jc(_$hash, curtainApis.hashCode);
    _$hash = $jc(_$hash, getIotBrandsApi.hashCode);
    _$hash = $jc(_$hash, selectedFormRoom.hashCode);
    _$hash = $jc(_$hash, selectedFormPosition.hashCode);
    _$hash = $jc(_$hash, getScannerResponse.hashCode);
    _$hash = $jc(_$hash, getDeviceDetailConfigResponse.hashCode);
    _$hash = $jc(_$hash, getAllDeviceDetailConfigResponse.hashCode);
    _$hash = $jc(_$hash, isAllStatesExecuted.hashCode);
    _$hash = $jc(_$hash, viewAllDevicesScreenIsRoom.hashCode);
    _$hash = $jc(_$hash, isScanning.hashCode);
    _$hash = $jc(_$hash, isDeviceAdded.hashCode);
    _$hash = $jc(_$hash, isDeviceAddedResponse.hashCode);
    _$hash = $jc(_$hash, operateIotDeviceResponse.hashCode);
    _$hash = $jc(_$hash, getDeviceConfigResponse.hashCode);
    _$hash = $jc(_$hash, createDeviceResponse.hashCode);
    _$hash = $jc(_$hash, getAllFlowIdResponse.hashCode);
    _$hash = $jc(_$hash, getDeviceConfigFlowIdResponse.hashCode);
    _$hash = $jc(_$hash, getAllDevicesWithSubDevices.hashCode);
    _$hash = $jc(_$hash, scannedDevices.hashCode);
    _$hash = $jc(_$hash, viewDevicesAll.hashCode);
    _$hash = $jc(_$hash, postIotRoomsApi.hashCode);
    _$hash = $jc(_$hash, getConstantRooms.hashCode);
    _$hash = $jc(_$hash, selectedModes.hashCode);
    _$hash = $jc(_$hash, isEnabled.hashCode);
    _$hash = $jc(_$hash, roomName.hashCode);
    _$hash = $jc(_$hash, formDevice.hashCode);
    _$hash = $jc(_$hash, currentFormStep.hashCode);
    _$hash = $jc(_$hash, newFormData.hashCode);
    _$hash = $jc(_$hash, newFormDataDeviceName.hashCode);
    _$hash = $jc(_$hash, index.hashCode);
    _$hash = $jc(_$hash, selectedRoom.hashCode);
    _$hash = $jc(_$hash, selectedIotIndex.hashCode);
    _$hash = $jc(_$hash, iotDeviceModel.hashCode);
    _$hash = $jc(_$hash, inRoomIotDeviceModel.hashCode);
    _$hash = $jc(_$hash, allDevicesWithSubDevices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IotState')
          ..add('manageDevicesGuideShow', manageDevicesGuideShow)
          ..add('threeDotMenuGuideShow', threeDotMenuGuideShow)
          ..add('canOpenBottomSheetFormOnStreaming',
              canOpenBottomSheetFormOnStreaming)
          ..add('iotApi', iotApi)
          ..add('curtainAddAPI', curtainAddAPI)
          ..add('getIotRoomsApi', getIotRoomsApi)
          ..add('deleteIotDevice', deleteIotDevice)
          ..add('deleteCurtainDevice', deleteCurtainDevice)
          ..add('editIotDevice', editIotDevice)
          ..add('updateIotDeviceUsageCountApi', updateIotDeviceUsageCountApi)
          ..add('curtainApis', curtainApis)
          ..add('getIotBrandsApi', getIotBrandsApi)
          ..add('selectedFormRoom', selectedFormRoom)
          ..add('selectedFormPosition', selectedFormPosition)
          ..add('getScannerResponse', getScannerResponse)
          ..add('getDeviceDetailConfigResponse', getDeviceDetailConfigResponse)
          ..add('getAllDeviceDetailConfigResponse',
              getAllDeviceDetailConfigResponse)
          ..add('isAllStatesExecuted', isAllStatesExecuted)
          ..add('viewAllDevicesScreenIsRoom', viewAllDevicesScreenIsRoom)
          ..add('isScanning', isScanning)
          ..add('isDeviceAdded', isDeviceAdded)
          ..add('isDeviceAddedResponse', isDeviceAddedResponse)
          ..add('operateIotDeviceResponse', operateIotDeviceResponse)
          ..add('getDeviceConfigResponse', getDeviceConfigResponse)
          ..add('createDeviceResponse', createDeviceResponse)
          ..add('getAllFlowIdResponse', getAllFlowIdResponse)
          ..add('getDeviceConfigFlowIdResponse', getDeviceConfigFlowIdResponse)
          ..add('getAllDevicesWithSubDevices', getAllDevicesWithSubDevices)
          ..add('scannedDevices', scannedDevices)
          ..add('viewDevicesAll', viewDevicesAll)
          ..add('postIotRoomsApi', postIotRoomsApi)
          ..add('getConstantRooms', getConstantRooms)
          ..add('selectedModes', selectedModes)
          ..add('isEnabled', isEnabled)
          ..add('roomName', roomName)
          ..add('formDevice', formDevice)
          ..add('currentFormStep', currentFormStep)
          ..add('newFormData', newFormData)
          ..add('newFormDataDeviceName', newFormDataDeviceName)
          ..add('index', index)
          ..add('selectedRoom', selectedRoom)
          ..add('selectedIotIndex', selectedIotIndex)
          ..add('iotDeviceModel', iotDeviceModel)
          ..add('inRoomIotDeviceModel', inRoomIotDeviceModel)
          ..add('allDevicesWithSubDevices', allDevicesWithSubDevices))
        .toString();
  }
}

class IotStateBuilder implements Builder<IotState, IotStateBuilder> {
  _$IotState? _$v;

  bool? _manageDevicesGuideShow;
  bool? get manageDevicesGuideShow => _$this._manageDevicesGuideShow;
  set manageDevicesGuideShow(bool? manageDevicesGuideShow) =>
      _$this._manageDevicesGuideShow = manageDevicesGuideShow;

  bool? _threeDotMenuGuideShow;
  bool? get threeDotMenuGuideShow => _$this._threeDotMenuGuideShow;
  set threeDotMenuGuideShow(bool? threeDotMenuGuideShow) =>
      _$this._threeDotMenuGuideShow = threeDotMenuGuideShow;

  bool? _canOpenBottomSheetFormOnStreaming;
  bool? get canOpenBottomSheetFormOnStreaming =>
      _$this._canOpenBottomSheetFormOnStreaming;
  set canOpenBottomSheetFormOnStreaming(
          bool? canOpenBottomSheetFormOnStreaming) =>
      _$this._canOpenBottomSheetFormOnStreaming =
          canOpenBottomSheetFormOnStreaming;

  ApiStateBuilder<void>? _iotApi;
  ApiStateBuilder<void> get iotApi =>
      _$this._iotApi ??= ApiStateBuilder<void>();
  set iotApi(ApiStateBuilder<void>? iotApi) => _$this._iotApi = iotApi;

  ApiStateBuilder<void>? _curtainAddAPI;
  ApiStateBuilder<void> get curtainAddAPI =>
      _$this._curtainAddAPI ??= ApiStateBuilder<void>();
  set curtainAddAPI(ApiStateBuilder<void>? curtainAddAPI) =>
      _$this._curtainAddAPI = curtainAddAPI;

  ApiStateBuilder<BuiltList<RoomItemsModel>>? _getIotRoomsApi;
  ApiStateBuilder<BuiltList<RoomItemsModel>> get getIotRoomsApi =>
      _$this._getIotRoomsApi ??= ApiStateBuilder<BuiltList<RoomItemsModel>>();
  set getIotRoomsApi(
          ApiStateBuilder<BuiltList<RoomItemsModel>>? getIotRoomsApi) =>
      _$this._getIotRoomsApi = getIotRoomsApi;

  SocketStateBuilder<Map<String, dynamic>>? _deleteIotDevice;
  SocketStateBuilder<Map<String, dynamic>> get deleteIotDevice =>
      _$this._deleteIotDevice ??= SocketStateBuilder<Map<String, dynamic>>();
  set deleteIotDevice(
          SocketStateBuilder<Map<String, dynamic>>? deleteIotDevice) =>
      _$this._deleteIotDevice = deleteIotDevice;

  ApiStateBuilder<void>? _deleteCurtainDevice;
  ApiStateBuilder<void> get deleteCurtainDevice =>
      _$this._deleteCurtainDevice ??= ApiStateBuilder<void>();
  set deleteCurtainDevice(ApiStateBuilder<void>? deleteCurtainDevice) =>
      _$this._deleteCurtainDevice = deleteCurtainDevice;

  ApiStateBuilder<void>? _editIotDevice;
  ApiStateBuilder<void> get editIotDevice =>
      _$this._editIotDevice ??= ApiStateBuilder<void>();
  set editIotDevice(ApiStateBuilder<void>? editIotDevice) =>
      _$this._editIotDevice = editIotDevice;

  ApiStateBuilder<void>? _updateIotDeviceUsageCountApi;
  ApiStateBuilder<void> get updateIotDeviceUsageCountApi =>
      _$this._updateIotDeviceUsageCountApi ??= ApiStateBuilder<void>();
  set updateIotDeviceUsageCountApi(
          ApiStateBuilder<void>? updateIotDeviceUsageCountApi) =>
      _$this._updateIotDeviceUsageCountApi = updateIotDeviceUsageCountApi;

  ApiStateBuilder<void>? _curtainApis;
  ApiStateBuilder<void> get curtainApis =>
      _$this._curtainApis ??= ApiStateBuilder<void>();
  set curtainApis(ApiStateBuilder<void>? curtainApis) =>
      _$this._curtainApis = curtainApis;

  ApiStateBuilder<BuiltList<Brands>>? _getIotBrandsApi;
  ApiStateBuilder<BuiltList<Brands>> get getIotBrandsApi =>
      _$this._getIotBrandsApi ??= ApiStateBuilder<BuiltList<Brands>>();
  set getIotBrandsApi(ApiStateBuilder<BuiltList<Brands>>? getIotBrandsApi) =>
      _$this._getIotBrandsApi = getIotBrandsApi;

  RoomItemsModelBuilder? _selectedFormRoom;
  RoomItemsModelBuilder get selectedFormRoom =>
      _$this._selectedFormRoom ??= RoomItemsModelBuilder();
  set selectedFormRoom(RoomItemsModelBuilder? selectedFormRoom) =>
      _$this._selectedFormRoom = selectedFormRoom;

  String? _selectedFormPosition;
  String? get selectedFormPosition => _$this._selectedFormPosition;
  set selectedFormPosition(String? selectedFormPosition) =>
      _$this._selectedFormPosition = selectedFormPosition;

  SocketStateBuilder<Map<String, dynamic>>? _getScannerResponse;
  SocketStateBuilder<Map<String, dynamic>> get getScannerResponse =>
      _$this._getScannerResponse ??= SocketStateBuilder<Map<String, dynamic>>();
  set getScannerResponse(
          SocketStateBuilder<Map<String, dynamic>>? getScannerResponse) =>
      _$this._getScannerResponse = getScannerResponse;

  SocketStateBuilder<Map<String, dynamic>>? _getDeviceDetailConfigResponse;
  SocketStateBuilder<Map<String, dynamic>> get getDeviceDetailConfigResponse =>
      _$this._getDeviceDetailConfigResponse ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set getDeviceDetailConfigResponse(
          SocketStateBuilder<Map<String, dynamic>>?
              getDeviceDetailConfigResponse) =>
      _$this._getDeviceDetailConfigResponse = getDeviceDetailConfigResponse;

  SocketStateBuilder<Map<String, dynamic>>? _getAllDeviceDetailConfigResponse;
  SocketStateBuilder<Map<String, dynamic>>
      get getAllDeviceDetailConfigResponse =>
          _$this._getAllDeviceDetailConfigResponse ??=
              SocketStateBuilder<Map<String, dynamic>>();
  set getAllDeviceDetailConfigResponse(
          SocketStateBuilder<Map<String, dynamic>>?
              getAllDeviceDetailConfigResponse) =>
      _$this._getAllDeviceDetailConfigResponse =
          getAllDeviceDetailConfigResponse;

  bool? _isAllStatesExecuted;
  bool? get isAllStatesExecuted => _$this._isAllStatesExecuted;
  set isAllStatesExecuted(bool? isAllStatesExecuted) =>
      _$this._isAllStatesExecuted = isAllStatesExecuted;

  bool? _viewAllDevicesScreenIsRoom;
  bool? get viewAllDevicesScreenIsRoom => _$this._viewAllDevicesScreenIsRoom;
  set viewAllDevicesScreenIsRoom(bool? viewAllDevicesScreenIsRoom) =>
      _$this._viewAllDevicesScreenIsRoom = viewAllDevicesScreenIsRoom;

  bool? _isScanning;
  bool? get isScanning => _$this._isScanning;
  set isScanning(bool? isScanning) => _$this._isScanning = isScanning;

  bool? _isDeviceAdded;
  bool? get isDeviceAdded => _$this._isDeviceAdded;
  set isDeviceAdded(bool? isDeviceAdded) =>
      _$this._isDeviceAdded = isDeviceAdded;

  String? _isDeviceAddedResponse;
  String? get isDeviceAddedResponse => _$this._isDeviceAddedResponse;
  set isDeviceAddedResponse(String? isDeviceAddedResponse) =>
      _$this._isDeviceAddedResponse = isDeviceAddedResponse;

  SocketStateBuilder<Map<String, dynamic>>? _operateIotDeviceResponse;
  SocketStateBuilder<Map<String, dynamic>> get operateIotDeviceResponse =>
      _$this._operateIotDeviceResponse ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set operateIotDeviceResponse(
          SocketStateBuilder<Map<String, dynamic>>? operateIotDeviceResponse) =>
      _$this._operateIotDeviceResponse = operateIotDeviceResponse;

  SocketStateBuilder<Map<String, dynamic>>? _getDeviceConfigResponse;
  SocketStateBuilder<Map<String, dynamic>> get getDeviceConfigResponse =>
      _$this._getDeviceConfigResponse ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set getDeviceConfigResponse(
          SocketStateBuilder<Map<String, dynamic>>? getDeviceConfigResponse) =>
      _$this._getDeviceConfigResponse = getDeviceConfigResponse;

  SocketStateBuilder<Map<String, dynamic>>? _createDeviceResponse;
  SocketStateBuilder<Map<String, dynamic>> get createDeviceResponse =>
      _$this._createDeviceResponse ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set createDeviceResponse(
          SocketStateBuilder<Map<String, dynamic>>? createDeviceResponse) =>
      _$this._createDeviceResponse = createDeviceResponse;

  SocketStateBuilder<Map<String, dynamic>>? _getAllFlowIdResponse;
  SocketStateBuilder<Map<String, dynamic>> get getAllFlowIdResponse =>
      _$this._getAllFlowIdResponse ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set getAllFlowIdResponse(
          SocketStateBuilder<Map<String, dynamic>>? getAllFlowIdResponse) =>
      _$this._getAllFlowIdResponse = getAllFlowIdResponse;

  SocketStateBuilder<Map<String, dynamic>>? _getDeviceConfigFlowIdResponse;
  SocketStateBuilder<Map<String, dynamic>> get getDeviceConfigFlowIdResponse =>
      _$this._getDeviceConfigFlowIdResponse ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set getDeviceConfigFlowIdResponse(
          SocketStateBuilder<Map<String, dynamic>>?
              getDeviceConfigFlowIdResponse) =>
      _$this._getDeviceConfigFlowIdResponse = getDeviceConfigFlowIdResponse;

  SocketStateBuilder<Map<String, dynamic>>? _getAllDevicesWithSubDevices;
  SocketStateBuilder<Map<String, dynamic>> get getAllDevicesWithSubDevices =>
      _$this._getAllDevicesWithSubDevices ??=
          SocketStateBuilder<Map<String, dynamic>>();
  set getAllDevicesWithSubDevices(
          SocketStateBuilder<Map<String, dynamic>>?
              getAllDevicesWithSubDevices) =>
      _$this._getAllDevicesWithSubDevices = getAllDevicesWithSubDevices;

  ListBuilder<FeatureModel>? _scannedDevices;
  ListBuilder<FeatureModel> get scannedDevices =>
      _$this._scannedDevices ??= ListBuilder<FeatureModel>();
  set scannedDevices(ListBuilder<FeatureModel>? scannedDevices) =>
      _$this._scannedDevices = scannedDevices;

  ListBuilder<FeatureModel>? _viewDevicesAll;
  ListBuilder<FeatureModel> get viewDevicesAll =>
      _$this._viewDevicesAll ??= ListBuilder<FeatureModel>();
  set viewDevicesAll(ListBuilder<FeatureModel>? viewDevicesAll) =>
      _$this._viewDevicesAll = viewDevicesAll;

  ApiStateBuilder<void>? _postIotRoomsApi;
  ApiStateBuilder<void> get postIotRoomsApi =>
      _$this._postIotRoomsApi ??= ApiStateBuilder<void>();
  set postIotRoomsApi(ApiStateBuilder<void>? postIotRoomsApi) =>
      _$this._postIotRoomsApi = postIotRoomsApi;

  ListBuilder<RoomItemsModel>? _getConstantRooms;
  ListBuilder<RoomItemsModel> get getConstantRooms =>
      _$this._getConstantRooms ??= ListBuilder<RoomItemsModel>();
  set getConstantRooms(ListBuilder<RoomItemsModel>? getConstantRooms) =>
      _$this._getConstantRooms = getConstantRooms;

  String? _selectedModes;
  String? get selectedModes => _$this._selectedModes;
  set selectedModes(String? selectedModes) =>
      _$this._selectedModes = selectedModes;

  bool? _isEnabled;
  bool? get isEnabled => _$this._isEnabled;
  set isEnabled(bool? isEnabled) => _$this._isEnabled = isEnabled;

  String? _roomName;
  String? get roomName => _$this._roomName;
  set roomName(String? roomName) => _$this._roomName = roomName;

  FeatureModel? _formDevice;
  FeatureModel? get formDevice => _$this._formDevice;
  set formDevice(FeatureModel? formDevice) => _$this._formDevice = formDevice;

  int? _currentFormStep;
  int? get currentFormStep => _$this._currentFormStep;
  set currentFormStep(int? currentFormStep) =>
      _$this._currentFormStep = currentFormStep;

  String? _newFormData;
  String? get newFormData => _$this._newFormData;
  set newFormData(String? newFormData) => _$this._newFormData = newFormData;

  String? _newFormDataDeviceName;
  String? get newFormDataDeviceName => _$this._newFormDataDeviceName;
  set newFormDataDeviceName(String? newFormDataDeviceName) =>
      _$this._newFormDataDeviceName = newFormDataDeviceName;

  int? _index;
  int? get index => _$this._index;
  set index(int? index) => _$this._index = index;

  RoomItemsModelBuilder? _selectedRoom;
  RoomItemsModelBuilder get selectedRoom =>
      _$this._selectedRoom ??= RoomItemsModelBuilder();
  set selectedRoom(RoomItemsModelBuilder? selectedRoom) =>
      _$this._selectedRoom = selectedRoom;

  int? _selectedIotIndex;
  int? get selectedIotIndex => _$this._selectedIotIndex;
  set selectedIotIndex(int? selectedIotIndex) =>
      _$this._selectedIotIndex = selectedIotIndex;

  ListBuilder<IotDeviceModel>? _iotDeviceModel;
  ListBuilder<IotDeviceModel> get iotDeviceModel =>
      _$this._iotDeviceModel ??= ListBuilder<IotDeviceModel>();
  set iotDeviceModel(ListBuilder<IotDeviceModel>? iotDeviceModel) =>
      _$this._iotDeviceModel = iotDeviceModel;

  ListBuilder<IotDeviceModel>? _inRoomIotDeviceModel;
  ListBuilder<IotDeviceModel> get inRoomIotDeviceModel =>
      _$this._inRoomIotDeviceModel ??= ListBuilder<IotDeviceModel>();
  set inRoomIotDeviceModel(ListBuilder<IotDeviceModel>? inRoomIotDeviceModel) =>
      _$this._inRoomIotDeviceModel = inRoomIotDeviceModel;

  String? _allDevicesWithSubDevices;
  String? get allDevicesWithSubDevices => _$this._allDevicesWithSubDevices;
  set allDevicesWithSubDevices(String? allDevicesWithSubDevices) =>
      _$this._allDevicesWithSubDevices = allDevicesWithSubDevices;

  IotStateBuilder() {
    IotState._initialize(this);
  }

  IotStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _manageDevicesGuideShow = $v.manageDevicesGuideShow;
      _threeDotMenuGuideShow = $v.threeDotMenuGuideShow;
      _canOpenBottomSheetFormOnStreaming = $v.canOpenBottomSheetFormOnStreaming;
      _iotApi = $v.iotApi.toBuilder();
      _curtainAddAPI = $v.curtainAddAPI.toBuilder();
      _getIotRoomsApi = $v.getIotRoomsApi.toBuilder();
      _deleteIotDevice = $v.deleteIotDevice.toBuilder();
      _deleteCurtainDevice = $v.deleteCurtainDevice.toBuilder();
      _editIotDevice = $v.editIotDevice.toBuilder();
      _updateIotDeviceUsageCountApi =
          $v.updateIotDeviceUsageCountApi.toBuilder();
      _curtainApis = $v.curtainApis.toBuilder();
      _getIotBrandsApi = $v.getIotBrandsApi.toBuilder();
      _selectedFormRoom = $v.selectedFormRoom?.toBuilder();
      _selectedFormPosition = $v.selectedFormPosition;
      _getScannerResponse = $v.getScannerResponse.toBuilder();
      _getDeviceDetailConfigResponse =
          $v.getDeviceDetailConfigResponse.toBuilder();
      _getAllDeviceDetailConfigResponse =
          $v.getAllDeviceDetailConfigResponse.toBuilder();
      _isAllStatesExecuted = $v.isAllStatesExecuted;
      _viewAllDevicesScreenIsRoom = $v.viewAllDevicesScreenIsRoom;
      _isScanning = $v.isScanning;
      _isDeviceAdded = $v.isDeviceAdded;
      _isDeviceAddedResponse = $v.isDeviceAddedResponse;
      _operateIotDeviceResponse = $v.operateIotDeviceResponse.toBuilder();
      _getDeviceConfigResponse = $v.getDeviceConfigResponse.toBuilder();
      _createDeviceResponse = $v.createDeviceResponse.toBuilder();
      _getAllFlowIdResponse = $v.getAllFlowIdResponse.toBuilder();
      _getDeviceConfigFlowIdResponse =
          $v.getDeviceConfigFlowIdResponse.toBuilder();
      _getAllDevicesWithSubDevices = $v.getAllDevicesWithSubDevices.toBuilder();
      _scannedDevices = $v.scannedDevices.toBuilder();
      _viewDevicesAll = $v.viewDevicesAll?.toBuilder();
      _postIotRoomsApi = $v.postIotRoomsApi.toBuilder();
      _getConstantRooms = $v.getConstantRooms.toBuilder();
      _selectedModes = $v.selectedModes;
      _isEnabled = $v.isEnabled;
      _roomName = $v.roomName;
      _formDevice = $v.formDevice;
      _currentFormStep = $v.currentFormStep;
      _newFormData = $v.newFormData;
      _newFormDataDeviceName = $v.newFormDataDeviceName;
      _index = $v.index;
      _selectedRoom = $v.selectedRoom?.toBuilder();
      _selectedIotIndex = $v.selectedIotIndex;
      _iotDeviceModel = $v.iotDeviceModel?.toBuilder();
      _inRoomIotDeviceModel = $v.inRoomIotDeviceModel?.toBuilder();
      _allDevicesWithSubDevices = $v.allDevicesWithSubDevices;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IotState other) {
    _$v = other as _$IotState;
  }

  @override
  void update(void Function(IotStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IotState build() => _build();

  _$IotState _build() {
    _$IotState _$result;
    try {
      _$result = _$v ??
          _$IotState._(
            manageDevicesGuideShow: BuiltValueNullFieldError.checkNotNull(
                manageDevicesGuideShow, r'IotState', 'manageDevicesGuideShow'),
            threeDotMenuGuideShow: BuiltValueNullFieldError.checkNotNull(
                threeDotMenuGuideShow, r'IotState', 'threeDotMenuGuideShow'),
            canOpenBottomSheetFormOnStreaming:
                BuiltValueNullFieldError.checkNotNull(
                    canOpenBottomSheetFormOnStreaming,
                    r'IotState',
                    'canOpenBottomSheetFormOnStreaming'),
            iotApi: iotApi.build(),
            curtainAddAPI: curtainAddAPI.build(),
            getIotRoomsApi: getIotRoomsApi.build(),
            deleteIotDevice: deleteIotDevice.build(),
            deleteCurtainDevice: deleteCurtainDevice.build(),
            editIotDevice: editIotDevice.build(),
            updateIotDeviceUsageCountApi: updateIotDeviceUsageCountApi.build(),
            curtainApis: curtainApis.build(),
            getIotBrandsApi: getIotBrandsApi.build(),
            selectedFormRoom: _selectedFormRoom?.build(),
            selectedFormPosition: selectedFormPosition,
            getScannerResponse: getScannerResponse.build(),
            getDeviceDetailConfigResponse:
                getDeviceDetailConfigResponse.build(),
            getAllDeviceDetailConfigResponse:
                getAllDeviceDetailConfigResponse.build(),
            isAllStatesExecuted: BuiltValueNullFieldError.checkNotNull(
                isAllStatesExecuted, r'IotState', 'isAllStatesExecuted'),
            viewAllDevicesScreenIsRoom: BuiltValueNullFieldError.checkNotNull(
                viewAllDevicesScreenIsRoom,
                r'IotState',
                'viewAllDevicesScreenIsRoom'),
            isScanning: BuiltValueNullFieldError.checkNotNull(
                isScanning, r'IotState', 'isScanning'),
            isDeviceAdded: BuiltValueNullFieldError.checkNotNull(
                isDeviceAdded, r'IotState', 'isDeviceAdded'),
            isDeviceAddedResponse: isDeviceAddedResponse,
            operateIotDeviceResponse: operateIotDeviceResponse.build(),
            getDeviceConfigResponse: getDeviceConfigResponse.build(),
            createDeviceResponse: createDeviceResponse.build(),
            getAllFlowIdResponse: getAllFlowIdResponse.build(),
            getDeviceConfigFlowIdResponse:
                getDeviceConfigFlowIdResponse.build(),
            getAllDevicesWithSubDevices: getAllDevicesWithSubDevices.build(),
            scannedDevices: scannedDevices.build(),
            viewDevicesAll: _viewDevicesAll?.build(),
            postIotRoomsApi: postIotRoomsApi.build(),
            getConstantRooms: getConstantRooms.build(),
            selectedModes: selectedModes,
            isEnabled: BuiltValueNullFieldError.checkNotNull(
                isEnabled, r'IotState', 'isEnabled'),
            roomName: BuiltValueNullFieldError.checkNotNull(
                roomName, r'IotState', 'roomName'),
            formDevice: formDevice,
            currentFormStep: currentFormStep,
            newFormData: newFormData,
            newFormDataDeviceName: newFormDataDeviceName,
            index: index,
            selectedRoom: _selectedRoom?.build(),
            selectedIotIndex: BuiltValueNullFieldError.checkNotNull(
                selectedIotIndex, r'IotState', 'selectedIotIndex'),
            iotDeviceModel: _iotDeviceModel?.build(),
            inRoomIotDeviceModel: _inRoomIotDeviceModel?.build(),
            allDevicesWithSubDevices: allDevicesWithSubDevices,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'iotApi';
        iotApi.build();
        _$failedField = 'curtainAddAPI';
        curtainAddAPI.build();
        _$failedField = 'getIotRoomsApi';
        getIotRoomsApi.build();
        _$failedField = 'deleteIotDevice';
        deleteIotDevice.build();
        _$failedField = 'deleteCurtainDevice';
        deleteCurtainDevice.build();
        _$failedField = 'editIotDevice';
        editIotDevice.build();
        _$failedField = 'updateIotDeviceUsageCountApi';
        updateIotDeviceUsageCountApi.build();
        _$failedField = 'curtainApis';
        curtainApis.build();
        _$failedField = 'getIotBrandsApi';
        getIotBrandsApi.build();
        _$failedField = 'selectedFormRoom';
        _selectedFormRoom?.build();

        _$failedField = 'getScannerResponse';
        getScannerResponse.build();
        _$failedField = 'getDeviceDetailConfigResponse';
        getDeviceDetailConfigResponse.build();
        _$failedField = 'getAllDeviceDetailConfigResponse';
        getAllDeviceDetailConfigResponse.build();

        _$failedField = 'operateIotDeviceResponse';
        operateIotDeviceResponse.build();
        _$failedField = 'getDeviceConfigResponse';
        getDeviceConfigResponse.build();
        _$failedField = 'createDeviceResponse';
        createDeviceResponse.build();
        _$failedField = 'getAllFlowIdResponse';
        getAllFlowIdResponse.build();
        _$failedField = 'getDeviceConfigFlowIdResponse';
        getDeviceConfigFlowIdResponse.build();
        _$failedField = 'getAllDevicesWithSubDevices';
        getAllDevicesWithSubDevices.build();
        _$failedField = 'scannedDevices';
        scannedDevices.build();
        _$failedField = 'viewDevicesAll';
        _viewDevicesAll?.build();
        _$failedField = 'postIotRoomsApi';
        postIotRoomsApi.build();
        _$failedField = 'getConstantRooms';
        getConstantRooms.build();

        _$failedField = 'selectedRoom';
        _selectedRoom?.build();

        _$failedField = 'iotDeviceModel';
        _iotDeviceModel?.build();
        _$failedField = 'inRoomIotDeviceModel';
        _inRoomIotDeviceModel?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IotState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
