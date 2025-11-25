import 'dart:async';
import 'dart:convert';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/pages/main/dashboard/doorbell_controls_page.dart';
import 'package:admin/pages/main/iot_devices/add_device_form.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/ptz_control.dart';
import 'package:admin/pages/main/voip/components/remote_render_widget.dart';
import 'package:admin/pages/main/voip/streaming_components/recorded_stream_player.dart';
import 'package:admin/pages/main/voip/streaming_components/video_scroller.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger('streaming_page.dart');

class StreamingPage extends StatefulWidget {
  const StreamingPage._({
    required this.callUserId,
    required this.doorbellId,
    this.date,
    this.imageValue,
    this.alertId,
  });

  final String callUserId;
  final int doorbellId;
  final DateTime? date;
  final Uint8List? imageValue;
  final int? alertId;

  static const routeName = 'streamingPage';

  static Future<void> push(
    final BuildContext context,
    String callUserId,
    int doorbellId, {
    final DateTime? date,
    Uint8List? imageValue,
    int? alertId,
  }) {
    final bloc = VoipBloc.of(context);
    bloc.streamingPeerConnection?.dispose();
    bloc
      ..streamingPeerConnection = null
      ..updateRemote(null);

    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => StreamingPage._(
        callUserId: callUserId,
        doorbellId: doorbellId,
        imageValue: imageValue,
        date: date,
        alertId: alertId,
      ),
    ).then((_) {
      if (context.mounted) {
        // SpeechRecognition.instance.initSpeechState(context);
      }
    });
  }

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage>
    with AutomaticKeepAliveClientMixin {
  late VoipBloc voipBloc;

  @override
  void initState() {
    WakelockPlus.enable();
    voipBloc = VoipBloc.of(context);
    StartupBloc.of(context).socketMethod();
    voipBloc
          ..updateEnabledSpeakerInCall(false)
          ..updateEnableCameraControls(false)
        // ..updateIsInternetConnected(true)
        ;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(initConnectivity);
    final UserDeviceModel device = StartupBloc.of(context)
        .state
        .userDeviceModel!
        .firstWhere((e) => e.callUserId == widget.callUserId);
    voipBloc.updateThumbnailImage(device.image);
    if (device.entityId == null) {
      voipBloc.socketListener(context);
    }
    initializeVoip(context, device);
    WidgetsBinding.instance.addPostFrameCallback((w) {
      final iotBloc = IotBloc.of(context)
        ..updateCanOpenBottomSheetFormOnStreaming(true);
      if (device.isExternalCamera ?? false) {
        iotBloc.getAllFlowIds(
          ip: jsonDecode(device.details ?? "")['ip_address'],
          name: device.name,
          successForm: () {
            iotBloc.updateNewFormDataDeviceName(
              device.name,
            );
            if (iotBloc.state.canOpenBottomSheetFormOnStreaming &&
                context.mounted) {
              AddDeviceForm.push(
                context,
                fromCamera: true,
                onSuccess: () async {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  await Future.delayed(const Duration(seconds: 5));
                  unawaited(
                    iotBloc.getDeviceConfigurations(
                      device.entityId,
                      device.callUserId,
                    ),
                  );
                  await Future.delayed(const Duration(seconds: 3));

                  // ignore: use_build_context_synchronously
                  // unawaited(initializeVoip(context, device));
                },
              );
            }
          },
          success: () {},
        );
      }
    });
    super.initState();
  }

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  void callingReconnect(device) {
    if (!voipBloc.state.isCallConnected) {
      Future.delayed(const Duration(seconds: 2), () {
        final navigatorState = singletonBloc.navigatorKey?.currentState;
        if (navigatorState != null) {
          final context = navigatorState.context;
          try {
            if (context.mounted) {
              unawaited(
                voipBloc.attemptReconnection(
                  context,
                  device.isExternalCamera,
                  widget.callUserId,
                  fromStreaming: true,
                ),
              );
            }
          } catch (e) {
            logger.fine("Failed to reconnect call");
          }
        }
      });
    }
  }

  String? _lastSsid;

  Future<void> detectNetworkChange(BuildContext context) async {
    try {
      if (context.mounted) {
        final wifiName = await voipBloc.wifiInfo.getWifiBSSID();
        if (wifiName != null && wifiName != _lastSsid) {
          logger.fine('Wi-Fi changed: $_lastSsid ➡️ $wifiName');
          _lastSsid = wifiName;

          if (voipBloc.state.isCallConnected) {
            unawaited(voipBloc.callingPeerConnection?.close());
            unawaited(voipBloc.callingPeerConnection?.dispose());
            unawaited(voipBloc.streamingPeerConnection?.close());
            unawaited(voipBloc.streamingPeerConnection?.dispose());
            voipBloc.callingPeerConnection = null;

            await voipBloc.createCall(
              context.mounted ? context : context,
              fromStreaming: true,
              isExternalCamera: true,
              isStreaming: true,
              isNetworkSwitch: true,
              callUserId: widget.callUserId,
              callType: voipBloc.state.isCameraOnStreamEnabled
                  ? Constants.doorbellVideoCall
                  : Constants.silentDoorbellAudioCall,
            );
          } else {
            final UserDeviceModel device = StartupBloc.of(
              context.mounted ? context : context,
            )
                .state
                .userDeviceModel!
                .firstWhere((e) => e.callUserId == widget.callUserId);
            callingReconnect(device);
          }
        }
      }
    } catch (e) {
      logger.fine('Failed to get Wi-Fi SSID: $e');
    }
    voipBloc.lastBSSID = _lastSsid;
  }

  Future<void> initConnectivity(
    List<ConnectivityResult> connectivityResult,
  ) async {
    if (!voipBloc.isVoipInitialized) {
      return;
    }

    try {
      final navigatorState = singletonBloc.navigatorKey?.currentState;
      if (navigatorState != null) {
        final context = navigatorState.context;
        if (context.mounted) {
          final bloc = VoipBloc.of(context);
          final UserDeviceModel? device = StartupBloc.of(context)
              .state
              .userDeviceModel
              ?.firstWhereOrNull((e) => e.callUserId == widget.callUserId);
          if (device == null) {
            return;
          }
          if (connectivityResult.contains(ConnectivityResult.mobile)) {
            singletonBloc.socket?.connect();
            if (bloc.streamingPeerConnection == null) {
              callingReconnect(device);
            } else {
              unawaited(detectNetworkChange(context));
            }
            // bloc.updateIsInternetConnected(true);
          } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
            // singletonBloc.socket?.connect();
            if (bloc.streamingPeerConnection == null) {
              callingReconnect(device);
            } else {
              unawaited(detectNetworkChange(context));
            }
            // unawaited(signalingClient?.connect(context));
            // bloc.updateIsInternetConnected(true);
          } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
            // singletonBloc.socket?.connect();
            if (bloc.streamingPeerConnection == null) {
              callingReconnect(device);
            } else {
              unawaited(detectNetworkChange(context));
            }
            // unawaited(signalingClient?.connect(context));
            // bloc.updateIsInternetConnected(true);
          } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
            // singletonBloc.socket?.connect();
            if (bloc.streamingPeerConnection == null) {
              callingReconnect(device);
            } else {
              unawaited(detectNetworkChange(context));
            }
            // unawaited(signalingClient?.connect(context));
            // bloc.updateIsInternetConnected(true);
          } else if (connectivityResult
              .contains(ConnectivityResult.bluetooth)) {
            // Bluetooth connection available.
          } else if (connectivityResult.contains(ConnectivityResult.other)) {
          } else if (connectivityResult.contains(ConnectivityResult.none)) {
            if (!bloc.state.isCallConnected) {
              bloc
                    ..updateRemote(null)
                    ..updateIsStreamReconnecting(true)
                  // ..updateIsInternetConnected(false)
                  ;

              await bloc.streamingPeerConnection?.close();
              await bloc.callingPeerConnection?.close();
              await bloc.streamingPeerConnection?.dispose();
              await bloc.callingPeerConnection?.dispose();
              bloc
                ..callingPeerConnection = null
                ..streamingPeerConnection = null;
            } else {
              bloc.updateIsStreamReconnecting(true);
              // ..updateIsInternetConnected(false);
            }
          }
        }
      }
    } catch (e) {
      _logger.fine("Failed to init connectivity in streamingPage");
    }
  }

  Future<void> initializeVoip(
    BuildContext context,
    UserDeviceModel device,
  ) async {
    voipBloc = VoipBloc.of(context);
    if (widget.date == null) {
      await voipBloc.initializeRenders();
      voipBloc.isVoipInitialized = true;
      if (context.mounted) {
        await voipBloc.initiateVoipWithDoorBell(
          context.mounted ? context : context,
          widget.callUserId,
          fromStreaming: true,
          isStreaming: true,
        );
      }
    } else {
      await voipBloc.getStartUpApis(StartupBloc.of(context), widget.callUserId);
    }
  }

  @override
  void dispose() {
    // Fire-and-forget teardown in case the page is removed programmatically.
    // _logger.fine('StreamingPage.dispose → tearing down stream.');
    // unawaited(voipBloc.endStreamingCall(context));
    callDisposeItems();
    WakelockPlus.disable();
    _connectivitySubscription.cancel();
    FlutterForegroundTask.stopService();
    voipBloc
      ..imageTimer?.cancel()
      ..remoteTimer?.cancel()
      ..poorInternetCount = 0
      ..updateIsLiveModeActivated(true)
      ..updateIsFullScreen(false)
      ..updateIsLiveStreamAvailable(false)
      ..updateIsPoorInternet(true)
      ..updateIsRecordedStreamLoading(false)
      ..updateIsLiveStreamingLoading(true);

    super.dispose();
  }

  void callDisposeItems() {
    Future.delayed(const Duration(seconds: 1), () {
      voipBloc
            ..imageTimer?.cancel()
            ..updateState()
            ..updateThumbnailImage(null)
            ..updateIsReconnecting(false)
            ..updateIsStreamReconnecting(false)
            ..updateIsPoorInternet(false)
          // ..toggleSpeaker(isEnable: true)
          // ..updateIsInternetConnected(true)
          ;
    });
  }

  Future<void> exitFullscreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  Map<String, dynamic>? subDevices;

  List<dynamic>? subDevicesEntities;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final startupBloc = StartupBloc.of(context);

    return StartupBlocSelector.userDeviceModel(
      builder: (model) {
        final UserDeviceModel? device =
            model!.firstWhereOrNull((e) => e.callUserId == widget.callUserId);
        if (device == null) {
          return const SizedBox.shrink();
        }

        return PopScope(
          onPopInvokedWithResult: (_, __) async {
            // Mute immediately, then grab the last frame before tearing the stream down.
            _logger.fine(
              'PopScope → closing live stream for ${widget.callUserId}.',
            );
            voipBloc.removeStreamRemoteAudio();
            await voipBloc.imageSend(
              widget.callUserId,
              canNull: true,
              startupBloc: startupBloc,
            );
            if (context.mounted) {
              await voipBloc.endStreamingCall(context);
            }
            unawaited(exitFullscreen());
          },
          child: VoipBlocSelector.isFullScreen(
            builder: (isFullScreen) {
              // if (isFullScreen) {
              // return VoipBlocSelector.remoteRenderer(
              //   builder: (remoteRenderer) {
              //     if (remoteRenderer != null) {
              //       return SizedBox(
              //         width: MediaQuery.of(context).size.width,
              //         height: MediaQuery.of(context).size.height,
              //         child: Stack(
              //           children: [
              //             RTCVideoView(
              //               remoteRenderer,
              //               objectFit: RTCVideoViewObjectFit
              //                   .RTCVideoViewObjectFitCover,
              //             ),
              //             Positioned(
              //               top: 05,
              //               right: 0,
              //               child: SafeArea(
              //                 child: DecoratedBox(
              //                   decoration: const BoxDecoration(
              //                     color: Colors.black26,
              //                     shape: BoxShape.circle,
              //                   ),
              //                   child: IconButton(
              //                     onPressed: () {
              //                       voipBloc.updateIsFullScreen(false);
              //                       exitFullscreen();
              //                     },
              //                     icon: const Icon(
              //                       Icons.fullscreen_exit,
              //                       color: Colors.white,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //     return const SizedBox.shrink();
              //   },
              // );
              // }
              return AppScaffold(
                appTitle: device.name,
                leading: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    // top: height * 0.01,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          // Mirror the PopScope cleanup when the user taps the close icon.
                          // _logger.fine(
                          //   'Close button tapped → shutting down stream for ${widget.callUserId}.',
                          // );
                          // voipBloc.removeStreamRemoteAudio();
                          // await voipBloc.imageSend(
                          //   widget.callUserId,
                          //   canNull: true,
                          //   startupBloc: startupBloc,
                          // );
                          // if (context.mounted) {
                          //   await voipBloc.endStreamingCall(context);
                          // }
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).tabBarTheme.indicatorColor,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                appBarAction: [
                  Padding(
                    padding: EdgeInsets.only(
                      // top: height * 0.01,
                      right: width * 0.06,
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        voipBloc.removeStreamRemoteAudio();
                        // if (device.isExternalCamera ?? false) {
                        //   CameraSettingsPage.push(
                        //     context,
                        //     widget.doorbellId,
                        //   ).then((_) {
                        //     if (voipBloc.state.enabledSpeakerInStream) {
                        //       voipBloc.resumeRemoteAudio();
                        //     }
                        //   });
                        // } else {
                        DoorbellControlsPage.push(
                          context,
                          widget.doorbellId,
                          isCamera: device.isExternalCamera ?? false,
                        ).then((_) {
                          if (voipBloc.state.enabledSpeakerInStream) {
                            voipBloc.resumeRemoteAudio();
                          }
                        });
                        // }
                      },
                      child: Icon(
                        CupertinoIcons.gear_big,
                        color: Theme.of(context).tabBarTheme.indicatorColor,
                        size: 26,
                      ),
                    ),
                  ),
                ],
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: height * 0.02),
                          SizedBox(height: height * 0.01),
                          Column(
                            children: [
                              SizedBox(height: height * 0.01),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    VoipBlocSelector.isLiveModeActivated(
                                      builder: (isLiveModeActivated) {
                                        if (isLiveModeActivated) {
                                          return RemoteRenderWidget(
                                            deviceName: device.name ?? "",
                                            fromLiveStreaming: true,
                                            callUserId: widget.callUserId,
                                            isExternalCamera:
                                                device.isExternalCamera ??
                                                    false,
                                            device: device,
                                            imageValue: widget.imageValue,
                                          );
                                        }
                                        return RecordedStreamPlayer(
                                          callUserId: widget.callUserId,
                                          device: device,
                                          imageValue: widget.imageValue,
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      child:
                                          VoipBlocSelector.isLiveModeActivated(
                                        builder: (isLiveModeActivated) {
                                          if (isLiveModeActivated) {
                                            return const SizedBox.shrink();
                                          }
                                          return Image.asset(
                                            DefaultImages.STREAM_LOGO,
                                            width: 60,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          VoipBlocSelector.enableCameraControls(
                            builder: (isActive) {
                              if (isActive) {
                                return IotBlocSelector.allDevicesWithSubDevices(
                                  builder: (data) {
                                    if (data != null) {
                                      final List<dynamic> decodedJson =
                                          jsonDecode(
                                        data.isEmpty ? "[]" : data,
                                      );
                                      subDevices = decodedJson.firstWhereOrNull(
                                        (e) =>
                                            e['entity_id'] == device.entityId,
                                      );
                                      subDevicesEntities =
                                          subDevices?["entities"];
                                      subDevicesEntities =
                                          subDevicesEntities?.where((
                                        subDevices,
                                      ) {
                                        return CommonFunctions
                                            .containsAnyFromList(
                                          subDevices['entity_id'],
                                        );
                                      }).toList();
                                    }

                                    return PtzControl(
                                      entityIdUp:
                                          subDevicesEntities?.firstWhereOrNull((
                                        subDevices,
                                      ) {
                                        return CommonFunctions.up(
                                          subDevices['entity_id'],
                                        );
                                      })['entity_id'],
                                      entityIdDown:
                                          subDevicesEntities?.firstWhereOrNull((
                                        subDevices,
                                      ) {
                                        return CommonFunctions.down(
                                          subDevices['entity_id'],
                                        );
                                      })['entity_id'],
                                      entityIdLeft:
                                          subDevicesEntities?.firstWhereOrNull((
                                        subDevices,
                                      ) {
                                        return CommonFunctions.left(
                                          subDevices['entity_id'],
                                        );
                                      })['entity_id'],
                                      entityIdRight:
                                          subDevicesEntities?.firstWhereOrNull((
                                        subDevices,
                                      ) {
                                        return CommonFunctions.right(
                                          subDevices['entity_id'],
                                        );
                                      })['entity_id'],
                                    );
                                  },
                                );
                              }
                              return VideoScroller(
                                callUserId: widget.callUserId,
                                device: device,
                                alertId: widget.alertId,
                                isExternalCamera:
                                    device.isExternalCamera ?? false,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  //  implement wantKeepAlive
  bool get wantKeepAlive => true;
}
