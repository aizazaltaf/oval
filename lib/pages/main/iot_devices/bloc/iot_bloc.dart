import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/core/config.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/extensions/string.dart';
import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/brand_model.dart';
import 'package:admin/models/data/curtain_model_without_serializer.dart';
import 'package:admin/models/data/room_items_model.dart';
import 'package:admin/models/enums/environment.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/dashboard/view_model/feature_model.dart';
import 'package:admin/pages/main/iot_devices/add_device_form.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_state.dart';
import 'package:admin/pages/main/iot_devices/model/iot_device_model.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'iot_bloc.bloc.g.dart';

final _logger = Logger("IotBloc.dart");

@BlocGen()
class IotBloc extends BVCubit<IotState, IotStateBuilder> with _IotBlocMixin {
  IotBloc() : super(IotState()) {
    // if (singletonBloc.profileBloc.state?.selectedDoorBell != null) {
    //   iotInitializer();
    // } else {
    //   Future.delayed(const Duration(seconds: 2), iotInitializer);
    // }
  }

  factory IotBloc.of(final BuildContext context) =>
      BlocProvider.of<IotBloc>(context);

  Future<void> iotInitializer() async {
    unawaited(callIotRoomsApi(needLoaderDismiss: false));
    await callIotApi(needLoaderDismiss: false);
    await socketListener();
    await callIotBrandsApi(needLoaderDismiss: false);
  }

  final ScrollController scrollController = ScrollController();

  final addRoomGuideKey = GlobalKey();
  final thermostatGuideKey = GlobalKey();
  final addDeviceGuideKey = GlobalKey();
  final recentDevicesGuideKey = GlobalKey();
  Timer? _debounceTimerOperateDevice;
  Timer? _debounceTimersForThermostat;

  @override
  void $onUpdateSelectedRoom() {
    final List<IotDeviceModel> list = [
      ...?state.iotDeviceModel?.where(
        (item) =>
            item.roomId == state.selectedRoom?.roomId &&
            !item.entityId!.isCamera() &&
            singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
                    .toString() ==
                item.locationId.toString() &&
            !item.entityId!.isHub(),
      ),
    ];
    updateSelectedIotIndex(0);
    updateInRoomIotDeviceModel(list.toBuiltList());
  }

  @override
  void updateScannedDevices(final BuiltList<FeatureModel> scannedDevices) {
    emit(
      state.rebuild((final b) {
        b.scannedDevices.replace(scannedDevices);
      }),
    );
    $onUpdateScannedDevices();
    super.updateScannedDevices(scannedDevices);
  }

