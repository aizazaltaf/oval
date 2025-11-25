import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/states/startup_state.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/config.dart';
import 'package:admin/core/heart_beat.dart';
import 'package:admin/main.dart';
import 'package:admin/models/data/ai_alert_preferences_model.dart';
import 'package:admin/models/data/plan_features_model.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/enums/environment.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/visitor_management/bloc/visitor_management_bloc.dart';
import 'package:admin/pages/main/voip/components/speaker.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/services/network_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/bottom_navigation_bar/motion_tab_bar_controller.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'startup_bloc.bloc.g.dart';

final _logger = Logger('startup_bloc.dart');

@BlocGen()
class StartupBloc extends BVCubit<StartupState, StartupStateBuilder>
    with _StartupBlocMixin {
  StartupBloc() : super(StartupState()) {
    initIsolate();
    if (config.environment == Environment.test) {
      callVersionApi();
      updateAppIsUpdated(true);
    } else {
      updateAppIsUpdated(true);
    }

    // else {
    //   updateAppIsUpdated(true);
    // }

    updateAppIsUpdated(true);
    initializeSocket();

    // if (singletonBloc.profileBloc.state != null) {
    //   callEverything();
    // }
    // _connectivity.onConnectivityChanged.listen(initConnectivity);
  }

  factory StartupBloc.of(final BuildContext context) =>
      BlocProvider.of<StartupBloc>(context);
  Isolate? _isolate;
  SendPort? _sendPort;
  final _receivePort = ReceivePort();

  void stop() {
    _sendPort?.send('stop');
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
  }

  // Future<void> initIsolate() async {
  //   try {
  //     if (_isolate != null) {
  //       return; // already running
  //     }
  //
  //     stop(); // stop previous isolate if any
  //
  //     final completer = Completer<SendPort>();
  //
  //     _receivePort.listen((message) {
  //       if (message is SendPort) {
  //         if (!completer.isCompleted) {
  //           completer.complete(message);
  //         }
  //       } else if (message is bool) {
  //         updateIsInternetConnected(message);
  //         singletonBloc.voipBloc?.updateIsInternetConnected(message);
  //         singletonBloc.isInternetConnected = message;
  //         _logger.info("Network Service $message");
  //       }
  //     });
  //
  //     _isolate = await Isolate.spawn(
  //       NetworkService.networkMonitor,
  //       _receivePort.sendPort,
  //     );
  //
  //     _sendPort = await completer.future;
  //
  //     // Start monitoring
  //     _sendPort?.send('start');
  //   } catch (e) {
  //     _logger.severe("Network Service $e");
  //   }
  // }
  Future<void> initIsolate() async {
    try {
      if (_isolate != null) {
        return; // already running
      }

      stop(); // stop previous isolate if any

      final completer = Completer<SendPort>();

      int consecutiveFailures = 0;
      bool lastConnectionState = true;

      _receivePort.listen((message) {
        if (message is SendPort) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
          return;
        }

        if (message is bool) {
          if (message) {
            // ✅ Got TRUE → immediately mark as connected
            consecutiveFailures = 0;
            if (!lastConnectionState) {
              updateIsInternetConnected(true);
              singletonBloc.voipBloc?.updateIsInternetConnected(true);
              singletonBloc.isInternetConnected = true;
              _logger.info("Network Service: Internet connected ✅");
            }
            lastConnectionState = true;
          } else {
            // ❌ Got FALSE → count failures
            consecutiveFailures++;

            if (consecutiveFailures >= 3 && lastConnectionState) {
              updateIsInternetConnected(false);
              singletonBloc.voipBloc?.updateIsInternetConnected(false);
              singletonBloc.isInternetConnected = false;
              _logger.warning("Network Service: Internet disconnected ❌");
              lastConnectionState = false;
            }
          }
        }
      });

      _isolate = await Isolate.spawn(
        NetworkService.networkMonitor,
        _receivePort.sendPort,
      );

      _sendPort = await completer.future;

      // Start monitoring
      _sendPort?.send('start');
    } catch (e, st) {
      _logger.severe("Network Service error: $e\n$st");
    }
  }

  final NetworkInfo _wifiInfo = NetworkInfo();
  String? lastBSSID;

  Future<void> initWifiInfo() async {
    try {
      lastBSSID = await _wifiInfo.getWifiBSSID();
    } catch (e) {
      _logger.fine('Could not get initial BSSID: $e');
    }
  }

  @override
  void $onUpdateIsInternetConnected() {
    if (state.isInternetConnected) {
      handleInternetReconnectionApis();
    }
  }

  void initializeSocket() {
    // final Socket socket = io(
    singletonBloc.socket = io(
      config.socketUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .setReconnectionDelay(1000) // Try reconnect every 1s
          .setReconnectionDelayMax(5000) // Up to 5s backoff
          .setTimeout(20000) // 20s connection timeout
          .enableForceNew() // Force new connection
          .enableReconnection() // ✅ allow reconnection
          .build(),
    );
    final heartbeatManager = HeartbeatManager(
      socket: singletonBloc.socket!,
      data: {
        'deviceId': 'abc123',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    // Connect the socket with improved error handling
    singletonBloc.socket!
      ..connect()
      ..onConnect((_) async {
        _logger.fine("Socket connected successfully");
        // disabled on command of Mahboob bhai
        // unawaited(EasyLoading.dismiss());

        heartbeatManager.startHeartbeat();
      })
      ..onDisconnect((data) {
        _logger.warning("Socket disconnected: $data");
        heartbeatManager.stopHeartbeat();
      })
      ..onerror((err) {
        _logger.severe("Socket error: $err");
        // Handle specific error types
        if (err.toString().contains('HandshakeException') ||
            err.toString().contains('SSL') ||
            err.toString().contains('TLS')) {
          _logger.severe("SSL/TLS error in socket connection: $err");
        }
      })
      ..onReconnectError((error) {
        _logger.warning("Socket reconnection error: $error");
      })
      ..onReconnectFailed((error) {
        _logger.severe("Socket reconnection failed: $error");
        // Attempt to reinitialize socket after a delay
        Future.delayed(const Duration(seconds: 5), () {
          if (singletonBloc.socket?.connected != true) {
            _logger.info("Attempting to reinitialize socket connection");
            disconnectAndDisposeSocket();
            initializeSocket();
          }
        });
      })
      ..onConnectError((data) {
        _logger.warning("Socket connection error: $data");
        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();

        // socket.connect(); // Try reconnecting on error
      });

    // singletonBloc.socket = socket;
  }

  bool isInternetConnectivity = true;

  // final Connectivity _connectivity = Connectivity();

  void disconnectAndDisposeSocket() {
    final socket = singletonBloc.socket;
    if (socket != null) {
      socket
        ..clearListeners() // remove all existing listeners
        ..disconnect()
        ..destroy(); // completely destroy the socket
    }
  }

  bool socketInitializing = false;

  Future<void> socketMethod({bool fromConnectivity = false}) async {
    if (socketInitializing) {
      return;
    }
    if (singletonBloc.voipBloc != null) {
      if (!singletonBloc.voipBloc!.state.enabledSpeakerInCall) {
        if (Platform.isAndroid) {
          unawaited(Helper.setSpeakerphoneOn(false));
        } else {
          unawaited(SpeakerphoneController.setSpeakerphoneOn(false));
        }
      }
    }
    socketInitializing = true;

    disconnectAndDisposeSocket();
    initializeSocket();
    await Future.delayed(const Duration(seconds: 1));
    singletonBloc.socket?.emit("joinRoom", {
      "room": singletonBloc.profileBloc.state?.selectedDoorBell?.locationId
          .toString(),
      "device_id": await CommonFunctions.getDeviceModel(),
    });
    socketInitializing = false;
    unawaited(singletonBloc.iotBloc?.socketListener());
    unawaited(
      singletonBloc.voipBloc?.socketListener(
        (navigatorKeyMain.currentState?.context.mounted ?? false)
            ? navigatorKeyMain.currentState!.context
            : navigatorKeyMain.currentState!.context,
      ),
    );

    if (fromConnectivity) {
      Future.delayed(const Duration(seconds: 2), () async {
        if (singletonBloc.voipBloc != null) {
          if (!(singletonBloc.voipBloc?.state.isCallConnected ?? true) &&
              !(singletonBloc.voipBloc?.state.isOnCallingScreen ?? true)) {
            unawaited(
              singletonBloc.socketEmitterWithAck(
                roomName: Constants.voip,
                deviceId: singletonBloc.voipBloc?.selectedDevice?.deviceId,
                request: Constants.notificationEndCall,
              ),
            );
          }
        }
        await socketListeners();
      });
    }
    await socketListeners();
  }

  String? sessionId;

  Future<void> socketListeners() async {
    sessionId ??= await CommonFunctions.getDeviceModel();
    singletonBloc.socket!.off(Constants.doorbell);
    singletonBloc.socket!.on(Constants.doorbell, (data) async {
      await Future.microtask(() {
        SocketRequestManager.handleResponse(data);
      });
    });
  }

  Future<void> handleInternetReconnectionApis() async {
    unawaited(socketMethod(fromConnectivity: true));
    // if (!state.isInternetConnected) {
    updateDashboardApiCalling(true);
    final oldDoorbellState = state.userDeviceModel ?? BuiltList();
    await Future.delayed(const Duration(seconds: 3), () async {
      await callEverything();
      final newDoorbellState = state.userDeviceModel ?? BuiltList();
      if (oldDoorbellState.isNotEmpty && newDoorbellState.isEmpty) {
        await callEverything();
      }
      await singletonBloc.iotBloc?.callIotApi();
    });
    await Future.delayed(const Duration(seconds: 5), () {
      updateDashboardApiCalling(false);
    });
    // updateIsInternetConnected(true);
    // }
  }

  Future<void> initConnectivity(
    List<ConnectivityResult> connectivityResult,
  ) async {
    if (!isInternetConnectivity) {
      isInternetConnectivity = true;
      return;
    }

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      await handleInternetReconnectionApis();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      await handleInternetReconnectionApis();
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      await handleInternetReconnectionApis();
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      await handleInternetReconnectionApis();
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      // updateIsInternetConnected(false);
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // updateIsInternetConnected(false);
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      singletonBloc.socket?.close();
      // singletonBloc.voipBloc?.updateIsInternetConnected(false);
      // updateIsInternetConnected(false);
    }
  }

  void oneTimeInitialize(TickerProvider tickerProvider) {
    updateMotionTabBarController(
      MotionTabBarController(length: 4, vsync: tickerProvider),
    );
  }

  void doorbellControlScreenInitialize() {
    emit(
      state.rebuild(
        (b) => b
          ..newDoorbellName = ''
          ..doorbellNameEdit = false,
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (singletonBloc.profileBloc.state != null) {
      await getUserDoorbells();
    }
  }

  void clearPageIndexes() {
    updateBottomNavIndexValues(<int>[0].toBuiltList());
    updateIndexedStackValue(0);
    state.motionTabBarController?.index = 0;
    updateMotionTabBarController(state.motionTabBarController);
  }

  void pageIndexChanged(int index) {
    updateIndexedStackValue(index);
    emit(state.rebuild((b) => b..bottomNavIndexValues.insert(0, index)));
    _logger.severe(state.bottomNavIndexValues);
    updateBottomNavIndexValues(state.bottomNavIndexValues);
    state.motionTabBarController?.index = index;
    updateMotionTabBarController(state.motionTabBarController);
  }

  Future<void> popIndexChanged(VisitorManagementBloc visitorBloc) async {
    emit(state.rebuild((b) => b..bottomNavIndexValues.removeAt(0)));
    updateIndexedStackValue(state.bottomNavIndexValues[0]);
    state.motionTabBarController?.index = state.bottomNavIndexValues[0];
    updateMotionTabBarController(state.motionTabBarController);

    _logger.severe(state.bottomNavIndexValues);
    updateBottomNavIndexValues(state.bottomNavIndexValues);
    if (state.motionTabBarController?.index == 1) {
      visitorBloc.removeSearch();
      if (visitorBloc.state.visitorManagementApi.data == null) {
        await visitorBloc.initialCall();
      } else if (visitorBloc.state.visitorManagementApi.data!.data.isEmpty) {
        await visitorBloc.initialCall();
      }
    }
    return;
  }

  Future<void> updateLightState(
    bool value,
    deviceId, {
    Map<String, dynamic>? message,
    bool isEdge = false,
  }) async {
    // unawaited(EasyLoading.show());
    Constants.showLoader();

    await CubitUtils.makeSocketCall<StartupState, StartupStateBuilder,
        Map<String, dynamic>>(
      cubit: this,
      apiState: state.doorbellOperation,
      updateApiState: (b, apiState) => b.doorbellOperation.replace(apiState),
      socket: singletonBloc.socket!,
      eventName: Constants.doorbell,
      responseEvent: isEdge
          ? Constants.doorbellEdgeLight
          : Constants.doorbellLuminousLight,
      command: isEdge
          ? Constants.doorbellEdgeLight
          : Constants.doorbellLuminousLight,
      message: message,
      onSuccess: (data) {
        if (data["status"] ?? false) {
          final updatedDevices = state.userDeviceModel!.rebuild((b) {
            for (int i = 0; i < b.length; i++) {
              final device = b[i];
              if (device.deviceId.toString() == deviceId.toString()) {
                b[i] = device.rebuild(
                  (d) => isEdge
                      ? d.edge = jsonDecode(data["data"])["switch"]
                      : d.flash = jsonDecode(data["data"])["switch"],
                );
                break;
              }
            }
          });
          emit(
            state.rebuild(
              (b) => b.userDeviceModel.replace(updatedDevices.toBuiltList()),
            ),
          );
        }
        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();
      },
      onError: (error) {
        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();
      },
    );
  }

  Future<BuiltList<UserDeviceModel>> getDoorbells({int? id}) async {
    int? locationId = id;
    String? selectedDoorbellDeviceId;

    locationId ??=
        singletonBloc.profileBloc.state?.selectedDoorBell?.locationId;
    selectedDoorbellDeviceId ??=
        singletonBloc.profileBloc.state?.selectedDoorBell?.deviceId;

    final userDoorbell = await apiService.getUserDoorbells(id: locationId);

    locationId ??= await apiService.getDefaultLocation();

    bool? isIdExist;
    bool? isSelectedDoorbellDeviceIdExist;
    // if (locationId != null) {
    isIdExist = userDoorbell.any(
      (device) => device.locationId == locationId && device.entityId == null,
    );
    if (!isIdExist) {
      locationId = userDoorbell.firstOrNull?.locationId;
      singletonBloc.socket?.emit(
        "leaveRoom",
        // singletonBloc.profileBloc.state!.locationId,
        singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
            .toString(),
      );
      singletonBloc.profileBloc.updateSelectedDoorBellToNull();
      singletonBloc.joinRoom = false;
    } else {
      isSelectedDoorbellDeviceIdExist = userDoorbell.any(
        (device) =>
            device.deviceId == selectedDoorbellDeviceId &&
            device.entityId == null,
      );
      if (!isSelectedDoorbellDeviceIdExist) {
        singletonBloc.socket?.emit(
          "leaveRoom",
          // singletonBloc.profileBloc.state!.locationId,
          singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
              .toString(),
        );
        singletonBloc.profileBloc.updateSelectedDoorBellToNull();
        singletonBloc.joinRoom = false;
      }
    }
    // }

    if (userDoorbell.isNotEmpty) {
      if (userDoorbell.length == 1) {
        singletonBloc.profileBloc.updateSelectedDoorBell(userDoorbell[0]);
        updateRole(userDoorbell[0]);
      }
      if (singletonBloc.profileBloc.state?.selectedDoorBell != null &&
          locationId == null) {
        locationId =
            singletonBloc.profileBloc.state?.selectedDoorBell!.locationId;
        // singletonBloc.profileBloc.updateLocationId(locationId.toString());
        updateRole(singletonBloc.profileBloc.state!.selectedDoorBell!);
      }
      if (locationId == null) {
        singletonBloc.profileBloc.updateSelectedDoorBell(
          userDoorbell.firstWhere((e) => e.isDefault == 1),
        );
        updateRole(userDoorbell.first);
      } else {
        for (final e in userDoorbell) {
          if (e.locationId == locationId) {
            singletonBloc.profileBloc.updateSelectedDoorBell(
              userDoorbell.firstWhere(
                (e) => e.isDefault == 1 && e.locationId == locationId,
              ),
            );
            updateRole(e);
            break;
          }
          continue;
        }
      }
      updateIsDoorbellConnected(true);
    } else {
      updateIsDoorbellConnected(false);
    }
    updateUserDeviceModel(userDoorbell);
    // if (locationId != null && !singletonBloc.joinRoom) {
    if (!singletonBloc.joinRoom) {
      singletonBloc.socket?.emit("joinRoom", {
        // "room": singletonBloc.profileBloc.state!.locationId,
        "room": singletonBloc.profileBloc.state!.selectedDoorBell?.locationId
            .toString(),
        "device_id": await CommonFunctions.getDeviceModel(),
      });

      singletonBloc.joinRoom = true;
    }

    // singletonBloc.profileBloc.initializeSocket();

    return userDoorbell;
  }

  void updateRole(UserDeviceModel model) {
    final String role = singletonBloc.profileBloc.state!.locations!
        .singleWhere((e) => e.id == model.locationId)
        .roles[0];
    singletonBloc.profileBloc.updateUserRole(role);
  }

  Future<void> updateMonitorCamerasSnapshots() async {
    try {
      final response = await apiService.updateSnapshots();
      if (response) {
        updateDoorbellImageVersion(state.doorbellImageVersion + 1);
        updateRefreshSnapshots(!state.refreshSnapshots);
      }
    } catch (e) {
      // exp
    }
  }

  Future<void> callEditDoorbellName({required String deviceId}) async {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.editDoorbellNameApi,
      updateApiState: (final b, final apiState) =>
          b.editDoorbellNameApi.replace(apiState),
      callApi: () async {
        final response = await apiService.editDoorbellName(
          deviceId: deviceId,
          name: state.newDoorbellName.trim(),
        );
        if (response.data["success"] == true) {
          ToastUtils.successToast(response.data["message"]);

          unawaited(callEverything());
        } else {
          ToastUtils.errorToast(response.data["message"]);
        }
      },
      onError: (final e) async {
        if (e is DioException && e.response != null) {
          ToastUtils.errorToast(e.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
    );
  }

  Future<void> callReleaseDoorbell({
    required int doorbellId,
    required VoidCallback successFunction,
    required VoidCallback successReleaseToast,
  }) {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.releaseDoorbellApi,
      updateApiState: (final b, final apiState) =>
          b.releaseDoorbellApi.replace(apiState),
      callApi: () async {
        await apiService.releaseDoorbell(doorbellId);
        successFunction.call();
        successReleaseToast.call();
      },
      onError: (final e) async {
        if (e is DioException && e.response != null) {
          ToastUtils.errorToast(e.response!.data["message"]);
        } else {
          ToastUtils.errorToast("An unexpected error occurred.");
        }
      },
    );
  }

  bool isInternetCheck = false;

  Future<void> callEverything({int? id, bool isDismiss = true}) async {
    await callUserDetails(id: id);
    await getUserDoorbells(id: id);
    await callPlanFeaturesManagement();
    // if (isDismiss) {
    // await EasyLoading.dismiss();
    // Constants.dismissLoader();
    // }
  }

  Future<void> callPlanFeaturesManagement() async {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.planFeaturesApi,
      dismissLoaderOnApiFail: false,
      updateApiState: (final b, final apiState) =>
          b.planFeaturesApi.replace(apiState),
      callApi: () async {
        if (singletonBloc.profileBloc.state != null) {
          final planFeaturesList = await apiService.getPlanFeatures();
          singletonBloc.profileBloc.updatePlanFeaturesList(planFeaturesList);
        }
      },
      onError: (final e) async {
        _logger.fine("plan feature api issue: $e");
        if (e is DioExceptionType && e == DioExceptionType.connectionError) {
          return;
        }
        if (e is DioException && e.response?.statusCode == 404) {
          singletonBloc.profileBloc
              .updatePlanFeaturesList(BuiltList<PlanFeaturesModel>());
        }
      },
    );
  }

  Future<void> callUserDetails({int? id}) async {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.everythingApi,
      updateApiState: (final b, final apiState) =>
          b.everythingApi.replace(apiState),
      callApi: () async {
        if (singletonBloc.profileBloc.state != null) {
          final UserData userDetail = await apiService.getUserDetail();
          final UserDeviceModel? doorbell =
              singletonBloc.profileBloc.state!.selectedDoorBell;

          singletonBloc.profileBloc.updateProfile(
            userDetail.rebuild(
              (b) => b

                ///before cursor
                ///..locationId = id.toString()
                ///after cursor
                // ..locationId = id == null ? b.locationId : id.toString()
                ..planFeaturesList = singletonBloc
                    .profileBloc.state?.planFeaturesList
                    ?.toBuilder()
                ..apiToken = singletonBloc.profileBloc.state!.apiToken
                ..refreshToken = singletonBloc.profileBloc.state!.refreshToken,
            ),
          );
          if (doorbell != null) {
            singletonBloc.profileBloc.updateProfile(
              userDetail.rebuild(
                (b) => b
                  ..selectedDoorBell.replace(doorbell)
                  ..planFeaturesList = singletonBloc
                      .profileBloc.state?.planFeaturesList
                      ?.toBuilder()
                  // ..locationId = id.toString()
                  ..apiToken = singletonBloc.profileBloc.state!.apiToken
                  ..refreshToken =
                      singletonBloc.profileBloc.state!.refreshToken,
              ),
            );
          }
        }
        return;
      },
      onError: (final e) async {
        // if (e is DioException) {
        //   _logger.severe('callEverything: $e');
        // emit(state.rebuild((final b) => b..userDeviceModel.replace([])));
        // }
      },
    );
  }

  void updateStreamingStatus({
    required String targetDeviceId,
    required int isStreaming,
  }) {
    if (state.userDeviceModel != null) {
      final updatedDevices = state.userDeviceModel!.rebuild((b) {
        for (int i = 0; i < b.length; i++) {
          final device = b[i];
          if (device.deviceId == targetDeviceId ||
              device.callUserId == targetDeviceId ||
              device.entityId == targetDeviceId) {
            b[i] = device.rebuild((d) => d..isStreaming = isStreaming);
            break;
          }
        }
      });
      emit(
        state.rebuild(
          (b) => b.userDeviceModel.replace(updatedDevices.toBuiltList()),
        ),
      );
    }
  }

  Future<void> getUserDoorbells({int? id}) async {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder,
        BuiltList<UserDeviceModel>>(
      cubit: this,
      apiState: state.doorbellApi,
      updateApiState: (final b, final apiState) =>
          b.doorbellApi.replace(apiState),
      callApi: () async {
        return getDoorbells(id: id);
      },
      onError: (final error) async {
        _logger.fine("Doorbell api: $error");
        if (error == DioExceptionType.connectionError) {
          return;
        } else if (error == DioExceptionType.receiveTimeout ||
            error == DioExceptionType.connectionTimeout) {
          return;
        } else if (error is DioException && error.response?.statusCode == 404) {
          emit(state.rebuild((final b) => b..userDeviceModel.replace([])));
          singletonBloc.socket?.emit(
            "leaveRoom",
            // singletonBloc.profileBloc.state!.locationId,
            singletonBloc.profileBloc.state?.selectedDoorBell?.locationId
                .toString(),
          );
          singletonBloc.profileBloc.updateSelectedDoorBellToNull();
          singletonBloc.joinRoom = false;
          singletonBloc.profileBloc.updateUserRole(null);
        }
      },
    );
  }

  Future<void> callUpdateGuide({required String guideKey}) async {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.setGuideApi,
      updateApiState: (final b, final apiState) =>
          b.setGuideApi.replace(apiState),
      callApi: () async {
        await apiService.setGuide(guideKey: guideKey);
        await callUserDetails();
      },
    );
  }

  Future<void> callVersionApi() {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.versionApi,
      updateApiState: (final b, final apiState) =>
          b.versionApi.replace(apiState),
      onError: (e) {
        updateSplashEnd(true);
        updateAppIsUpdated(true);
        _logger.fine(e);
      },
      callApi: () async {
        final data = await apiService.getVersionApi();
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();

        final String version = packageInfo.version; // e.g., "1.0.0"
        final String buildNumber = packageInfo.buildNumber; // e.g., "5"

        if (data == "$version+$buildNumber") {
          updateAppIsUpdated(true);
        } else {
          updateSplashEnd(true);
          updateAppIsUpdated(true);
          ToastUtils.errorToast(
            "Kindly update the app",
            duration: const Duration(hours: 10),
            close: false,
          );
        }
      },
    );
  }

  BuiltList<AiAlertPreferencesModel> temporaryAiAlertPreferencesList =
      BuiltList([]);

  void setTempAiAlertPreferencesList() {
    emit(
      state.rebuild(
        (e) =>
            e.aiAlertPreferencesList.replace(temporaryAiAlertPreferencesList),
      ),
    );
  }

  Future<void> getAiAlertPreferences(String uuid, bool isCamera) async {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.aiAlertPreferencesApi,
      updateApiState: (final b, final apiState) =>
          b.aiAlertPreferencesApi.replace(apiState),
      callApi: () async {
        final list = await apiService.getAiAlertPreferences(uuid, isCamera);
        temporaryAiAlertPreferencesList = list;
        updateAiAlertPreferencesList(list);
      },
    );
  }

  Future<void> refreshAiAlertPreferences(String uuid, bool isCamera) async {
    final list = await apiService.getAiAlertPreferences(uuid, isCamera);
    temporaryAiAlertPreferencesList = list;
    updateAiAlertPreferencesList(list);
  }

  String updatePlacement(String jsonString, String newPlacement) {
    // Decode the JSON string into a Map
    final Map<String, dynamic> obj = jsonDecode(jsonString);

    // Replace the placement value
    obj['placement'] = newPlacement;

    // Encode it back to a JSON string
    return jsonEncode(obj);
  }

  Future editPlacementCamera(
    String? selectedFormPosition,
    int id,
    BuildContext context,
  ) {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.editCameraDevice,
      updateApiState: (final b, final apiState) =>
          b.editCameraDevice.replace(apiState),
      onError: (e) {
        _logger.severe(e.toString());
      },
      callApi: () async {
        final bool status =
            await apiService.editCameraPlacement(selectedFormPosition, id);
        if (status) {
          if (context.mounted) {
            final updatedDevices = state.userDeviceModel!.rebuild((b) {
              for (int i = 0; i < b.length; i++) {
                final device = b[i];
                if (device.id.toString() == id.toString()) {
                  b[i] = device.rebuild(
                    (d) => d.details =
                        updatePlacement(d.details!, selectedFormPosition!),
                  );
                  break;
                }
              }
            });
            emit(
              state.rebuild(
                (b) => b.userDeviceModel.replace(updatedDevices.toBuiltList()),
              ),
            );
            Navigator.pop(context);
          }
        }
      },
    );
  }

  Future<void> enableAiAlertPreferences(
    BuildContext context,
    UserDeviceModel device,
    bool isCamera,
  ) async {
    return CubitUtils.makeApiCall<StartupState, StartupStateBuilder, void>(
      cubit: this,
      apiState: state.updateApiAlertPreferencesApi,
      updateApiState: (final b, final apiState) =>
          b.updateApiAlertPreferencesApi.replace(apiState),
      callApi: () async {
        await apiService.updateAiAlertPreferences(
          id: device.id,
          isCamera: isCamera,
          aiAlertPreferences: state.aiAlertPreferencesList,
        );
        if (context.mounted) {
          Navigator.pop(context);
        }
        ToastUtils.successToast("Notification Settings Updated successfully.");
        unawaited(refreshAiAlertPreferences(device.callUserId, isCamera));
      },
      onError: (final e) async {
        ToastUtils.errorToast("Notification Settings could not be updated.");
      },
    );
  }
}