  Future<void> callIotApi({bool clear = true, bool needLoaderDismiss = true}) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.iotApi,
      dismissLoaderOnApiFail: needLoaderDismiss,
      updateApiState: (final b, final apiState) => b.iotApi.replace(apiState),
      onError: (e) {
        _logger.severe(e.toString());
      },
      callApi: () async {
        if (clear) {
          emit(
            state.rebuild((final b) {
              b.iotDeviceModel.replace([]);
              singletonBloc.profileBloc.canPinned(false);
            }),
          );
        }
        final list = await apiService.getIotDevices();
        if (list.isNotEmpty) {
          final verifiedList = list
              .where(
                (x) =>
                    singletonBloc
                        .profileBloc.state!.selectedDoorBell?.locationId
                        .toString() ==
                    x.locationId.toString(),
              )
              .toList();

          emit(state.rebuild((b) => b.iotDeviceModel.replace(verifiedList)));

          withDebounceUpdateWhenDeviceUnreachable();
          updateViewAllDevicesScreenIsRoom(!state.viewAllDevicesScreenIsRoom);
          updateViewAllDevicesScreenIsRoom(!state.viewAllDevicesScreenIsRoom);
          if (list.isNotEmpty) {
            singletonBloc.profileBloc.canPinned(true);
          }
        }
      },
    );
  }

  @override
  void updateSelectedRoom(final RoomItemsModel? selectedRoom) {
    emit(
      state.rebuild((final b) {
        if (selectedRoom == null) {
          b.selectedRoom = null;
        } else {
          b.selectedRoom.replace(selectedRoom);
        }
      }),
    );
    $onUpdateSelectedRoom();

    super.updateSelectedRoom(selectedRoom);
  }

  Future<void> getAllStateDevicesWithSubDevices() async {
    await CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.getAllDevicesWithSubDevices,
      updateApiState: (b, apiState) =>
          b.getAllDevicesWithSubDevices.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: Constants.getAllHomeassistantGroupedDevices,
      data: {},
      onSuccess: (data) {
        updateAllDevicesWithSubDevices(data["data"]);
      },
      onError: (date) {},
    );
  }

  Future<void> getDeviceConfigurations(entityId, uuid) async {
    await CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.getDeviceDetailConfigResponse,
      updateApiState: (b, apiState) =>
          b.getDeviceDetailConfigResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: Constants.getDeviceDetailById,
      data: {"entity_id": entityId, "username": uuid, "password": uuid},
      onSuccess: (data) {
        _logger.fine(
          "Device Detail Config getDeviceConfigurations success: $data",
        );
      },
      onError: (error) {
        _logger.severe(
          "Error Device Detail Config Devices for entity getDeviceConfigurations $entityId: $error",
        );
      },
    );
  }

  Completer<Map<String, dynamic>?>? _deviceConfigCompleter;

  Future<Map<String, dynamic>?> getAllDeviceConfigurations() async {
    if (_deviceConfigCompleter?.isCompleted != false) {
      _deviceConfigCompleter = Completer<Map<String, dynamic>?>();
    }

    unawaited(
      CubitUtils.makeSocketCall<IotState, IotStateBuilder,
          Map<String, dynamic>>(
        cubit: this,
        apiState: state.getAllDeviceDetailConfigResponse,
        updateApiState: (b, apiState) =>
            b.getAllDeviceDetailConfigResponse.replace(apiState),
        socket: singletonBloc.socket!,
        eventName: Constants.iot,
        responseEvent: Constants.iot,
        command: Constants.allIotDevicesState,
        onSuccess: (data) {
          _logger.fine("Device Detail Config success: $data");

          if (data["status"] ?? false) {
            try {
              final parsedData = jsonDecode(data["data"]);
              if (!(_deviceConfigCompleter?.isCompleted ?? false)) {
                getAllStateDevicesWithSubDevices();
                _deviceConfigCompleter?.complete(parsedData);
              }
            } catch (e) {
              _logger.severe("Failed to parse device config data: $e");
              if (!(_deviceConfigCompleter?.isCompleted ?? false)) {
                _deviceConfigCompleter?.complete({});
              }
            }
          } else {
            _logger.warning("Device config status false");
            if (!(_deviceConfigCompleter?.isCompleted ?? false)) {
              _deviceConfigCompleter?.complete({});
            }
          }
        },
        onError: (error) {
          _logger.severe("Error Device Detail Config: $error");
          if (!(_deviceConfigCompleter?.isCompleted ?? false)) {
            if (!(_deviceConfigCompleter?.isCompleted ?? false)) {
              _deviceConfigCompleter?.complete({});
            }
          }
        },
      ),
    );

    return _deviceConfigCompleter!.future;
  }

  void updateSelectedValue(bool value, int index, BuildContext context) {
    emit(
      state.rebuild(
        (b) => b
          ..getConstantRooms = ListBuilder(
            state.getConstantRooms
                .asList()
                .asMap()
                .map(
                  (i, room) => MapEntry(
                    i,
                    room.rebuild(
                      (a) => a..selectedValue = (i == index && value),
                    ),
                  ),
                )
                .values
                .toList(),
          )
          ..isEnabled = value
          ..index = index
          ..postIotRoomsApi.replace(ApiState()),
      ),
    );
  }

  BuiltList<IotDeviceModel>? stateOfInRoomIotDeviceModel;
  BuiltList<IotDeviceModel>? stateOfIotDeviceModel;

  void updateDeviceStateWhenInternetDisconnected() {
    stateOfInRoomIotDeviceModel = state.inRoomIotDeviceModel;
    stateOfIotDeviceModel = state.iotDeviceModel;
    emit(
      state.rebuild((b) {
        final list = b.iotDeviceModel.build().toList().map(
              (e) => e.rebuild((b) => b.stateAvailable = 3),
            );

        b.iotDeviceModel.replace(BuiltList<IotDeviceModel>(list));

        final updatedList = b.inRoomIotDeviceModel.build().toList().map(
              (e) => e.rebuild((b) => b.stateAvailable = 3),
            );
        b.inRoomIotDeviceModel.replace(BuiltList<IotDeviceModel>(updatedList));
      }),
    );
    stateManipulation();
  }

  void stateManipulation() {
    if (state.inRoomIotDeviceModel != null) {
      if (state.inRoomIotDeviceModel!.isNotEmpty) {
        if (state.inRoomIotDeviceModel?[state.selectedIotIndex].entityId
                ?.split(".")
                .first ==
            Constants.curtain) {
          final a = state.selectedIotIndex;
          updateSelectedIotIndex(0);
          Future.delayed(const Duration(milliseconds: 100), () {
            updateSelectedIotIndex(a);
          });
        } else {
          updateSelectedIotIndex(state.selectedIotIndex);
        }
      }
    }
  }

  void updateDeviceStateWhenInternetConnected() {
    emit(
      state.rebuild((b) {
        b.iotDeviceModel.replace(stateOfIotDeviceModel!);
        b.inRoomIotDeviceModel.replace(stateOfInRoomIotDeviceModel!);
      }),
    );

    stateManipulation();
  }

  Future<void> updateIotDeviceUsageCount(int id) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.updateIotDeviceUsageCountApi,
      updateApiState: (final b, final apiState) =>
          b.updateIotDeviceUsageCountApi.replace(apiState),
      callApi: () async {
        final bool status = await apiService.updateIotDeviceUsageCount(id);
        if (status) {
          emit(
            state.rebuild((b) {
              final list = b.iotDeviceModel.build().toList();
              final index = list.indexWhere((data) => data.id == id);
              if (index != -1) {
                final updatedDevice = list[index].rebuild((device) {
                  device.usageCount = device.usageCount! + 1;
                });

                list[index] = updatedDevice;
                b.iotDeviceModel.replace(BuiltList<IotDeviceModel>(list));
              }

              final updatedList = b.inRoomIotDeviceModel.build().toList();

              if (b.selectedIotIndex != null) {
                updatedList[b.selectedIotIndex!] =
                    updatedList[b.selectedIotIndex!].rebuild(
                  (d) => d.usageCount = d.usageCount! + 1,
                );

                b.inRoomIotDeviceModel.replace(updatedList);
              }
            }),
          );
        }
      },
    );
  }

  Future<void> callIotRoomsApi({bool needLoaderDismiss = true}) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder,
        BuiltList<RoomItemsModel>>(
      cubit: this,
      dismissLoaderOnApiFail: needLoaderDismiss,
      apiState: state.getIotRoomsApi,
      updateApiState: (final b, final apiState) =>
          b.getIotRoomsApi.replace(apiState),
      callApi: () async {
        return apiService.getAllRooms();
      },
    );
  }

  Future<void> deleteIotDevice(
    int id,
    String entityId,
    Function onSuccess,
  ) async {
    await CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.deleteIotDevice,
      updateApiState: (b, apiState) => b.deleteIotDevice.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: Constants.deleteDevice,
      data: {
        "entity_id": entityId,
        "brand": "",
        "iot_device_id": id,
        "is_iot": true,
      },
      onSuccess: (data) async {
        _logger.fine("Deleted success: $data");
        if (data['status']) {
          onSuccess.call();
          ToastUtils.successToast("Device Successfully Deleted");
        } else {
          ToastUtils.errorToast("Sorry!, Unable to delete the device");
        }
      },
      onError: (error) {
        _logger.severe("Error Scan Devices: $error");
      },
    );
  }

  Future<void> editIotDevice(
    int id,
    name,
    entityId,
    roomId,
    Function onSuccess, {
    bool camera = false,
  }) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.editIotDevice,
      updateApiState: (final b, final apiState) =>
          b.editIotDevice.replace(apiState),
      callApi: () async {
        if (await apiService.editIotDevice(id, name, entityId, roomId)) {
          if (!camera) {
            emit(
              state.rebuild((b) {
                final list = b.iotDeviceModel.build().toList();
                final index = list.indexWhere(
                  (data) => data.entityId == entityId,
                );
                if (index != -1) {
                  final updatedDevice = list[index].rebuild((device) {
                    device
                      ..deviceName = name
                      ..roomId = roomId
                      ..room.replace(
                        state.getIotRoomsApi.data!.firstWhere(
                          (e) => e.roomId == roomId,
                        ),
                      );
                  });

                  list[index] = updatedDevice;
                  b.iotDeviceModel.replace(BuiltList<IotDeviceModel>(list));
                }

                final updatedList = b.inRoomIotDeviceModel.build().toList();

                if (b.selectedIotIndex != null) {
                  updatedList[b.selectedIotIndex!] =
                      updatedList[b.selectedIotIndex!].rebuild(
                    (d) => d
                      ..deviceName = name
                      ..roomId = roomId
                      ..room.replace(
                        state.getIotRoomsApi.data!.firstWhere(
                          (e) => e.roomId == roomId,
                        ),
                      ),
                  );

                  b.inRoomIotDeviceModel.replace(updatedList);
                }
              }),
            );
          }
          await onSuccess.call();
        }
      },
    );
  }

  Future<void> editRoom(RoomItemsModel room, name, Function onSuccess) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.editIotDevice,
      updateApiState: (final b, final apiState) =>
          b.editIotDevice.replace(apiState),
      callApi: () async {
        final Response response = await apiService.editRoomName(name, room);
        if (response.statusCode == 200) {
          await callIotRoomsApi();
          emit(
            state.rebuild(
              (e) => e.selectedRoom.replace(
                state.getIotRoomsApi.data!.firstWhere(
                  (e) => e.roomId == state.selectedRoom!.roomId,
                ),
              ),
            ),
          );
          onSuccess.call();
        } else {
          ToastUtils.errorToast(response.data["data"]);
        }
      },
      onError: (data) {
        if (data is DioException) {
          ToastUtils.errorToast("${data.response?.data["message"] ?? ""}");
        }
      },
    );
  }

  Future<void> deleteRoom(RoomItemsModel room, Function onSuccess) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.editIotDevice,
      updateApiState: (final b, final apiState) =>
          b.editIotDevice.replace(apiState),
      callApi: () async {
        if (await apiService.deleteRoom(room)) {
          await callIotRoomsApi();
          await callIotApi();
          onSuccess.call(true);
        }
      },
      onError: (e) async {
        onSuccess.call(false);
        if (e is DioException) {
          if ((e.response?.data?["message"] ?? "").toString().isNotEmpty) {
            ToastUtils.errorToast(
              (e.response?.data?["message"] ?? "").toString(),
            );
          }
        }
        // await callIotRoomsApi();
        // await callIotApi();
      },
    );
  }

  Future<void> callIotBrandsApi({bool needLoaderDismiss = true}) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, BuiltList<Brands>>(
      cubit: this,
      apiState: state.getIotBrandsApi,
      dismissLoaderOnApiFail: needLoaderDismiss,
      updateApiState: (final b, final apiState) =>
          b.getIotBrandsApi.replace(apiState),
      callApi: () async {
        return await apiService.getAllBrands();
      },
    );
  }

  Future<void> scanDevices() async {
    updateScannedDevices(<FeatureModel>[].toBuiltList());
    updateIsScanning(true);
    final isSwitchbotExist = (state.iotDeviceModel?.toList() ?? []).any(
      (element) => element.entityId?.isSwitchBot() ?? false,
    );
    final isRingExist = isRing();
    final isEzvizExist = isEzviz();

    dynamic switchbotDevice;
    if (isSwitchbotExist) {
      final switchbot = (state.iotDeviceModel?.toList() ?? []).firstWhere(
        (element) => element.entityId?.isSwitchBot() ?? false,
      );
      final data = jsonDecode(switchbot.details?["extra_param"] ?? "{}");
      switchbotDevice = await getSwitchBotDevices(
        data?['api_token'],
        data?['api_key'],
        switchbot.roomId,
        data?['ip_address'],
      );
    }
    await CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.getScannerResponse,
      updateApiState: (b, apiState) => b.getScannerResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: Constants.scanDevices,
      timeout: const Duration(minutes: 2),
      onSuccess: (data) async {
        _logger
          ..fine("Scan Devices success: $data")
          ..fine("Scan Devices success: $switchbotDevice");
        if (data["status"] ?? false) {
          final devices = jsonDecode(data['data']);
          final List<FeatureModel> list = [];

          for (final device in (devices ?? [])) {
            if (device['brand'] != null) {
              if ((isSwitchbotExist &&
                      device['brand'].toString().isSwitchBot()) ||
                  (isRingExist && device['brand'].toString().isRing()) ||
                  (isEzvizExist && device['brand'].toString().isEzviz())) {
                continue;
              } else {
                list.add(
                  FeatureModel(
                    title: device['ip'],
                    value: device['mac_address_base_16'],
                    brand: device['brand'],
                    image: getIcon(device["type"]),
                  ),
                );
              }
            }
          }

          if (isSwitchbotExist && switchbotDevice is! String) {
            final switchBotList = state.iotDeviceModel!
                .where((e) => e.entityId!.isSwitchBot())
                .toList();
            final addNewDevices = switchbotDevice['devices'].where((device) {
              return !switchBotList.any(
                (item) => item.entityId == device["entity_id"],
              );
            }).toList();
            if ((addNewDevices ?? []).isNotEmpty) {
              addNewDevices.forEach((e) {
                final data = jsonDecode(e['extra_param']);
                list.add(
                  FeatureModel(
                    title: e['ip_address'] ?? "No Ip",
                    value: e["entity_id"],
                    brand: "switchbot ${e['name']}",
                    name: e['name'],
                    image: getIcon("switchbot"),
                    token: data['api_token'],
                    key: data['api_key'],
                    roomId: e["room_id"],
                    host: e["ip_address"],
                  ),
                );
              });
            }
          }

          /// Usage
          final existingDevices =
              state.iotDeviceModel ?? <IotDeviceModel>[].toBuiltList();

          // final existingDevices = state.iotDeviceModel ?? BuiltList<IotDeviceModel>();

          final filteredScannedDevices = list
              .where(
                (scannedDevice) => isNewDevice(scannedDevice, existingDevices),
              )
              .toList()
              .toBuiltList();

          updateScannedDevices(filteredScannedDevices);
          // updateScannedDialogDevices(filteredScannedDevices);
          updateIsScanning(false);
        } else {
          ifSocketResponseStatusFalse(data);
          updateIsScanning(false);
        }
      },
      onError: (error) {
        _logger.severe("Error Scan Devices: $error");
      },
    );
  }

  /// Helper to normalize strings
  String normalize(String? value) => value?.trim().toLowerCase() ?? "";

  /// Returns true if the scanned device does NOT exist in the existing devices
  bool isNewDevice(
    FeatureModel scannedDevice,
    BuiltList<IotDeviceModel> existingDevices,
  ) {
    final scannedMac = normalize(scannedDevice.value);
    final scannedIp = normalize(scannedDevice.title);
    // Keep device only if no existing device has the same MAC or IP
    return existingDevices.every((iotDevice) {
      final mac = normalize(iotDevice.details?["mac_address"].toString());
      final ip = normalize(iotDevice.details?["ip_address"].toString());

      // Duplicate if either MAC or IP matches
      final isDuplicate =
          (scannedMac.isNotEmpty && mac == scannedMac) || ip == scannedIp;
      _logger.severe("$scannedIp $scannedMac $isDuplicate");

      return !isDuplicate; // true if this iotDevice does NOT match
    });
  }

  void updateBrightness(value) {
    if (state.inRoomIotDeviceModel![state.selectedIotIndex].stateAvailable !=
        3) {
      emit(
        state.rebuild((b) {
          final updatedList = b.inRoomIotDeviceModel.build().toList();

          if (b.selectedIotIndex != null) {
            updatedList[b.selectedIotIndex!] = updatedList[b.selectedIotIndex!]
                .rebuild((d) => d.brightness = value);

            b.inRoomIotDeviceModel.replace(updatedList);
          }
        }),
      );
    }
  }

  void onTapScannedDevices(
    List<FeatureModel> viewDevices,
    int i,
    BuildContext context, {
    bool fromMoreScannedDevices = false,
  }) {
    if (!state.getDeviceConfigResponse.isSocketInProgress &&
        state.scannedDevices.any((e) => e.value == viewDevices[i].value)) {
      if (state.getIotRoomsApi.data != null) {
        if (state.getIotRoomsApi.data!.isNotEmpty &&
            state.scannedDevices.any((e) => e.value == viewDevices[i].value)) {
          if (viewDevices[i].value.toString().isSwitchBot() &&
              viewDevices[i].token != null) {
            final updatedDevice = state.scannedDevices
                .firstWhere((e) => e.value == viewDevices[i].value)
                .copyWith(isSelected: true);
            emit(
              state.rebuild(
                (b) => b
                  ..scannedDevices[state.scannedDevices.indexWhere(
                    (e) => e.value == viewDevices[i].value,
                  )] = updatedDevice,
              ),
            );
            getAndAddDeviceSwitchBot(
              token: viewDevices[i].token!,
              key: viewDevices[i].key!,
              host: viewDevices[i].host,
              roomId: viewDevices[i].roomId,
              onSuccess: () {
                callIotApi();
                Navigator.pop(context);
              },
              entityId: viewDevices[i].value,
              name: viewDevices[i].name,
            );
          } else {
            getDeviceConfig(
              data: {
                Constants.brand: viewDevices[i].brand,
                Constants.host: viewDevices[i].title,
              },
              indexScannedDevice: state.scannedDevices.indexWhere(
                (e) => e.value == viewDevices[i].value,
              ),
              success: () {
                final mainData = jsonDecode(
                  state.newFormData ??
                      state.getDeviceConfigResponse.data!["data"],
                );
                final List<dynamic> schema = mainData["data_schema"] is String
                    ? jsonDecode(mainData["data_schema"])
                    : mainData["data_schema"];
                if (schema.isEmpty) {
                  ToastUtils.errorToast(
                    context.appLocalizations.already_configured,
                  );
                } else {
                  AddDeviceForm.push(
                    context,
                    fromAddManually: fromMoreScannedDevices,
                  );
                }
              },
            );
          }
        } else {
          ToastUtils.warningToast(context.appLocalizations.create_room_first);
        }
      } else {
        ToastUtils.warningToast(context.appLocalizations.create_room_first);
      }
    }
  }

  void updateDeviceTemperature(String entityId, String newTemp) {
    emit(
      state.rebuild((b) {
        final list = b.iotDeviceModel.build().toList();
        final index = list.indexWhere((data) => data.entityId == entityId);
        if (index != -1) {
          list[index] = list[index].rebuild((device) {
            device.temperature = newTemp;
          });

          b.iotDeviceModel = BuiltList<IotDeviceModel>(list).toBuilder();
        }
      }),
    );
    emit(
      state.rebuild((b) {
        final updatedList = b.inRoomIotDeviceModel.build().toList();

        if (b.selectedIotIndex != null) {
          updatedList[b.selectedIotIndex!] =
              updatedList[b.selectedIotIndex!].rebuild((d) {
            d.temperature = newTemp;
          });

          b.inRoomIotDeviceModel.replace(updatedList);
        }
      }),
    );

    operateIotDevice(
      entityId,
      Constants.setTemperature,
      otherValues: {"entity_id": entityId, "temperature": newTemp},
    );
  }

  Future<void> operateIotDevice(
    String? entityId,
    service, {
    Map<String, dynamic>? otherValues,
    int brightness = 255,
    bool fromOutsideRoom = false,
    bool fromControls = false,
    String? entityIdForControls,
  }) async {
    _debounceTimerOperateDevice?.cancel();

    _debounceTimerOperateDevice = Timer(const Duration(seconds: 1), () async {
      await CubitUtils.makeSocketCall<IotState, IotStateBuilder,
          Map<String, dynamic>>(
        cubit: this,
        apiState: state.operateIotDeviceResponse,
        updateApiState: (b, apiState) =>
            b.operateIotDeviceResponse.replace(apiState),
        socket: singletonBloc.socket!,
        eventName: Constants.iot,
        responseEvent: Constants.iot,
        command: Constants.operateIotDevice,
        // timeout: const Duration(seconds: 15),
        data: otherValues != null
            ? {
                "service": service,
                "entity_id": entityId,
                "othervalues": otherValues,
              }
            : {
                "service": service,
                "entity_id": entityId,
                if (service == Constants.turnOn)
                  "othervalues": {"brightness": "255"},
              },
        onSuccess: (data) async {
          _logger.fine("Operate Iot Devices success: $data");
          if (!(data["status"] ?? false)) {
            ToastUtils.warningToast(data["data"]);
          } else {
            if (data['data'] != null) {
              if ((jsonDecode(data['data'])['success']) ?? false) {
                if (fromControls) {
                  final List<dynamic> decodedJson = jsonDecode(
                    state.allDevicesWithSubDevices!,
                  );

                  if (entityIdForControls != null) {
                    // Find the device with matching entity_id
                    final Map<String, dynamic>? matchedDevice =
                        decodedJson.firstWhereOrNull(
                      (e) => e['entity_id'] == entityIdForControls,
                    );

                    if (matchedDevice != null) {
                      // Get the list of sub-device entities
                      final List<dynamic>? subDeviceEntities =
                          matchedDevice['entities'];

                      // Update state on the matched sub-entity
                      if (subDeviceEntities != null) {
                        for (final subEntity in subDeviceEntities) {
                          if (subEntity['entity_id'] == entityId) {
                            subEntity['state'] = otherValues != null
                                ? otherValues['value']
                                : service.toString().split('/')[1] ==
                                        Constants.turnOnSimple
                                    ? 'on'
                                    : 'off';
                            break; // Assuming unique entity_id within entities, break after found
                          }
                        }
                      }
                    }

                    // After modification, encode the whole devices list back to JSON string
                    final String updatedJsonString = jsonEncode(decodedJson);

                    // Now update your state with the updated JSON string
                    updateAllDevicesWithSubDevices(updatedJsonString);
                  }
                  // unawaited(EasyLoading.dismiss());
                  Constants.dismissLoader();
                }
                emit(
                  state.rebuild((b) {
                    final list = b.iotDeviceModel.build().toList();
                    final index = list.indexWhere(
                      (data) => data.entityId == entityId,
                    );
                    if (index != -1) {
                      unawaited(updateIotDeviceUsageCount(list[index].id));

                      list[index] = list[index].rebuild((device) {
                        device.stateAvailable =
                            service == Constants.turnOn ? 1 : 2;

                        if (entityId!.isBulb()) {
                          // if (service == Constants.turnOn) {
                          device.brightness = service == Constants.turnOn
                              ? otherValues != null
                                  ? otherValues["brightness"] != null
                                      ? double.tryParse(
                                          otherValues["brightness"].toString(),
                                        )
                                      : device.brightness
                                  : brightness.toDouble()
                              : device.brightness;
                          if (otherValues?["effect"] != null) {
                            final json = jsonDecode(
                              device.configuration ?? "{}",
                            )["a"];
                            json['effect'] = otherValues?["effect"];
                            final Map newConfig = {};
                            newConfig["a"] = json;
                            device.configuration = jsonEncode(newConfig);
                          }
                          // }
                        } else if (entityId.isThermostat()) {
                          device
                            ..temperature = otherValues?["temperature"] != null
                                ? otherValues!["temperature"].toString()
                                : device.temperature.toString()
                            ..mode = otherValues?["hvac_mode"] ?? device.mode
                            ..presetMode =
                                otherValues?["preset_mode"] ?? device.presetMode
                            ..fanMode =
                                otherValues?["fan_mode"] ?? device.fanMode;
                          // withDebounceUpdateWhenDeviceUnreachable(
                          //   fromOutsideRoom: fromOutsideRoom,
                          //   entityId: entityId,
                          // );
                        } else if (entityId.isLock()) {
                          device.stateAvailable =
                              (service == Constants.lock) ? 1 : 2;
                        }
                      });

                      b.iotDeviceModel = BuiltList<IotDeviceModel>(
                        list,
                      ).toBuilder();
                    }
                  }),
                );
                if (!fromOutsideRoom) {
                  emit(
                    state.rebuild((b) {
                      final updatedList =
                          b.inRoomIotDeviceModel.build().toList();

                      if (b.selectedIotIndex != null) {
                        if (b.selectedIotIndex! <= updatedList.length - 1) {
                          updatedList[b.selectedIotIndex!] =
                              updatedList[b.selectedIotIndex!].rebuild((d) {
                            d.stateAvailable =
                                service == Constants.turnOn ? 1 : 2;
                            if (entityId!.isBulb()) {
                              // if (service == Constants.turnOn) {
                              d.brightness = service == Constants.turnOn
                                  ? otherValues != null
                                      ? otherValues["brightness"] != null
                                          ? double.tryParse(
                                              otherValues["brightness"]
                                                  .toString(),
                                            )
                                          : d.brightness
                                      : brightness.toDouble()
                                  : d.brightness;
                              if (otherValues?["effect"] != null) {
                                final json = jsonDecode(
                                  d.configuration ?? "{}",
                                )["a"];
                                json['effect'] = otherValues?["effect"];
                                final Map newConfig = {};
                                newConfig["a"] = json;
                                d.configuration = jsonEncode(newConfig);
                              }
                              // }
                            } else if (entityId.isThermostat()) {
                              d
                                ..temperature = (otherValues?["temperature"] ??
                                        d.temperature)
                                    .toString()
                                ..mode = otherValues?["hvac_mode"] ?? d.mode
                                ..presetMode =
                                    otherValues?["preset_mode"] ?? d.presetMode
                                ..fanMode =
                                    otherValues?["fan_mode"] ?? d.fanMode;
                            } else if (entityId.isLock()) {
                              d.stateAvailable =
                                  (service == Constants.lock) ? 1 : 2;
                            }
                          });

                          b.inRoomIotDeviceModel.replace(updatedList);
                        }
                      }
                    }),
                  );
                }
              } else {
                withDebounceUpdateWhenDeviceUnreachable(
                  fromOutsideRoom: fromOutsideRoom,
                  entityId: entityId,
                );
              }
            } else {
              withDebounceUpdateWhenDeviceUnreachable(
                fromOutsideRoom: fromOutsideRoom,
                entityId: entityId,
              );
            }
          }
          // unawaited(EasyLoading.dismiss());
          Constants.dismissLoader();

          if (entityId!.isThermostat()) {
            if (otherValues?["hvac_mode"] != null) {
              if (otherValues?["hvac_mode"].toString().toLowerCase() != "off") {
                _debounceTimersForThermostat?.cancel();
                _debounceTimersForThermostat = Timer(
                  const Duration(seconds: 2),
                  () {
                    Future.delayed(const Duration(seconds: 3), () {
                      withDebounceUpdateWhenDeviceUnreachable(
                        fromOutsideRoom: fromOutsideRoom,
                        entityId: entityId,
                      );
                    });
                  },
                );
              }
            }
          }
        },
        onError: (error) {
          // unawaited(EasyLoading.dismiss());
          Constants.dismissLoader();

          withDebounceUpdateWhenDeviceUnreachable();
          _logger.severe("Error Operate Iot Devices: $error");
        },
      );
    });
  }

  void updateIotBrandSelected(bool selected, String type) {
    emit(
      state.rebuild((b) {
        b.getIotBrandsApi.data = b.getIotBrandsApi.data?.rebuild((d) {
          for (int i = 0; i < d.length; i++) {
            if (d[i].type == type) {
              d[i] = d[i].rebuild((n) => n.isSelected = selected);
            }
          }
        });
      }),
    );
  }

  BuiltList<Brands>? cacheSelectedBrands;

  void clearIotBrandSelected() {
    cacheSelectedBrands = state.getIotBrandsApi.data;
    emit(
      state.rebuild((b) {
        b.getIotBrandsApi.data = b.getIotBrandsApi.data?.rebuild((d) {
          for (int i = 0; i < d.length; i++) {
            d[i] = d[i].rebuild((n) => n.isSelected = false);
          }
        });
      }),
    );
  }

  void setCacheValueForBrands() {
    emit(
      state.rebuild((b) {
        b.getIotBrandsApi.data = b.getIotBrandsApi.data?.rebuild((d) {
          d.replace(cacheSelectedBrands ?? state.getIotBrandsApi.data!);
        });
      }),
    );
  }

  Future<void> getDeviceConfig({
    required Map<String, dynamic> data,
    required Function success,
    int? indexScannedDevice,
    int? indexBrand,
  }) async {
    updateIsDeviceAdded(false);
    if (config.environment == Environment.developTest ||
        config.environment == Environment.test) {
      bool isRestricted = true;

      final BuildContext? context =
          singletonBloc.navigatorKey?.currentState?.context;
      final String brand = data[Constants.brand];
      final String? type = (state.getIotBrandsApi.data ?? [].toBuiltList())
          .firstWhereOrNull(
            (e) => e.brand?.toLowerCase() == brand.toLowerCase(),
          )
          ?.type;

      if ((type ?? '').isTypeLight()) {
        if (singletonBloc.isFeatureCodePresent(AppRestrictions.addLight.code) ||
            singletonBloc.isFeatureCodePresent(
              AppRestrictions.addCameraAndAllIot.code,
            )) {
          isRestricted = false;
        }
      } else if ((type ?? '').isTypeLock()) {
        if (singletonBloc
                .isFeatureCodePresent(AppRestrictions.addSmartLock.code) ||
            singletonBloc.isFeatureCodePresent(
              AppRestrictions.addCameraAndAllIot.code,
            )) {
          isRestricted = false;
        }
      } else if (singletonBloc
          .isFeatureCodePresent(AppRestrictions.addCameraAndAllIot.code)) {
        isRestricted = false;
      }

      if (isRestricted) {
        if (context != null) {
          CommonFunctions.showRestrictionDialog(context);
        }
        return;
      }
    }

    updateNewFormData(null);
    updateNewFormDataDeviceName(null);
    if (indexScannedDevice != null) {
      final updatedDevice = state.scannedDevices[indexScannedDevice].copyWith(
        isSelected: true,
      );

      emit(
        state.rebuild(
          (b) => b..scannedDevices[indexScannedDevice] = updatedDevice,
        ),
      );
    } else if (indexBrand != null) {
      emit(
        state.rebuild((b) {
          b.getIotBrandsApi.data = b.getIotBrandsApi.data?.rebuild((d) {
            for (int i = 0; i < d.length; i++) {
              d[i] = d[i].rebuild((n) => n.isSelected = (i == indexBrand));
            }
          });
        }),
      );
    }
    await CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.getDeviceConfigResponse,
      updateApiState: (b, apiState) =>
          b.getDeviceConfigResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: Constants.deviceConfig,
      data: data,
      onSuccess: (data) {
        _logger.fine("Device Config success: $data");
        clearIotBrandSelected();
        if (data["status"] ?? false) {
          if (indexScannedDevice != null) {
            updateFormDevice(state.scannedDevices[indexScannedDevice]);
            final updatedDevice = state.scannedDevices[indexScannedDevice]
                .copyWith(isSelected: false);

            emit(
              state.rebuild(
                (b) => b..scannedDevices[indexScannedDevice] = updatedDevice,
              ),
            );
          } else if (indexBrand != null) {
            updateFormDevice(null);
            emit(
              state.rebuild((b) {
                b.getIotBrandsApi.data = b.getIotBrandsApi.data?.rebuild((d) {
                  for (int i = 0; i < d.length; i++) {
                    d[i] = d[i].rebuild((n) => n.isSelected = false);
                  }
                });
              }),
            );
          }

          success.call();
        } else {
          ifSocketResponseStatusFalse(data);
        }
      },
      onError: (error) {
        _logger.severe("Error Device Config: $error");
        if (indexScannedDevice != null &&
            indexScannedDevice < state.scannedDevices.length) {
          final updatedDevice = state.scannedDevices[indexScannedDevice]
              .copyWith(isSelected: false);

          emit(
            state.rebuild(
              (b) => b..scannedDevices[indexScannedDevice] = updatedDevice,
            ),
          );
        } else if (indexBrand != null) {
          clearIotBrandSelected();
        }
      },
    );
  }

  void ifSocketResponseStatusFalse(Map<String, dynamic> data) {
    try {
      ToastUtils.errorToast(
        jsonDecode(data['data'] ?? "{}")['message'].toString(),
      );
    } catch (e) {
      ToastUtils.errorToast(data["data"].toString());
    }
  }

  Future<void> createRoom(VoidCallback callback) {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.postIotRoomsApi,
      updateApiState: (final b, final apiState) =>
          b.postIotRoomsApi.replace(apiState),
      callApi: () async {
        final selectedRoom = state.getConstantRooms.firstWhereOrNull(
          (room) => room.selectedValue,
        );
        await apiService.createRoom(state.roomName, selectedRoom!.roomType);
        ToastUtils.successToast("Room Added Successfully");
        unawaited(callIotRoomsApi());
        callback.call();
      },
    );
  }

  Future<void> operateCurtain({
    required String deviceId,
    required String entityId,
    required String command,
    required String val,
    required String parameter,
    VoidCallback? callback,
    bool fromOutsideRoom = false,
    String? token,
    String? secret,
  }) async {
    // unawaited(EasyLoading.show());
    Constants.showLoader(showCircularLoader: false);

    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.curtainApis,
      updateApiState: (final b, final apiState) =>
          b.curtainApis.replace(apiState),
      callApi: () async {
        final currentPosition =
            await apiService.getStatusCurtain(deviceId, entityId);
        final status = await apiService.operateCurtain(
          deviceId,
          command: command,
          token: token!,
          secret: secret!,
          parameter: parameter,
          entityId: entityId,
          val: val,
        );
        bool checkIfMoving = false;
        // Wait 2 seconds
        await Future.delayed(const Duration(seconds: 2));

        var checkStatus = await apiService.getStatusCurtain(deviceId, entityId);
        if (!listEquals(currentPosition, checkStatus)) {
          checkIfMoving = true;
          unawaited(
            apiService.setCurtainAttributes(
              entityId,
              status["request_data"] ?? {},
            ),
          );
        } else {
          // Wait another 2 seconds
          await Future.delayed(const Duration(seconds: 2));

          checkStatus = await apiService.getStatusCurtain(deviceId, entityId);
          if (!listEquals(currentPosition, checkStatus)) {
            checkIfMoving = true;
            unawaited(
              apiService.setCurtainAttributes(
                entityId,
                status["request_data"] ?? {},
              ),
            );
          }
        }
        if (status['status'] && checkIfMoving) {
          if (callback != null) {
            unawaited(
              apiService.getStatusCurtain(
                deviceId,
                entityId,
                token: token,
                secret: secret,
              ),
            );
            callback.call();
          }
          emit(
            state.rebuild((b) {
              final list = b.iotDeviceModel.build().toList();
              final index =
                  list.indexWhere((data) => data.entityId == entityId);
              if (index != -1) {
                unawaited(updateIotDeviceUsageCount(list[index].id));

                final updatedDevice = list[index].rebuild((device) {
                  device.curtainPosition = val;
                });

                list[index] = updatedDevice;
                b.iotDeviceModel.replace(BuiltList<IotDeviceModel>(list));
              }
            }),
          );
          if (!fromOutsideRoom) {
            emit(
              state.rebuild((b) {
                final updatedList = b.inRoomIotDeviceModel.build().toList();

                if (b.selectedIotIndex != null) {
                  updatedList[b.selectedIotIndex!] =
                      updatedList[b.selectedIotIndex!].rebuild((d) {
                    d.curtainPosition = val;
                  });

                  b.inRoomIotDeviceModel.replace(updatedList);
                }
              }),
            );
          }
        } else if (!status['status']) {
          ToastUtils.errorToast(
            "Sorry, we couldn't get in contact with your hub",
          );
        }

        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();
      },
    );
  }

  void resetRoomSelection() {
    emit(
      state.rebuild(
        (b) => b
          ..getConstantRooms = ListBuilder(
            state.getConstantRooms
                .asList()
                .asMap()
                .map(
                  (i, room) => MapEntry(
                    i,
                    room.rebuild((a) => a..selectedValue = false),
                  ),
                )
                .values
                .toList(),
          )
          ..isEnabled = false
          ..postIotRoomsApi.replace(ApiState()),
      ),
    );
  }

  String? sessionId;

  Future<void> socketListener() async {
    sessionId ??= await CommonFunctions.getDeviceModel();
    singletonBloc.socket!.off(Constants.iot);
    await Future.delayed(const Duration(seconds: 1));
    singletonBloc.socket!.on(Constants.iot, (data) async {
      _logger.info("🎧 Socket response: ${data[Constants.command]}");

      await Future.microtask(() {
        final command = data[Constants.command];
        final session = data[Constants.sessionId];
        bool isHandlerExecuted = false;
        if (session != sessionId && session.toString().isNotEmpty) {
          if ((command == Constants.addDevice ||
                  command == Constants.deleteDevice) &&
              (data['status'] ?? false)) {
            callIotApi(clear: false);
          } else if (Constants.allIotDevicesState == command) {
            updateAllDevicesStates(jsonDecode(data["data"]));
          } else if (command == Constants.operateIotDevice) {
            final json = jsonDecode(data["data"]);
            final updatedDevices = <IotDeviceModel>[];

            final list = state.iotDeviceModel!.toList();
            try {
              // final configData = (configNewData ?? {}).firstWhereOrNull(
              //   (e) => e["entity_id"] == device.entityId,
              // );

              for (final device in list) {
                if (device.entityId == json['entity_id']) {
                  updatedDevices.add(
                    device.rebuild((b) {
                      b.stateAvailable = json["service"] == null
                          ? b.stateAvailable
                          : json["service"] == Constants.turnOff ||
                                  json["service"] == Constants.unlock
                              ? 2
                              : 1;
                      if (device.entityId!.isBulb()) {
                        b.brightness = double.tryParse(
                          (json['othervalues']?['brightness'] ?? b.brightness)
                              .toString(),
                        );
                        if (json['othervalues']?["effect"] != null) {
                          final json = jsonDecode(b.configuration ?? "{}")["a"];
                          json['effect'] = json['othervalues']["effect"];
                          final Map newConfig = {};
                          newConfig["a"] = json;
                          b.configuration = jsonEncode(newConfig);
                        }
                      } else if (device.entityId!.isThermostat()) {
                        b
                          ..temperature = (json['othervalues']
                                      ?["temperature"] ??
                                  b.temperature)
                              .toString()
                          ..mode = (json['othervalues']?["hvac_mode"] ?? b.mode)
                              .toString()
                          ..presetMode = (json['othervalues']?["preset_mode"] ??
                                  b.presetMode)
                              .toString()
                          ..fanMode =
                              (json['othervalues']?["fan_mode"] ?? b.fanMode)
                                  .toString();
                      }
                    }),
                  );
                } else {
                  updatedDevices.add(device);
                }
              }
              emit(
                state.rebuild((b) => b.iotDeviceModel.replace(updatedDevices)),
              );
              if (state.inRoomIotDeviceModel != null &&
                  state.inRoomIotDeviceModel!.isNotEmpty) {
                final List<IotDeviceModel> list = [
                  ...?state.iotDeviceModel?.where(
                    (item) =>
                        item.roomId == state.selectedRoom?.roomId &&
                        !item.entityId!.isCamera(),
                  ),
                ];
                final updatedInRoomDevices = <IotDeviceModel>[];

                for (final roomDevice in list) {
                  final updatedDevice = updatedDevices.firstWhereOrNull(
                    (device) => device.entityId == roomDevice.entityId,
                  );

                  if (updatedDevice != null) {
                    updatedInRoomDevices.add(updatedDevice);
                  } else {
                    updatedInRoomDevices.add(roomDevice);
                  }
                }

                emit(
                  state.rebuild(
                    (b) => b.inRoomIotDeviceModel.replace(updatedInRoomDevices),
                  ),
                );
              }
            } catch (e) {
              _logger.severe("Error socket Listener: $e");
            }
          }
        }
        // else if (Constants.allIotDevicesState == command) {
        //   updateAllDevicesStates(jsonDecode(data["data"]));
        // }
        else {
          isHandlerExecuted = SocketRequestManager.handleResponse(data);
          if (command == Constants.allIotDevicesState &&
              !isHandlerExecuted &&
              session.toString().isNotEmpty) {
            _logger.severe("Handler was not executed");
            updateAllDevicesStates(jsonDecode(data["data"]));
          } else if (command == Constants.getFlowIds) {
            _logger.severe("Not in Handler was not executed");
          } else if (command == Constants.allIotDevicesStateReconnected) {
            _logger.severe("Handler was not executed");
            updateAllDevicesStates(jsonDecode(data["data"]));
          }
        }
        return;
      });
    });
  }

  String getIcon(type) {
    if (type == "bulb") {
      return DefaultIcons.IOT_BULB;
    } else if (type == "camera") {
      return DefaultIcons.CAMERA;
    } else if (type == "doorbell") {
      return DefaultIcons.DOORBELL_RELEASE;
    } else if (type == "speaker") {
      return DefaultIcons.CHROME_CAST;
    } else if (type == "thermostate") {
      return DefaultIcons.THERMOSTAT;
    } else if (type == "thermostat") {
      return DefaultIcons.THERMOSTAT;
    } else if (type == 'lock') {
      return DefaultIcons.DOORBELL_LOCK;
    } else if (type == 'hub' || type == 'switchbot') {
      return DefaultIcons.SWITCHBOT_ICON;
    }
    return DefaultIcons.IOT_BULB;
  }

  String getType(String icon) {
    if (icon == DefaultIcons.IOT_BULB) {
      return "bulb";
    } else if (icon == DefaultIcons.CAMERA || icon == DefaultVectors.CAMERA) {
      return "camera";
    } else if (icon == DefaultIcons.DOORBELL_RELEASE) {
      return "doorbell";
    } else if (icon == DefaultIcons.CHROME_CAST) {
      return "speaker";
    } else if (icon == DefaultIcons.THERMOSTAT ||
        icon == DefaultVectors.THERMOSTAT_ICON ||
        icon == DefaultVectors.THERMOSTAT_IMAGE) {
      return "thermostat"; // covers both "thermostat" and "thermostate"
    } else if (icon == DefaultIcons.DOORBELL_LOCK ||
        icon == DefaultVectors.DOORBELL_LOCK) {
      return "lock";
    } else if (icon == DefaultIcons.SWITCHBOT_ICON ||
        icon == DefaultVectors.SWITCHBOT_ICON) {
      return "switchbot"; // or "hub" depending on your use-case
    }
    return "bulb"; // default
  }

  bool needIotStatesCall() {
    final allIotDevices = state.iotDeviceModel?.where(
      (device) =>
          !device.entityId!.isCamera() &&
          !device.entityId!.isSwitchBot() &&
          singletonBloc.profileBloc.state?.selectedDoorBell?.locationId
                  .toString() ==
              device.locationId.toString(),
    );
    if (allIotDevices?.isNotEmpty ?? false) {
      return allIotDevices!.every((e) => e.stateAvailable == 3);
    } else {
      return false;
    }
  }

  Future<void> createAddDevice({
    required Map<String, dynamic> map,
    required Function success,
    required Function successForm,
    String command = Constants.addDevice,
    Function()? onError,
    Function()? forRing,
  }) async {
    return CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.createDeviceResponse,
      updateApiState: (b, apiState) => b.createDeviceResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: command,
      timeout: map["brand"].toString().isRing()
          ? const Duration(minutes: 5)
          : const Duration(seconds: 120),
      data: map,
      onSuccess: (data) {
        _logger.fine("$command success: $data");
        if (data["status"] ?? false) {
          emit(
            state.rebuild(
              (b) => b.createDeviceResponse.error.replace(ApiMetaData()),
            ),
          );
          if (data["data"].contains("form")) {
            updateNewFormData(data["data"]);
            successForm.call();
          } else {
            updateNewFormData(null);
            updateCurrentFormStep(1);
            updateIsDeviceAdded(true);
            updateIsDeviceAddedResponse(
              data["data"].toString().toLowerCase().contains("streaming")
                  ? data["data"]
                  : null,
            );
            success.call(
              data["data"].toString().toLowerCase().contains("streaming")
                  ? data["data"]
                  : null,
            );
          }
        } else {
          try {
            final raw = data["data"];
            final Map<String, dynamic> parsed =
                raw.isEmpty ? {} : jsonDecode(raw);

            final message = parsed['message'] ?? parsed['base'];

            final errorMessage = (message.toString().toLowerCase() ==
                    'invalid_auth')
                ? "Invalid Authentication"
                : (message.toString().toLowerCase() == 'invalid_host')
                    ? "Invalid Host"
                    : (message.toString().toLowerCase() ==
                            'invalid_verification_code')
                        ? "Invalid Verification Code"
                        : (message.toString().toLowerCase() == 'no_ip')
                            ? "Invalid IP Address"
                            : (message.toString().toLowerCase() ==
                                    'cannot_connect')
                                ? "Can not find the device on your network"
                                : (message
                                        ?.toString()
                                        .capitalizeFirstOfEach() ??
                                    "Some of your information is Incorrect. We can't connect your device");
            emit(
              state.rebuild(
                (b) => b.createDeviceResponse.error
                    .replace(ApiMetaData.fromMessage(errorMessage)),
              ),
            );
            if (command == Constants.addDevice && state.currentFormStep != 1) {
              updateCurrentFormStep(state.currentFormStep! - 1);
            }

            // ToastUtils.errorToast(errorMessage);
            if (map["brand"].toString().isRing() &&
                (state.currentFormStep ?? 0) >= 2) {
              getDeviceConfig(
                data: {
                  Constants.brand: map["brand"].toString(),
                },
                success: () {
                  forRing!.call();
                  updateCurrentFormStep(1);
                },
              );
            }
          } catch (e) {
            emit(
              state.rebuild(
                (b) => b.createDeviceResponse.error.replace(
                  ApiMetaData.fromMessage(
                    data["data"].toString().capitalizeFirstOfEach(),
                  ),
                ),
              ),
            );
            // ToastUtils.errorToast(
            //   data["data"].toString().capitalizeFirstOfEach(),
            // );
          }
        }
      },
      onError: (error) {
        // if (map["brand"].toString().isRing() ||
        //     (state.currentFormStep ?? 0) >= 2) {
        //   getDeviceConfig(
        //     data: {
        //       Constants.brand: map["brand"].toString(),
        //     },
        //     success: () {
        //       forRing!.call();
        //     },
        //   );
        //   updateCurrentFormStep(1);
        // }
        onError?.call();
        _logger.severe("Error Add Device: $error");
      },
    );
  }

  void withDebounceUpdateWhenDeviceUnreachable({
    bool? fromOutsideRoom = false,
    String? entityId,
  }) {
    updateWhenDeviceUnreachable(
      fromOutsideRoom: fromOutsideRoom,
      entityId: entityId,
    );
  }

  @override
  void updateSelectedIotIndex(final int selectedIotIndex) {
    emit(state.rebuild((final b) => b.selectedIotIndex = selectedIotIndex));

    super.updateSelectedIotIndex(selectedIotIndex);
  }

  void assignSelectedIndex(String? entityId, {int? roomId}) {
    if (roomId != null) {
      if (state.getIotRoomsApi.data != null &&
          state.getIotRoomsApi.data!.firstWhereOrNull(
                (room) => roomId == room.roomId,
              ) !=
              null) {
        updateSelectedRoom(
          state.getIotRoomsApi.data!.firstWhereOrNull(
            (room) => roomId == room.roomId,
          ),
        );
        if (state.inRoomIotDeviceModel != null) {
          updateSelectedIotIndex(
            state.inRoomIotDeviceModel!.indexWhere(
              (device) => device.entityId == entityId,
            ),
          );
        }
      }
    } else {
      final device = state.iotDeviceModel!.firstWhereOrNull(
        (e) => e.entityId == entityId,
      );
      if (device != null) {
        updateSelectedRoom(
          state.getIotRoomsApi.data!.firstWhereOrNull(
            (room) => device.roomId == room.roomId,
          ),
        );
        updateSelectedIotIndex(
          state.inRoomIotDeviceModel!.indexWhere(
            (device) => device.entityId == entityId,
          ),
        );
      }
    }
    // unawaited(EasyLoading.dismiss());
    Constants.dismissLoader();
  }

  Future<void> updateWhenDeviceUnreachable({
    bool? fromOutsideRoom = false,
    String? entityId,
  }) async {
    if (state.iotDeviceModel!.isNotEmpty) {
      // _debounceTimerAllState?.cancel();
      // _debounceTimerAllState = Timer(const Duration(seconds: 2), () async {
      updateIsAllStatesExecuted(true);
      try {
        final Map<String, dynamic>? configNewData = await
            // unawaited(
            getAllDeviceConfigurations();
        // );

        // Add check for empty or null config data
        if (configNewData == null || configNewData.isEmpty) {
          _logger.warning(
            "No device configuration data available to update states",
          );
          await updateAllDevicesStates(configNewData);

          return;
        }
        await updateAllDevicesStates(configNewData);

        if (!fromOutsideRoom!) {
          if (entityId != null) {
            assignSelectedIndex(entityId);
          }
        }
      } catch (e) {
        _logger.severe("Error in updateWhenDeviceUnreachable: $e");
      }
      // });
    }
  }

  // bool rsyncSwitchBot = false;
  // int? locationIdForRsyncMatch;
  Timer? _debounceTimerAllState;

  Future<void> updateAllDevicesStates(
    Map<String, dynamic>? configNewData,
  ) async {
    try {
      _debounceTimerAllState?.cancel();
      _debounceTimerAllState = Timer(const Duration(seconds: 1), () async {
        final updatedDevices = <IotDeviceModel>[];
        final originalList = state.iotDeviceModel?.toList() ?? [];

        // === Step 1: Process non-SwitchBot devices ===
        for (final device in originalList) {
          if (!device.entityId!.isSwitchBot()) {
            try {
              final configData = (configNewData ?? {})[device.entityId];
              if (configData == null) {
                updatedDevices.add(device);
                continue;
              }

              updatedDevices.add(
                device.rebuild((b) {
                  b
                    ..configuration = jsonEncode(configData)
                    ..stateAvailable = configData["s"] == "unavailable"
                        ? 3
                        : configData["s"] == "off" ||
                                configData["s"] == "unlocked"
                            ? 2
                            : 1;

                  if (device.entityId!.isBulb()) {
                    b.brightness = double.tryParse(
                          (configData['a']?['brightness'] ?? b.brightness)
                              .toString(),
                        ) ??
                        b.brightness;
                  } else if (device.entityId!.isThermostat()) {
                    configNewData?.forEach((key, value) {
                      if (key.contains("sensor") &&
                          key.contains(
                            device.entityId!.split("${Constants.climate}.")[1],
                          ) &&
                          key.contains("temperature")) {
                        b.thermostatTemperatureUnit =
                            value['a']["unit_of_measurement"];
                      }
                    });
                    b
                      ..temperature = (configData["a"]?["temperature"] ??
                              configData["a"]?["min_temp"] ??
                              40.toString())
                          .toString()
                      ..mode = (configData["s"] ?? "Heat").toString()
                      ..presetMode =
                          (configData["a"]?["preset_mode"] ?? "None").toString()
                      ..fanMode =
                          (configData["a"]?["fan_mode"] ?? "Off").toString();
                  }
                }),
              );
            } catch (e) {
              updatedDevices.add(device);
            }
          } else {
            if (!device.entityId!.isHub()) {
              updatedDevices.add(device);
            }
          }
        }

        // === 1st emit: non-SwitchBot devices updated ===
        emit(state.rebuild((b) => b.iotDeviceModel.replace(updatedDevices)));

        // === Step 2: Always update curtain position ===
        final curtainUpdatedDevices = <IotDeviceModel>[];

        for (final device in originalList) {
          if (device.entityId!.isSwitchBot()) {
            try {
              final json = jsonDecode(
                (device.details?['extra_param'] ?? "{}").toString(),
              );

              if (json is Map) {
                final token = json["api_token"];
                final key = json["api_key"];
                final deviceId = json["device_id"];

                if (token != null && key != null && deviceId != null) {
                  final data = await apiService.getStatusCurtain(
                    deviceId,
                    device.entityId!,
                    token: token,
                    secret: key,
                  );
                  final curtainPosition = data[0];
                  final blindDirection = data[1];
                  curtainUpdatedDevices.add(
                    device.rebuild((b) {
                      b
                        ..stateAvailable = 1
                        ..curtainDeviceId = deviceId
                        ..curtainPosition = curtainPosition.toString()
                        ..blindDirection = blindDirection;
                    }),
                  );
                }
              }
            } catch (e) {
              if (!device.entityId!.isHub()) {
                curtainUpdatedDevices.add(
                  device,
                ); // fallback to original device
              }
            }
          }
        }

        // === 2nd emit: add curtain updates ===
        final allUpdated = [
          ...updatedDevices.where((d) => !d.entityId!.isSwitchBot()),
          ...curtainUpdatedDevices,
        ];

        emit(state.rebuild((b) => b.iotDeviceModel.replace(allUpdated)));

        // === Optional: update in-room device models too ===
        if (state.inRoomIotDeviceModel?.isNotEmpty ?? false) {
          final inRoom = state.iotDeviceModel?.where(
            (item) =>
                item.roomId == state.selectedRoom?.roomId &&
                !item.entityId!.isCamera() &&
                !item.entityId!.isHub(),
          );
          final updatedInRoom = inRoom?.map((device) {
            final match = updatedDevices.firstWhereOrNull(
              (d) => d.entityId == device.entityId && !device.entityId!.isHub(),
            );
            return match ?? device;
          }).toList();

          if (updatedInRoom != null) {
            final inRoom = state.inRoomIotDeviceModel!;
            final updated =
                updatedInRoom // Sort updatedInRoom to match the order of inRoomIotDeviceModel by entityId
                  ..sort((a, b) {
                    final aIndex =
                        inRoom.indexWhere((e) => e.entityId == a.entityId);
                    final bIndex =
                        inRoom.indexWhere((e) => e.entityId == b.entityId);
                    return aIndex.compareTo(bIndex);
                  });
            emit(
              state.rebuild(
                (b) => b.inRoomIotDeviceModel.replace(updated),
              ),
            );
          }
        }
        // singletonBloc.profileBloc.state?.selectedDoorBell?.locationId;
        // if (rsyncSwitchBot &&
        //     locationIdForRsyncMatch !=
        //         singletonBloc.profileBloc.state?.selectedDoorBell?.locationId) {
        //   rsyncSwitchBot = false;
        // }
        // === Step 3: Do RSYNC only if needed ===
        // if (!rsyncSwitchBot) {
        //   locationIdForRsyncMatch =
        //       singletonBloc.profileBloc.state?.selectedDoorBell?.locationId;
        //   rsyncSwitchBot = true;
        //
        //   for (final device in originalList) {
        //     if (device.entityId!.isSwitchBot()) {
        //       try {
        //         final json = jsonDecode(
        //           (device.details?['extra_param'] ?? "{}").toString(),
        //         );
        //         if (json is Map) {
        //           final token = json["api_token"];
        //           final key = json["api_key"];
        //
        //           if (token != null && key != null) {
        //             final devices = await apiService.getCurtainDeviceId(
        //               list: true,
        //               token: token,
        //               secret: key,
        //             );
        //             if (devices is! String) {
        //               final requestList = devices
        //                   .where(
        //                 (device) =>
        //                     device.deviceType
        //                         .toString()
        //                         .isHubWithoutEntityId() ||
        //                     device.deviceType
        //                         .toString()
        //                         .isCurtainWithoutEntityId() ||
        //                     device.deviceType
        //                         .toString()
        //                         .isBlindWithoutEntityId(),
        //               )
        //                   .map((d) {
        //                 return {
        //                   "room_id": device.roomId,
        //                   "name": d.deviceName,
        //                   "entity_id": "switchbot."
        //                       "${d.deviceType.replaceAll(" ", "").toLowerCase()}."
        //                       "${d.deviceType.toString().isHubWithoutEntityId() ? d.deviceId : d.hubDeviceId}"
        //                       "${d.deviceType.toString().isHubWithoutEntityId() ? "" : ".${d.deviceId}"}",
        //                   "mac_address": "1123",
        //                   "extra_param": jsonEncode({
        //                     "device_type": d.deviceType.toLowerCase(),
        //                     "api_key": key,
        //                     "api_token": token,
        //                     "hub_device_id":
        //                         d.deviceType.toString().isHubWithoutEntityId()
        //                             ? d.deviceId
        //                             : d.hubDeviceId,
        //                     "device_id": d.deviceId,
        //                   }),
        //                   "is_lock": true,
        //                   "ip_address": json["ip_address"],
        //                 };
        //               }).toList();
        //
        //               final map = {
        //                 "location_id": singletonBloc
        //                     .profileBloc.state?.selectedDoorBell?.locationId,
        //                 "doorbell_id": singletonBloc
        //                     .profileBloc.state?.selectedDoorBell?.id,
        //                 "devices": requestList,
        //               };
        //
        //               await apiService.switchBotRsync(map);
        //             } else {
        //               ToastUtils.errorToast("Switchbot is $devices");
        //             }
        //             unawaited(callIotApi(clear: false));
        //             return;
        //           }
        //         }
        //       } catch (e) {
        //         // log error
        //         _logger.severe(e.toString());
        //       }
        //     }
        //   }
        // }

        updateIsAllStatesExecuted(false);
      });
    } catch (e) {
      _logger.severe(e.toString());
    }
  }

  Future<void> getAndAddDeviceSwitchBot({
    required String token,
    required String key,
    required host,
    required roomId,
    required Function onSuccess,
    required name,
    String? entityId,
  }) async {
    return CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.curtainAddAPI,
      updateApiState: (final b, final apiState) =>
          b.curtainAddAPI.replace(apiState),
      onError: (e) {
        _logger.severe(e.toString());
      },
      callApi: () async {
        final map = await getSwitchBotDevices(token, key, roomId, host);
        if (map is! String) {
          if (map["devices"].isNotEmpty) {
            if (entityId != null) {
              map["devices"] = map['devices']
                  .where((device) => device['entity_id'] == entityId)
                  .toList();
            }
            final response = await apiService.callAddIotDeviceApi(map);
            final isAdded =
                response.statusCode == 200 || response.statusCode == 201;
            if (isAdded) {
              ToastUtils.successToast(
                response.data["message"].contains("no device")
                    ? "Devices are already added"
                    : response.data["message"],
              );
              onSuccess.call();
            }
          } else {
            ToastUtils.errorToast(
              "We can only add the devices if there is switchbot hub in your switchbot system.",
            );
          }
        } else {
          ToastUtils.errorToast(map);
        }
      },
    );
  }

  // Future<void> getAllFlowIds({
  //   required ip,
  //   required name,
  //   required Function successForm,
  //   required Function success,
  // }) {
  //   return CubitUtils.makeSocketCall<IotState, IotStateBuilder,
  //       Map<String, dynamic>>(
  //     cubit: this,
  //     apiState: state.getAllFlowIdResponse,
  //     updateApiState: (b, apiState) => b.getAllFlowIdResponse.replace(apiState),
  //     socket: singletonBloc.socket!,
  //     eventName: Constants.iot,
  //     responseEvent: Constants.iot,
  //     command: Constants.getFlowIds,
  //     timeout: const Duration(seconds: 15),
  //     onSuccess: (data) {
  //       _logger.fine("Get All Flow Id Response success: $data");
  //       if (data["status"] ?? false) {
  //         final List json = jsonDecode(data['data']);
  //         for (final j in json) {
  //           final data = ProgressIdsResponse.fromJson(j);
  //           if (ip.toString().toLowerCase().contains(
  //                 data.ip.toString().toLowerCase(),
  //               )) {
  //             final value = {
  //               "flow_id": data.flowid,
  //               "host": data.ip,
  //               "device_name": "",
  //               "brand": data.brand,
  //               "room_id": "",
  //               "from_camera_form": false,
  //             };
  //             updateFormDevice(
  //               FeatureModel(
  //                 title: name!,
  //                 brand: data.brand,
  //                 image: Constants.camera.getIcon(),
  //               ),
  //             );
  //             createAddDevice(
  //               map: value,
  //               success: success,
  //               successForm: successForm,
  //               command: Constants.deviceConfigFlowId,
  //             );
  //             break;
  //           }
  //         }
  //       } else {
  //         try {
  //           ToastUtils.errorToast(
  //             (jsonDecode(
  //                       data["data"].isEmpty ? "{}" : data["data"],
  //                     )?['message'] ??
  //                     "Invalid Authentication")
  //                 .toString()
  //                 .capitalizeFirstOfEach(),
  //           );
  //         } catch (e) {
  //           ToastUtils.errorToast(
  //             data["data"].toString().capitalizeFirstOfEach(),
  //           );
  //         }
  //       }
  //     },
  //     onError: (error) {
  //       _logger.severe("Error Add Device: $error");
  //     },
  //   );
  // }
  Future<void> getAllFlowIds({
    required ip,
    required name,
    required Function successForm,
    required Function success,
    int attempt = 1, // Track retry count
  }) {
    const int maxAttempts = 5;
    return CubitUtils.makeSocketCall<IotState, IotStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.getAllFlowIdResponse,
      updateApiState: (b, apiState) => b.getAllFlowIdResponse.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.iot,
      responseEvent: Constants.iot,
      command: Constants.getFlowIds,
      timeout: const Duration(seconds: 15),
      onSuccess: (data) {
        updateCurrentFormStep(1);
        _logger.fine("Get All Flow Id Response success: $data");

        if (data["status"] ?? false) {
          final List json = jsonDecode(data['data']);

          // Retry if empty
          if (json.isEmpty && attempt < maxAttempts) {
            _logger.warning(
              "Empty flow ID list. Retrying... Attempt $attempt/$maxAttempts",
            );
            getAllFlowIds(
              ip: ip,
              name: name,
              successForm: successForm,
              success: success,
              attempt: attempt + 1, // Increment attempt count
            );
            return; // Stop current execution
          }

          for (final j in json) {
            final parsed = ProgressIdsResponse.fromJson(j);
            if (ip.toString().toLowerCase().contains(
                  parsed.ip.toString().toLowerCase(),
                )) {
              final value = {
                "flow_id": parsed.flowid,
                "host": parsed.ip,
                "device_name": "",
                "brand": parsed.brand,
                "room_id": "",
                "from_camera_form": false,
              };
              updateFormDevice(
                FeatureModel(
                  title: name!,
                  brand: parsed.brand,
                  image: Constants.camera.getIcon(),
                ),
              );
              createAddDevice(
                map: value,
                success: success,
                successForm: successForm,
                command: Constants.deviceConfigFlowId,
              );
              break;
            }
          }
        } else {
          try {
            ToastUtils.errorToast(
              (jsonDecode(
                        data["data"].isEmpty ? "{}" : data["data"],
                      )?['message'] ??
                      "Invalid Authentication")
                  .toString()
                  .capitalizeFirstOfEach(),
            );
          } catch (e) {
            ToastUtils.errorToast(
              data["data"].toString().capitalizeFirstOfEach(),
            );
          }
        }
      },
      onError: (error) {
        _logger.severe("Error Add Device: $error");
        if (attempt < maxAttempts) {
          getAllFlowIds(
            ip: ip,
            name: name,
            successForm: successForm,
            success: success,
            attempt: attempt + 1, // Increment attempt count
          );
          return; // Stop current execution
        }
      },
    );
  }

  // void forMohsinBhaiTesting(
  //   String? entityId,
  //   service, {
  //   bool fromOutsideRoom = false,
  // }) {
  //   emit(
  //     state.rebuild(
  //       (b) {
  //         final list = b.iotDeviceModel.build().toList();
  //         final index = list.indexWhere((data) => data.entityId == entityId);
  //
  //         if (index != -1) {
  //           list[index] = list[index].rebuild((device) {
  //             device.stateAvailable =
  //                 (service == Constants.turnOn || service == Constants.lock)
  //                     ? 1
  //                     : 2;
  //
  //             if (entityId!.isLock()) {
  //               device.stateAvailable = (service == Constants.lock) ? 1 : 2;
  //             }
  //           });
  //
  //           b.iotDeviceModel = BuiltList<IotDeviceModel>(list).toBuilder();
  //         }
  //       },
  //     ),
  //   );
  //   if (!fromOutsideRoom) {
  //     emit(
  //       state.rebuild(
  //         (b) {
  //           final updatedList = b.inRoomIotDeviceModel.build().toList();
  //
  //           if (b.selectedIotIndex != null) {
  //             if (b.selectedIotIndex! <= updatedList.length - 1) {
  //               updatedList[b.selectedIotIndex!] =
  //                   updatedList[b.selectedIotIndex!].rebuild((d) {
  //                 d.stateAvailable =
  //                     service == Constants.turnOn || service == Constants.lock
  //                         ? 1
  //                         : 2;
  //                 if (entityId!.isLock()) {
  //                   d.stateAvailable = (service == Constants.lock) ? 1 : 2;
  //                 }
  //               });
  //
  //               b.inRoomIotDeviceModel.replace(updatedList);
  //             }
  //           }
  //         },
  //       ),
  //     );
  //   }
  // }

  void deleteCurtainDevices(String entityId, Function() onSuccess) {
    CubitUtils.makeApiCall<IotState, IotStateBuilder, void>(
      cubit: this,
      apiState: state.deleteCurtainDevice,
      updateApiState: (final b, final apiState) =>
          b.deleteCurtainDevice.replace(apiState),
      onError: (e) {
        _logger.severe(e.toString());
      },
      callApi: () async {
        final isDeleted = await apiService.deleteIotDevice(
          singletonBloc.profileBloc.state!.selectedDoorBell!.locationId
              .toString(),
          state.iotDeviceModel!,
          entityId,
        );
        if (isDeleted) {
          ToastUtils.successToast("Device successfully deleted");
          onSuccess.call();
        }
      },
    );
  }

  void resetPostRoomState() {
    emit(state.rebuild((e) => e.postIotRoomsApi.replace(ApiState<void>())));
  }

  Future getSwitchBotDevices(token, key, roomId, host) async {
    final devices = await apiService.getCurtainDeviceId(
      list: true,
      token: token,
      secret: key,
    );
    if (devices is! String) {
      final map = <String, dynamic>{
        "location_id":
            singletonBloc.profileBloc.state?.selectedDoorBell?.locationId,
        "doorbell_id": singletonBloc.profileBloc.state?.selectedDoorBell?.id,
      };
      final requestDevicesList = [];
      for (final Device device in devices) {
        if (
            // device.deviceType.isHubWithoutEntityId() ||
            (device.deviceType.isCurtainWithoutEntityId() ||
                    device.deviceType.isBlindWithoutEntityId()) &&
                device.hubDeviceId.isNotEmpty) {
          requestDevicesList.add({
            "room_id": roomId,
            "name": device.deviceName,
            "entity_id": "switchbot."
                "${device.deviceType.replaceAll(" ", "").toLowerCase()}."
                "${device.deviceType.isHubWithoutEntityId() ? device.deviceId : device.hubDeviceId}"
                "${device.deviceType.isHubWithoutEntityId() ? "" : ".${device.deviceId}"}",
            "mac_address": 1123.toString(),
            "extra_param": jsonEncode({
              "device_type": device.deviceType.toLowerCase(),
              "api_key": key,
              "api_token": token,
              "hub_device_id": device.deviceType.isHubWithoutEntityId()
                  ? device.deviceId
                  : device.hubDeviceId,
              "device_id": device.deviceId,
            }),
            "is_lock": true,
            "ip_address": host,
          });
        }
      }
      map["devices"] = requestDevicesList;
      return map;
    }
    return devices;
  }

  bool isRing() {
    return (state.iotDeviceModel?.toList() ?? []).any((element) {
      final brand = element.details?["brand"];
      if (brand == "ring") {
        return true;
      }

      final extraParam = element.details?["extra_param"];
      dynamic parsed;

      if (extraParam is String && extraParam.isNotEmpty) {
        try {
          parsed = jsonDecode(extraParam);
        } catch (_) {
          parsed = null;
        }
      } else {
        parsed = extraParam;
      }

      if (parsed is Map &&
          (parsed['brand'] == "ring" || parsed['brand'] == "mqtt")) {
        return true;
      }

      return false;
    });
  }

  bool isEzviz() {
    return (state.iotDeviceModel?.toList() ?? []).any((element) {
      final brand = element.details?["brand"];
      if (brand == "ezviz") {
        return true;
      }

      final extraParam = element.details?["extra_param"];
      dynamic parsed;

      if (extraParam is String && extraParam.isNotEmpty) {
        try {
          parsed = jsonDecode(extraParam);
        } catch (_) {
          parsed = null;
        }
      } else {
        parsed = extraParam;
      }

      if (parsed is Map && parsed['brand'] == "ezviz") {
        return true;
      }

      return false;
    });
  }

  void resetCreateState() {
    emit(
      state.rebuild((final b) {
        b
          ..createDeviceResponse.replace(SocketState())
          ..currentFormStep = null;
      }),
    );
  }
}

class ProgressIdsResponse {
  ProgressIdsResponse({
    required this.brand,
    required this.flowid,
    required this.title,
    required this.uniqueId,
    this.ip,
  });

  factory ProgressIdsResponse.fromJson(Map<String, dynamic> json) {
    return ProgressIdsResponse(
      brand: json["handler"],
      flowid: json["flow_id"],
      title: json["context"]?["title_placeholders"]?["serial"] ?? "no title",
      uniqueId: json["context"]?["unique_id"] ?? "no Unique Id",
      ip: json["context"]?["data"]?["ip_address"] ?? "no ip address",
    );
  }

  String brand;
  String flowid;
  String title;
  String uniqueId;
  String? ip;
}
