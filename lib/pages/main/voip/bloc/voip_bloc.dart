import 'dart:io';
import 'dart:math' as math;

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/app_restrictions.dart';
import 'package:admin/core/config.dart';
import 'package:admin/core/images.dart';
import 'package:admin/core/services.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/main.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_state.dart';
import 'package:admin/pages/main/voip/call_screen.dart';
import 'package:admin/pages/main/voip/components/speaker.dart';
import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
import 'package:admin/pages/main/voip/signaling/signaling_client.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/app_colors.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:admin/widgets/custom_button.dart';
import 'package:admin/widgets/custom_date_picker.dart';
import 'package:built_collection/built_collection.dart';
import 'package:callkeep/callkeep.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'voip_bloc.bloc.g.dart';

final _logger = Logger('voip_bloc.dart');

@BlocGen()
class VoipBloc extends BVCubit<VoipState, VoipStateBuilder>
    with _VoipBlocMixin, Services {
  VoipBloc() : super(VoipState()) {
    initWifiInfo();
    // _setupPip();
  }

  factory VoipBloc.of(final BuildContext context) =>
      BlocProvider.of<VoipBloc>(context);
  StreamSubscription<dynamic>? streamSubscription;
  Widget? scrollWidget;
  List<Map<String, dynamic>> iceServers = [];
  VideoPlayerController? videoController;
  RTCPeerConnection? streamingPeerConnection;
  RTCPeerConnection? callingPeerConnection;
  Timer? callingTimer;
  // List<RTCIceCandidate> iceCandidate = [];
  List<RTCIceCandidate> pendingCandidates = [];
  MediaStream? localStream;
  RTCRtpTransceiver? _videoTransceiver;
  RTCRtpTransceiver? _audioTransceiver;
  double widthLocalView = 0;
  double heightLocalView = 0;
  RTCVideoRenderer? localRenderer;
  RTCVideoRenderer? remoteRenderer;
  UserDeviceModel? selectedDevice;
  bool isVoipInitialized = false;
  Timer? statsTimer;

  // M3U8 time mapping for accurate synchronization
  M3U8TimeMapping? m3u8TimeMapping;
  List<M3U8Second> timestampList = [];

  Future<void> initiateVoipWithDoorBell(
    BuildContext context,
    String callUserId, {
    bool fromStreaming = false,
    bool isStreaming = false,
    bool isExternalCamera = false,
  }) async {
    final bloc = StartupBloc.of(navigatorKeyMain.currentState!.context);
    // if (fromStreaming == false) {
    if (bloc.state.userDeviceModel == null ||
        bloc.state.userDeviceModel!.isEmpty) {
      unawaited(getStartUpApis(bloc, callUserId));
    } else {
      updateDoorBells(bloc.state.userDeviceModel!, callUserId);
    }
    singletonBloc.profileBloc.updateStreamingId(callUserId);
    await initializeConnection(
      context,
      callUserId,
      isExternalCamera,
      fromStreaming,
      isStreaming,
    );
  }

  Future<void> initiateImplementation(
    context,
    callUserId, {
    bool fromStreaming = false,
    bool isNetworkSwitch = false,
    required String callType,
  }) async {
    if (callingPeerConnection == null) {
      if (Platform.isAndroid) {
        unawaited(_startService(callUserId));
      }
      if (isNetworkSwitch) {
        unawaited(localStream?.dispose());
        localStream = null;
      }
      await createPeerConnectionMethod(
        context,
        fromStreaming: fromStreaming,
        callType: callType,
      );
      unawaited(
        createCallingOffer(
          isNetworkSwitch ? Constants.networkSwitch : callType,
          context,
          fromStreaming: fromStreaming,
        ),
      );
    }
  }

  Future<void> listenToSensor() async {
    if (Platform.isAndroid) {
      await ProximitySensor.setProximityScreenOff(true);
    }
    streamSubscription = ProximitySensor.events.listen((event) {});
  }

  Timer? callingEndTimer;
  String? sessionId;
  // final pip = Pip();
  // Future<void> _setupPip() async {
  //   const options = PipOptions(
  //     autoEnterEnabled: true, // Enable/disable auto-enter PiP mode
  //     // Android specific options
  //     aspectRatioX: 9, // Aspect ratio X value
  //     aspectRatioY: 16, // Aspect ratio Y value
  //     sourceRectHintLeft: 0, // Source rectangle left position
  //     sourceRectHintTop: 0, // Source rectangle top position
  //     sourceRectHintRight: 1080, // Source rectangle right position
  //     sourceRectHintBottom: 720, // Source rectangle bottom position
  //     // iOS specific options
  //     sourceContentView: 1, // Source content view
  //     contentView: 1, // Content view to be displayed in PiP
  //     preferredContentWidth: 480, // Preferred content width
  //     preferredContentHeight: 270, // Preferred content height
  //     controlStyle: 2, // Control style for PiP window
  //   );
  //
  //   await pip.setup(options);
  // }

  Future<void> socketListener(BuildContext context) async {
    sessionId ??= await CommonFunctions.getDeviceModel();
    final SignalingClient signalingClient = SignalingClient(this);
    singletonBloc.socket?.off(Constants.signaling);
    singletonBloc.socket?.on(Constants.signaling, (data) async {
      /// REMARKS: Mahboob change remove session Id
      // final session = data[Constants.sessionId];
      // if (session == sessionId) {
      if (data["data"] is String) {
        SocketRequestManager.handleResponse(data);
      } else {
        final json = data["data"];
        if (json == null) {
          return;
        }
        if (json["target"] == singletonBloc.profileBloc.state!.callUserId) {
          switch (json["type"]) {
            case "end_call":
              await stopService();
              unawaited(
                signalingClient.handleEndCall(
                  json,
                  context.mounted ? context : context,
                ),
              );
            case "candidate":
              unawaited(signalingClient.handleCandidate(json));
            case "answer":
              final sessionId = await CommonFunctions.getDeviceModel();
              // _logger.fine("sessionId : $sessionId");
              // _logger.fine("sessionId from : ${data["session_id"]}");
              if (data["session_id"] == sessionId) {
                _logger.fine("Candidate : Answer $json");
                callingEndTimer?.cancel();
                if (json["status"] == false) {
                  emit(
                    state.rebuild(
                      (final b) => b
                        ..isMicrophoneOnStreamEnabled = false
                        ..isCameraOnStreamEnabled = false,
                    ),
                  );
                  if (state.isOnCallingScreen) {
                    updateCallValue("Doorbell is busy");
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context.mounted ? context : context);
                    });
                  } else {
                    // unawaited(EasyLoading.dismiss());
                    Constants.dismissLoader();

                    updateCallValue("Doorbell is busy");
                    unawaited(
                      showDialog(
                        context: context.mounted ? context : context,
                        builder: (dialogContext) {
                          Future.delayed(const Duration(seconds: 2), () {
                            if (dialogContext.mounted) {
                              Navigator.pop(dialogContext);
                            }
                          });
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: CommonFunctions
                                    .getThemePrimaryLightWhiteColor(
                                  context,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning_rounded,
                                      color: AppColors.errorToastPrimaryColors,
                                      size: 70,
                                    ),
                                    const SizedBox(height: 30),
                                    Text(
                                      "Communication is in process",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "Doorbell is already occupied. Wait for the app user to end communication with the visitor.",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).dividerColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                } else {
                  final sdp = RTCSessionDescription(json["sdp"], "answer");
                  signalingClient.setRemoteDescriptionWithCheck(sdp, json);
                  Future.delayed(const Duration(seconds: 5), () {
                    if (state.seconds == 0) {
                      startTimer(
                        isZero: state.seconds == 0 ? true : false,
                      );
                    }
                  });
                  await WakelockPlus.enable();
                  await FlutterForegroundTask.startService(
                    notificationTitle: 'Call in progress',
                    notificationText: 'Your call is still active',
                  );

                  // if (await pip.isSupported()) {
                  //   await pip.isActived();
                  // }
                }
              }
            case "timer":
              final sessionId = await CommonFunctions.getDeviceModel();
              _logger.fine("sessionId from timer: $sessionId");
              _logger.fine("sessionId from from timer : ${data["session_id"]}");
              if (data["session_id"] == sessionId) {
                startTimer(
                  isZero: state.seconds == 0 ? true : false,
                );
              }
          }
        }
      }
      // }
    });
  }

  Future<int> _getSdkInt() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    }
    return 0;
  }

  Future<void> _startService(callUserId) async {
    // if (Platform.isAndroid) {
    //   final String packageName =
    //       'package:com.irveni.admin${config.environment == Environment.preprod ? "" : ".${config.environment.toString().toLowerCase().replaceAll("develop", "")}"}';
    //   _logger.fine("packageName: $packageName");
    //   final intent = AndroidIntent(
    //     action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    //     data: packageName,
    //   );
    //   await intent.launch();
    // }
    final sdkInt = await _getSdkInt();
    if (sdkInt >= 35) {
      // ✅ Android 16 (API 35+) → must use CallKeep / ConnectionService
      final callUUID = const Uuid().v4();

      await FlutterCallkeep().displayIncomingCall(
        uuid: callUUID,
        handle: callUserId,
      );

      // when user accepts → start WebRTC
    } else {
      if (await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.restartService();
      } else {
        await FlutterForegroundTask.startService(
          // You can manually specify the foregroundServiceType for the service
          // to be started, as shown in the comment below.

          serviceId: 256,
          notificationTitle: 'Calling is in progress',
          notificationText: 'Tap to return to the app',

          callback: startCallback,
        );
      }
    }
  }

  Future<void> createCall(
    BuildContext context, {
    bool fromStreaming = false,
    required String callType,
    required String callUserId,
    required bool isStreaming,
    required bool isExternalCamera,
    bool isNetworkSwitch = false,
  }) async {
    if (remoteRenderer == null) {
      remoteRenderer = RTCVideoRenderer();
      await remoteRenderer?.initialize();
    }
    singletonBloc.profileBloc.updateStreamingId(callUserId);
    emit(
      state.rebuild(
        (final b) => b
          ..isCallConnected = false
          ..callState = "Connecting",
      ),
    );
    updateCallValue(null);

    if (fromStreaming) {
      if (streamingPeerConnection == null) {
        await initiateVoipWithDoorBell(
          context.mounted ? context : context,
          callUserId,
          fromStreaming: fromStreaming,
          isStreaming: isStreaming,
        );
      }
    }
    await initiateImplementation(
      context.mounted ? context : context,
      callUserId,
      fromStreaming: fromStreaming,
      callType: callType,
      isNetworkSwitch: isNetworkSwitch,
    );
  }

  void initiateCall(UserDeviceModel devices) {
    singletonBloc.socketEmitterWithAck(
      roomName: Constants.voip,
      deviceId: devices.deviceId,
      request: state.isAudioCall
          ? Constants.doorbellAudioCall
          : state.isOneWayCall
              ? Constants.doorbellAudioCall
              : Constants.doorbellVideoCall,
      acknowledgement: (data) {
        _logger.severe(data);
      },
    );

    getMeeting();
  }

  bool isSilentSocketReceived = false;
  Future<void> createStreamingCall(
    context, {
    required String callUserId,
    bool isAudio = false,
    bool? isCameraEnable,
    bool? isMicrophoneEnable,
  }) async {
    emit(
      state.rebuild((final b) => b..isCallConnected = false),
    );
    // await callingPeerConnection?.close();
    await callingPeerConnection?.dispose();
    callingPeerConnection = null;

    unawaited(
      createCall(
        context,
        callUserId: callUserId,
        callType: isAudio
            ? Constants.silentDoorbellAudioCall
            : Constants.doorbellVideoCall,
        isStreaming: true,
        isExternalCamera: false,
        fromStreaming: true,
      ),
    );
    if (isAudio) {
      // await enableLocalStream(isAudioOnly: true, isSpeakerOn: false);
      emit(
        state.rebuild(
          (final b) => b
            ..isSilentAudioCall = true
            ..isMicrophoneOnStreamEnabled = isMicrophoneEnable
            ..muted = false,
        ),
      );
      emit(
        state.rebuild((final b) => b),
      );
    } else {
      // await enableLocalStream(isSpeakerOn: false, isFromStream: true);
      // localStream?.getVideoTracks()[0].enabled = true;

      emit(
        state.rebuild(
          (final b) => b
            ..isMicrophoneOnStreamEnabled = !(localRenderer?.muted ?? true)
            ..isCameraOnStreamEnabled = isCameraEnable
            ..isCallStarted = true,
        ),
      );
      Future.delayed(const Duration(seconds: 9), () {
        if (!state.isCallConnected) {
          // EasyLoading.dismiss();
          Constants.dismissLoader();
        }
      });
    }
  }

  Future<void> getMeeting() async {
    final String meetingId = await apiService.joinMeeting();
    emit(
      state.rebuild(
        (final b) => b
          ..meetingConnected = true
          ..meetingId = meetingId,
      ),
    );
  }

  Future<void> createCallingOffer(
    String callType,
    BuildContext context, {
    bool fromStreaming = false,
  }) async {
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": fromStreaming ? false : true,
        "OfferToReceiveVideo": fromStreaming ? false : true,
      },
    };

    _logger.fine("Candidate: Offer created $callType");
    final RTCSessionDescription? offer =
        await callingPeerConnection?.createOffer(offerSdpConstraints);
    if (offer != null) {
      await callingPeerConnection?.setLocalDescription(offer);
      SignalingClient(this)
          .sendOffer(offer, callType, context.mounted ? context : context);
    }
  }

  void sendIceCandidate(RTCIceCandidate candidate) {
    try {
      final ice = {
        "type": "candidate",
        "candidate": candidate.candidate,
        "sdpMLineIndex": candidate.sdpMLineIndex,
        "sdpMid": candidate.sdpMid,
        "from": singletonBloc.profileBloc.state!.callUserId,
        "target": singletonBloc.profileBloc.state!.streamingId,
      };
      unawaited(
        singletonBloc.socketEmitterWithAck(
          roomName: Constants.signaling,
          deviceId: selectedDevice!.deviceId,
          request: Constants.candidate,
          obj: ice,
        ),
      );
    } catch (e) {
      _logger.fine(e);
    }
  }

  void updateSpeakerStatus(bool isSpeakerOn) {
    if (Platform.isAndroid) {
      unawaited(
        Helper.setSpeakerphoneOn(isSpeakerOn),
      );
    } else {
      unawaited(
        SpeakerphoneController.setSpeakerphoneOn(
          isSpeakerOn,
        ),
      );
    }
  }

  Duration iceDisconnectedTimeout = const Duration(seconds: 30);
  Timer? disconnectTimer;
  Timer? _debounceReattempt;
  Future<void> createPeerConnectionMethod(
    context, {
    bool isNotify = false,
    bool fromStreaming = false,
    bool speakerChange = false,
    bool isNetworkSwitch = false,
    String? callType,
  }) async {
    pendingCandidates.clear();
    final Map<String, dynamic> loopbackConstraints = {
      "mandatory": {},
      "optional": [
        {"DtlsSrtpKeyAgreement": true},
        {"googCpuOveruseDetection": true},
        {"googCpuOveruseDetectionEncodeUsage": true},
        {"googCpuOveruseDetectionDecodeUsage": true},
        {"googCpuOveruseDetectionEncodeTime": true},
        {"googCpuOveruseDetectionDecodeTime": true},
        {"googCpuOveruseDetectionEncodeUsagePercent": true},
        {"googCpuOveruseDetectionDecodeUsagePercent": true},
      ],
    };

    try {
      callingPeerConnection = await createPeerConnection(
        {
          'iceServers': iceServers,
        },
        loopbackConstraints,
      );

      _logger.severe("websocket is call");
      if (callingPeerConnection != null) {
        callingPeerConnection!.onSignalingState = (state) {
          _logger.severe("call state is $state");
        };

        callingPeerConnection?.onIceConnectionState = (rtcIceConnectionState) {
          if (rtcIceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateConnected) {
            _logger.severe(rtcIceConnectionState);
            disconnectTimer?.cancel();
            _debounceReattempt?.cancel();
            startTimer(isZero: false);
            emit(
              state.rebuild(
                (b) => b
                  ..isReconnecting = false
                  ..isCallButtonEnabled = true,
              ),
            );
          } else if (rtcIceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
            if (state.isOnCallingScreen) {
              timer?.cancel();
              emit(
                state.rebuild(
                  (b) => b
                    ..isReconnecting = true
                    ..isCallButtonEnabled = false,
                ),
              );
            }
            disconnectTimer?.cancel();
            disconnectTimer = Timer(iceDisconnectedTimeout, () {
              if (state.isReconnecting) {
                if (state.isOnCallingScreen) {
                  ToastUtils.infoToast(
                    "Disconnected",
                    "Call ended due to internet disconnection.",
                  );
                  Navigator.pop(context);
                } else {
                  endStreamingCall(context);
                }
              }
              // Take recovery action: notify UI, close peer, restart ICE, etc.
            });

            _logger.severe(rtcIceConnectionState);
          } else if (rtcIceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateFailed) {
            _logger.severe(rtcIceConnectionState);

            Future.delayed(const Duration(seconds: 3), () {
              if (state.isReconnecting) {
                _debounceReattempt?.cancel();
                disconnectTimer?.cancel();

                _debounceReattempt = Timer(const Duration(seconds: 10), () {
                  if (state.isReconnecting) {
                    if (state.isOnCallingScreen) {
                      ToastUtils.infoToast(
                        "Disconnected",
                        "Call has been disconnected",
                      );
                      Navigator.pop(context);
                    } else {
                      endStreamingCall(context);
                    }
                  }
                });
              }
            });
          }
        };

        callingPeerConnection!.onAddStream = (event) async {
          updateSpeakerStatus(false);

          // Apply noise reduction to remote stream
          // await applyNoiseReductionToStream(event);

          if (!fromStreaming) {
            if (remoteRenderer == null) {
              remoteRenderer = RTCVideoRenderer();
              await remoteRenderer?.initialize();
            }
            // toggleSpeaker(isCalling: true);
            if (state.isOnCallingScreen) {
              remoteRenderer?.srcObject = event;

              final bool isPureAudioCall = state.isAudioCall &&
                  !state.isTwoWayCall &&
                  !state.isOneWayCall;

              if (isPureAudioCall) {
                // Audio-only calls will never render video frames, so mark the
                // session as connected as soon as the remote audio stream arrives.
                emit(
                  state.rebuild(
                    (final b) => b
                      ..remoteRenderer = remoteRenderer
                      ..isCallConnected = true,
                  ),
                );
                callingTimer?.cancel();
              } else {
                //

                callingTimer =
                    Timer.periodic(const Duration(seconds: 1), (timer) async {
                  if (remoteRenderer != null) {
                    _logger.fine(
                      "renderVideo is ${remoteRenderer?.value.renderVideo}",
                    );
                    if (remoteRenderer?.value.renderVideo ?? false) {
                      _logger.fine("peer set");
                      emit(
                        state.rebuild(
                          (final b) => b
                            ..remoteRenderer = remoteRenderer
                            ..isCallConnected = true,
                        ),
                      );
                      callingTimer?.cancel();
                    } else {
                      if (timer.tick >= 20) {
                        if (state.isCallButtonEnabled) {
                          callingTimer?.cancel();
                          if (state.isOnCallingScreen) {
                            ToastUtils.infoToast(
                              "Disconnected",
                              "Unable to connect. Please check your network or try again later.",
                            );
                            Navigator.pop(context);
                          } else {
                            unawaited(endStreamingCall(context));
                          }
                        }
                      }
                    }
                  }
                });
              }
            }
          }
          // unawaited(EasyLoading.dismiss());
          Constants.dismissLoader();
        };
        callingPeerConnection!.onIceCandidate = (candidate) async {
          final isRemote =
              await callingPeerConnection!.getRemoteDescription() != null;
          // Handle new ice candidate
          _logger.severe('isRemote : $isRemote');
          pendingCandidates.add(candidate);
          if (isRemote) {
            unawaited(callingPeerConnection!.addCandidate(candidate));
          }
          sendIceCandidate(
            candidate,
          );
        };

        widthLocalView = MediaQuery.of(context).size.width * 0.35;
        heightLocalView = MediaQuery.of(context).size.height * 0.20;
        if (callType != null) {
          if (localStream == null) {
            if (!fromStreaming) {
              await enableLocalStream(
                isAudioOnly: callType == "audio" ||
                        callType == Constants.doorbellAudioCall
                    ? true
                    : false,
              );
            } else {
              if (callType == Constants.silentDoorbellAudioCall) {
                await enableLocalStream(
                  isAudioOnly: true,
                  isFromStream: fromStreaming,
                );
              } else {
                await enableLocalStream(isFromStream: fromStreaming);
                emit(
                  state.rebuild(
                    (final b) => b..isMicrophoneOnStreamEnabled = true,
                  ),
                );
              }
            }
          }
          if (callType == "audio" || callType == Constants.doorbellAudioCall) {
            isAudioEmit();
          } else if (callType == "one_way_video") {
            isOneWayEmit();
          } else {
            isTwoWayEmit();
          }
        }
        return;
      }
    } catch (e) {
      updateIsSpeakerLoading(false);
      _logger.severe(e);
    }

    // enableLocalStream(isEmpty: true, isAudioOnly: false);
  }

  Future<void> enableLocalStream({
    bool isAudioTrue = false,
    bool isAudioOnly = false,
    bool isSpeakerOn = true,
    bool isFromStream = false,
    bool fromStreaming = false,
  }) async {
    emit(
      state.rebuild((final b) => b..localRenderer = null),
    );
    localStream = await enableFullLocalStream(isAudioOnly);

    // Apply noise reduction to the local stream
    // if (localStream != null) {
    //   await applyNoiseReductionToStream(localStream);
    // }

    // if (isAudioOnly) {
    _videoTransceiver = await callingPeerConnection?.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendRecv,
      ),
    );
    // }

    _audioTransceiver = await callingPeerConnection?.addTransceiver(
      kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: RTCRtpTransceiverInit(
        direction: TransceiverDirection.SendRecv,
      ),
    );

    if (localStream != null) {
      localStream?.getTracks().forEach((track) async {
        if (callingPeerConnection != null) {
          if (localStream != null) {
            await callingPeerConnection!.addTrack(track, localStream!);
            // if (isAudioTrue) {
            //   final videoTrack = localStream?.getVideoTracks()[0];
            //   await videoTrack?.stop();
            //   localStream?.removeTrack(videoTrack!);
            //   final d = callingPeerConnection
            //       ?.getLocalStreams()[0]
            //       ?.getVideoTracks()[0];
            //   _logger.fine(d);
            //   localStream?.getVideoTracks()[0].enabled = false;
            //   callingPeerConnection
            //       ?.getLocalStreams()[0]
            //       ?.getVideoTracks()[0]
            //       .enabled = false;
            // }
            _logger
                .severe("callingPeerConnection is test $callingPeerConnection");
            if (localRenderer == null) {
              localRenderer = RTCVideoRenderer();
              await localRenderer
                  ?.initialize(); // Ensure initialization before setting srcObject
            }

            /// Ensure the renderer is initialized before assigning the stream
            if (localRenderer?.textureId == null) {
              await localRenderer?.initialize();
            }

            localRenderer?.srcObject = localStream;
            if (localRenderer?.srcObject != null) {
              localRenderer?.muted = false;
            }
            emit(
              state.rebuild(
                (final b) => b
                  ..localRenderer = localRenderer
                  ..muted = false,
              ),
            );
          }
        }
      });
    }
    return;
  }

  Future<MediaStream?> enableFullLocalStream(bool isAudioOnly) async {
    try {
      if (isAudioOnly) {
        return navigator.mediaDevices.getUserMedia({
          'audio': {
            'echoCancellation': true,
            'noiseSuppression': true,
            'autoGainControl': true,
            'sampleRate': 48000,
            'channelCount': 1,
            'volume': 1.0,
          },
          "video": false,
        });
      }
      return navigator.mediaDevices.getUserMedia({
        'audio': {
          'echoCancellation': true,
          'noiseSuppression': true,
          'autoGainControl': true,
          'sampleRate': 48000,
          'channelCount': 1,
          'volume': 1.0,
        },
        "video": {
          "mandatory": {
            "minWidth": '720',
            "minHeight": '1280',
          },
          "facingMode": "user",
          "optional": [],
        },
      });
    } catch (e) {
      _logger.severe(e);
      return null;
    }
  }

  /// Configure audio processing for better noise reduction
  ///
  /// This method sets up comprehensive audio processing constraints to reduce
  /// noise distortion during WebRTC calls. The settings include:
  /// - Echo cancellation to prevent audio feedback
  /// - Noise suppression to filter out background noise
  /// - Auto gain control to maintain consistent audio levels
  /// - High-pass filter to remove low-frequency noise
  /// - Typing noise detection to reduce keyboard sounds
  /// - Optimized sample rate (48kHz) and mono channel for better quality
  // Future<void> configureAudioProcessing() async {
  //   try {
  //     // Set audio processing constraints for better quality
  //     final audioConstraints = {
  //       'echoCancellation': true,
  //       'noiseSuppression': true,
  //       'autoGainControl': true,
  //       'googEchoCancellation': true,
  //       'googAutoGainControl': true,
  //       'googNoiseSuppression': true,
  //       'googHighpassFilter': true,
  //       'googTypingNoiseDetection': true,
  //       'googAudioMirroring': false,
  //       'googAudioProcessing': true,
  //       'sampleRate': 48000,
  //       'channelCount': 1,
  //       'volume': 1.0,
  //     };
  //
  //     _logger.fine('Audio processing configured with noise reduction settings');
  //   } catch (e) {
  //     _logger.severe('Error configuring audio processing: $e');
  //   }
  // }

  /// Apply noise reduction settings to existing audio tracks
  // Future<void> applyNoiseReductionToStream(MediaStream? stream) async {
  //   if (stream == null) {
  //     return;
  //   }
  //
  //   try {
  //     final audioTracks = stream.getAudioTracks();
  //     for (final track in audioTracks) {
  //       // Apply audio processing settings to the track
  //       await track.applyConstraints({
  //         'echoCancellation': true,
  //         'noiseSuppression': true,
  //         'autoGainControl': true,
  //       });
  //     }
  //     _logger.fine('Noise reduction applied to audio tracks');
  //   } catch (e) {
  //     _logger.severe('Error applying noise reduction: $e');
  //   }
  // }

  Future<void> toggleSpeaker({bool isEnable = false, isCalling = false}) async {
    if (state.isOnCallingScreen) {
      if (!isEnable &&
          state.isAudioCall &&
          !state.isTwoWayCall &&
          !state.isOneWayCall) {
        await listenToSensor();
      } else {
        await streamSubscription?.cancel();
      }
    }

    try {
      if (Platform.isIOS) {
        unawaited(SpeakerphoneController.setSpeakerphoneOn(isEnable));

        updateSpeaker(isEnable);
      } else {
        unawaited(Helper.setSpeakerphoneOn(isEnable));
        updateSpeaker(isEnable);
      }
      // emit(state.rebuild((final b) => b..enabledSpeakerInStream = isEnable));
    } catch (e) {
      _logger.severe(e);
    }
  }

  // Get current speaker status
  Future<bool> getSpeakerStatus() async {
    try {
      if (Platform.isIOS) {
        return await SpeakerphoneController.getSpeakerphoneStatus();
      } else {
        // For Android, we'll use the same method channel
        return await SpeakerphoneController.getSpeakerphoneStatus();
      }
    } catch (e) {
      _logger.severe("Error getting speaker status: $e");
      return false; // Default to false if there's an error
    }
  }

  void removeRemoteAudio() {
    if (callingPeerConnection == null) {
      return;
    }
    if (callingPeerConnection!.getRemoteStreams().isEmpty) {
      return;
    }

    _logger.fine(callingPeerConnection);
    // Find the first audio track and remove it
    final audioTrack = callingPeerConnection
        ?.getRemoteStreams()[0]
        ?.getAudioTracks()
        .firstOrNull;

    if (audioTrack != null) {
      audioTrack.enabled = false; // Disable the audio track
    }
  }

  void removeStreamRemoteAudio() {
    if (streamingPeerConnection == null) {
      return;
    }

    if (streamingPeerConnection!.getRemoteStreams().isEmpty) {
      return;
    }
    _logger.fine(streamingPeerConnection);
    // Find the first audio track and remove it
    final audioTrack = streamingPeerConnection
        ?.getRemoteStreams()[0]
        ?.getAudioTracks()
        .firstOrNull;

    if (audioTrack != null) {
      audioTrack.enabled = false; // Disable the audio track
    }
    _logger.fine(streamingPeerConnection);
  }

  Future<void> resumeRemoteAudio() async {
    if (streamingPeerConnection == null) {
      return;
    }
    if (streamingPeerConnection!.getRemoteStreams().isEmpty) {
      return;
    }

    final audioTrack = streamingPeerConnection
        ?.getRemoteStreams()[0]
        ?.getAudioTracks()
        .firstOrNull;

    if (audioTrack != null) {
      if (!audioTrack.enabled) {
        audioTrack.enabled = true;
      }
    }
  }

  Future<void> localReinitialize() async {
    await localStream?.dispose();
    localStream = null;
    if (localRenderer != null && localRenderer?.textureId != null) {
      await localRenderer?.dispose();
      localRenderer = null;
      emit(state.rebuild((final b) => b..localRenderer = null));
    }
    localRenderer = RTCVideoRenderer();
    await localRenderer?.initialize();
    emit(state.rebuild((final b) => b..localRenderer = localRenderer));
    return;
  }

  // Timer? silentTimer;

  Future<void> enableInStreamMicrophone(
    BuildContext context,
    String callUserId, {
    required bool isMicrophoneEnable,
    required,
  }) async {
    _logger.fine("isMicrophoneEnable in stream $isMicrophoneEnable");
    if (isMicrophoneEnable) {
      if (!state.isCameraOnStreamEnabled) {
        if (localStream == null) {
          if (context.mounted) {
            await singletonBloc.removeInstance();
            // unawaited(EasyLoading.show());
            Constants.showLoader();

            await createStreamingCall(
              context.mounted ? context : context,
              callUserId: callUserId,
              isMicrophoneEnable: isMicrophoneEnable,
              isAudio: true,
            );
          }
        } else {
          if (localRenderer?.srcObject != null) {
            _logger.fine("isMicrophoneEnable 1 $isMicrophoneEnable");
            localRenderer?.muted =
                localRenderer == null ? true : !localRenderer!.muted;
            emit(
              state.rebuild(
                (final b) => b
                  ..isMicrophoneOnStreamEnabled = isMicrophoneEnable
                  ..muted = false,
              ),
            );
          }
        }
      } else {
        if (localRenderer?.srcObject != null) {
          _logger.fine("isMicrophoneEnable 2 $isMicrophoneEnable");
          localRenderer?.muted =
              localRenderer == null ? true : !localRenderer!.muted;
          emit(
            state.rebuild(
              (final b) => b
                ..isMicrophoneOnStreamEnabled = isMicrophoneEnable
                ..muted = false,
            ),
          );
        }
      }
    } else {
      final navigatorState = singletonBloc.navigatorKey?.currentState;
      if (navigatorState == null) {
        return;
      }
      final context = navigatorState.context;
      if (!context.mounted) {
        return;
      }
      unawaited(
        VoiceControlBloc.of(context).reinitializeWakeWord(context),
      );
      // unawaited(EasyLoading.show());
      Constants.showLoader();

      if (localRenderer?.srcObject != null) {
        localRenderer?.muted = true;
        state.localRenderer?.muted = true;
        _logger.fine("isMicrophoneEnable 3 ${localRenderer?.muted}");
      }
      if (!state.isCameraOnStreamEnabled) {
        // unawaited(toggleSpeaker());
        await endStreamingCall(context);
        Future.delayed(const Duration(seconds: 1), () async {
          // unawaited(EasyLoading.dismiss());
          Constants.dismissLoader();
        });
      } else {
        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();
      }
      emit(
        state.rebuild(
          (final b) => b
            ..isMicrophoneOnStreamEnabled = isMicrophoneEnable
            ..muted = true,
        ),
      );
    }
  }

  Future<void> enableInStreamCamera(
    BuildContext context,
    String callUserId, {
    bool isCameraEnable = false,
    bool isCall = false,
    required,
  }) async {
    widthLocalView = 150;
    heightLocalView = 150;
    if (isCameraEnable) {
      await singletonBloc.removeInstance();
      isSilentSocketReceived = false;
      // unawaited(EasyLoading.show());
      Constants.showLoader();

      await createStreamingCall(
        context.mounted ? context : context,
        callUserId: callUserId,
        isCameraEnable: isCameraEnable,
      );
    } else {
      try {
        try {
          final navigatorState = singletonBloc.navigatorKey?.currentState;
          if (navigatorState == null) {
            return;
          }
          final context = navigatorState.context;
          if (!context.mounted) {
            return;
          }
          unawaited(
            VoiceControlBloc.of(context).reinitializeWakeWord(context),
          );
        } catch (e) {
          _logger.fine(e);
        }
        // unawaited(EasyLoading.show());
        Constants.showLoader();

        if (localRenderer?.srcObject != null) {
          localRenderer?.muted = true;
        }
        emit(
          state.rebuild(
            (final b) => b
              ..isMicrophoneOnStreamEnabled = false
              ..muted = true
              ..isCameraOnStreamEnabled = isCameraEnable
              ..isSilentAudioCall = false,
          ),
        );
        // unawaited(toggleSpeaker());
        await endStreamingCall(
          context.mounted ? context : context,
        );

        Future.delayed(const Duration(seconds: 1), () async {
          // updateIsSpeakerLoading(true);
          // await createCall(
          //   context.mounted ? context : context,
          //   callType: Constants.doorbellStreamAudio,
          //   callUserId: callUserId,
          //   isStreaming: true,
          //   isExternalCamera: true,
          // );
          // unawaited(EasyLoading.dismiss());
          Constants.dismissLoader();
        });
      } catch (e) {
        // unawaited(EasyLoading.dismiss());
        Constants.dismissLoader();
      }
    }
  }

  Timer? remoteTimer;
  Timer? imageTimer;
  Timer? audioStreamTimer;

  Future<void> initializeRenders() async {
    try {
      if (remoteRenderer == null) {
        remoteRenderer = RTCVideoRenderer();

        await remoteRenderer?.initialize();
      }
      if (localRenderer == null) {
        localRenderer = RTCVideoRenderer();
        await localRenderer?.initialize();
      }
    } catch (e) {
      _logger.severe(e);
      // localRenderer = null;
      // localRenderer = RTCVideoRenderer();
      // await localRenderer?.initialize();
    }
  }

  void updateRemote(RTCVideoRenderer? r) {
    emit(state.rebuild((final b) => b..remoteRenderer = r));
  }

  final NetworkInfo wifiInfo = NetworkInfo();
  String? lastBSSID;
  Future<void> initWifiInfo() async {
    iceServers = await apiService.getAllIceServers();
    try {
      lastBSSID = await wifiInfo.getWifiBSSID();
      _logger.fine(lastBSSID);
    } catch (e) {
      _logger.fine('Could not get initial BSSID: $e');
    }
  }

  Future<void> removeTranseiver() async {
    if (streamingPeerConnection != null) {
      final transceivers = await streamingPeerConnection!.getTransceivers();
      for (final transceiver in transceivers) {
        if (transceiver.receiver.track != null) {
          await transceiver.receiver.track!.stop();
        }
        if (transceiver.sender.track != null) {
          await transceiver.sender.track!.stop();
        }
      }
    }
  }

  Future<void> _stopTracksForStream(MediaStream? stream) async {
    if (stream == null) {
      _logger.fine('No stream provided to _stopTracksForStream; skipping.');
      return;
    }

    _logger.fine('Stopping media tracks for stream: ${stream.id}');
    final audioTracks = stream.getAudioTracks();
    for (final track in audioTracks) {
      track.enabled = false;
      await track.stop();
    }

    final videoTracks = stream.getVideoTracks();
    for (final track in videoTracks) {
      track.enabled = false;
      await track.stop();
    }
  }

  Future<void> stopAllAudioTracks() async {
    try {
      _logger.fine('stopAllAudioTracks → begin');
      if (streamingPeerConnection != null) {
        final remoteStreams = streamingPeerConnection!.getRemoteStreams();
        for (final stream in remoteStreams) {
          await _stopTracksForStream(stream);
        }

        final localStreams = streamingPeerConnection!.getLocalStreams();
        for (final stream in localStreams) {
          await _stopTracksForStream(stream);
        }
      }

      if (callingPeerConnection != null) {
        final remoteStreams = callingPeerConnection!.getRemoteStreams();
        for (final stream in remoteStreams) {
          await _stopTracksForStream(stream);
        }

        final localStreams = callingPeerConnection!.getLocalStreams();
        for (final stream in localStreams) {
          await _stopTracksForStream(stream);
        }
      }

      await _stopTracksForStream(localStream);
      _logger.fine('stopAllAudioTracks → completed');
    } catch (e) {
      _logger.warning('Error stopping audio tracks: $e');
    }
  }

  // Ensure no straggler timers fire after the stream is closed.
  void _cancelStreamingTimers() {
    _logger.fine('Cancelling streaming-related timers.');
    callingEndTimer?.cancel();
    callingEndTimer = null;

    callingTimer?.cancel();
    callingTimer = null;

    remoteTimer?.cancel();
    remoteTimer = null;

    imageTimer?.cancel();
    imageTimer = null;

    audioStreamTimer?.cancel();
    audioStreamTimer = null;

    disconnectTimer?.cancel();
    disconnectTimer = null;

    _debounceReattempt?.cancel();
    _debounceReattempt = null;

    timer?.cancel();
    timer = null;
  }

  bool get _hasActiveStreamingSession =>
      streamingPeerConnection != null ||
      callingPeerConnection != null ||
      remoteRenderer != null ||
      videoController != null;

  Future<bool> _prepareStreamingPeerConnection(
    Map<String, dynamic> config,
    Map<String, dynamic> constraints,
  ) async {
    try {
      // Always dispose any lingering connection before creating a new one.
      await streamingPeerConnection?.close();
      await streamingPeerConnection?.dispose();
    } catch (e) {
      _logger.warning('Error closing previous streaming peer connection: $e');
    }

    streamingPeerConnection = await createPeerConnection(
      config,
      constraints,
    );

    if (streamingPeerConnection == null) {
      _logger
          .severe('createPeerConnection returned null for streaming session.');
      return false;
    }

    try {
      await streamingPeerConnection!.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
      );
      await streamingPeerConnection!.addTransceiver(
        kind: RTCRtpMediaType.RTCRtpMediaTypeAudio,
        init: RTCRtpTransceiverInit(direction: TransceiverDirection.RecvOnly),
      );
      return true;
    } on PlatformException catch (e, stackTrace) {
      _logger.severe(
        'Failed to add streaming transceivers: $e\n$stackTrace',
      );
      try {
        await streamingPeerConnection?.dispose();
      } catch (disposeError) {
        _logger.warning(
          'Error disposing failed streaming connection: $disposeError',
        );
      }
      streamingPeerConnection = null;
      return false;
    }
  }

  /// Dispose every media object associated with the live stream so audio stops immediately.
  Future<void> _disposeStreamingResources({bool disposeVideo = true}) async {
    _logger.fine(
      '_disposeStreamingResources → disposeVideo=$disposeVideo, '
      'hasStreamingPeer=${streamingPeerConnection != null}, '
      'hasCallingPeer=${callingPeerConnection != null}, '
      'hasRemoteRenderer=${remoteRenderer != null}, '
      'hasVideoController=${videoController != null}',
    );
    await stopAllAudioTracks();
    _cancelStreamingTimers();
    pendingCandidates.clear();

    try {
      await streamingPeerConnection?.close();
      await streamingPeerConnection?.dispose();
    } catch (e) {
      _logger.warning('Error disposing streaming peer connection: $e');
    }
    streamingPeerConnection = null;

    try {
      await callingPeerConnection?.close();
      await callingPeerConnection?.dispose();
    } catch (e) {
      _logger.warning('Error disposing calling peer connection: $e');
    }
    callingPeerConnection = null;

    try {
      await localStream?.dispose();
    } catch (e) {
      _logger.warning('Error disposing local stream: $e');
    }
    localStream = null;

    if (remoteRenderer != null) {
      try {
        remoteRenderer?.srcObject = null;
        await remoteRenderer?.dispose();
      } catch (e) {
        _logger.warning('Error disposing remote renderer: $e');
      }
      remoteRenderer = null;
    }

    if (localRenderer != null) {
      try {
        localRenderer?.srcObject = null;
        await localRenderer?.dispose();
      } catch (e) {
        _logger.warning('Error disposing local renderer: $e');
      }
      localRenderer = null;
    }

    if (disposeVideo && videoController != null) {
      try {
        await videoController?.pause();
        await videoController?.dispose();
      } catch (e) {
        _logger.warning('Error disposing video controller: $e');
      }
      videoController = null;
      m3u8TimeMapping = null;
      timestampList = [];
    }

    emit(
      state.rebuild(
        (b) => b
          ..remoteRenderer = remoteRenderer
          ..localRenderer = localRenderer
          ..videoController = disposeVideo ? videoController : b.videoController
          ..isVideoInitialized = disposeVideo ? false : b.isVideoInitialized,
      ),
    );
    _logger.fine('_disposeStreamingResources → emit updated state.');
  }

  int poorInternetCount = 0;
  Future<void> initializeConnection(
    BuildContext context,
    String callUserId,
    bool isExternalCamera,
    bool fromStreaming,
    bool isStreaming,
  ) async {
    singletonBloc.profileBloc.updateStreamingId(callUserId);
    final Map<String, dynamic> loopbackConstraints = {
      "mandatory": {},
      "optional": [
        {"DtlsSrtpKeyAgreement": true},
        {"googCpuOveruseDetection": true},
        {"googCpuOveruseDetectionEncodeUsage": true},
        {"googCpuOveruseDetectionDecodeUsage": true},
        {"googCpuOveruseDetectionEncodeTime": true},
        {"googCpuOveruseDetectionDecodeTime": true},
        {"googCpuOveruseDetectionEncodeUsagePercent": true},
        {"googCpuOveruseDetectionDecodeUsagePercent": true},
      ],
    };
    final Map<String, dynamic> config = {
      'iceServers': iceServers,
    };
    try {
      var prepared = await _prepareStreamingPeerConnection(
        config,
        loopbackConstraints,
      );

      if (!prepared) {
        _logger.warning(
          'Initial streaming peer connection setup failed, retrying once.',
        );
        await Future.delayed(const Duration(milliseconds: 300));
        prepared = await _prepareStreamingPeerConnection(
          config,
          loopbackConstraints,
        );
      }

      if (prepared && streamingPeerConnection != null) {
        streamingPeerConnection?.onIceConnectionState =
            (rtcIceConnectionState) {
          if (rtcIceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateConnected) {
            _logger.severe(rtcIceConnectionState);
            if (!state.isOnCallingScreen && state.isCallConnected) {
              if (localRenderer?.srcObject != null) {
                localRenderer?.muted = !state.isMicrophoneOnStreamEnabled;
              }
            }
            emit(
              state.rebuild(
                (b) => b..isLiveStreamAvailable = true,
              ),
            );
          } else if (rtcIceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
            _logger.severe(rtcIceConnectionState);
            emit(state.rebuild((final b) => b..isLiveStreamingLoading = true));
          } else if (rtcIceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateFailed) {
            _logger.severe(rtcIceConnectionState);

            Future.delayed(const Duration(seconds: 3), () {
              emit(
                state.rebuild((final b) => b..isLiveStreamingLoading = false),
              );
              if (state.location.isEmpty) {
                emit(
                  state.rebuild(
                    (final b) => b..isLiveStreamAvailable = false,
                  ),
                );
              }
              if (state.isCalling && state.location.isEmpty) {
                emit(state.rebuild((final b) => b..isCalling = false));

                if (context.mounted) {
                  Navigator.pop(context);
                }
                ToastUtils.errorToast(
                  'Doorbell unavailable',
                );
              }
            });
          }
        };
        streamingPeerConnection?.onAddStream = (event) async {
          updateSpeakerStatus(false);

          // Apply noise reduction to remote stream
          // await applyNoiseReductionToStream(event);

          remoteRenderer = null;
          await Future.delayed(const Duration(milliseconds: 100));
          remoteRenderer = RTCVideoRenderer();
          await Future.delayed(const Duration(milliseconds: 100));
          await remoteRenderer?.initialize();
          await Future.delayed(const Duration(milliseconds: 100));
          _logger.fine('Remote stream $event');
          try {
            remoteRenderer?.srcObject = event;
          } catch (e) {
            _logger.severe(e);
          }
          emit(
            state.rebuild(
              (final b) => b
                ..isLiveStreamingLoading = false
                ..isPoorInternet = false
                ..isLiveStreamAvailable = true,
            ),
          );
          _logger.fine('Remote stream added');
          final shouldEnableSpeaker = state.enabledSpeakerInStream;
          removeStreamRemoteAudio();
          if (shouldEnableSpeaker) {
            Future.delayed(const Duration(milliseconds: 200), () async {
              if (streamingPeerConnection == null) {
                _logger.fine(
                  'resumeRemoteAudio skipped – streamingPeerConnection is null.',
                );
                return;
              }
              if (!state.enabledSpeakerInStream) {
                _logger.fine(
                  'resumeRemoteAudio skipped – speaker preference is disabled.',
                );
                return;
              }
              _logger.fine('Re-enabling remote audio after stream resume.');
              await resumeRemoteAudio();
              if (Platform.isAndroid) {
                unawaited(Helper.setSpeakerphoneOn(true));
              } else {
                unawaited(
                  SpeakerphoneController.setSpeakerphoneOn(true),
                );
              }
            });
          }
          remoteTimer =
              Timer.periodic(const Duration(seconds: 1), (timer) async {
            if (timer.tick >= 15) {
              remoteTimer?.cancel();
              unawaited(
                attemptReconnection(
                  context,
                  isExternalCamera,
                  callUserId,
                ),
              );
            }
            if (remoteRenderer != null) {
              if (remoteRenderer?.value.renderVideo ?? false) {
                _logger.fine('Remote stream added finally');
                unawaited(imageSend(callUserId));
                emit(
                  state.rebuild(
                    (final b) => b
                      ..remoteRenderer = remoteRenderer
                      ..isLiveStreamingLoading = false
                      ..isStreamReconnecting = false,
                  ),
                );
                updateIsPoorInternet(false);
                remoteTimer?.cancel();
              }
            }
          });
        };

        Future.delayed(const Duration(seconds: 1), () {
          createOffer(isStreaming);
        });
      } else {
        _logger.severe(
          'Unable to prepare streaming peer connection after retry; aborting start.',
        );
      }
    } catch (e) {
      _logger.severe(e);
    }
  }

  Future<File> uint8ListToFile(Uint8List uint8list, String filename) async {
    /// Get the temporary directory of the device
    final tempDir = await getTemporaryDirectory();

    /// Create a file in the temporary directory with the given filename
    final file = File('${tempDir.path}/$filename');

    /// Write the Uint8List bytes to the file
    return file.writeAsBytes(uint8list);
  }

  Future<void> imageSend(
    String callUserId, {
    bool canNull = false,
    StartupBloc? startupBloc,
  }) async {
    try {
      // Snapshot Capture Enabled or Disabled based on 0206
      if (singletonBloc
          .isFeatureCodePresent(AppRestrictions.snapshotCapture.code)) {
        if (remoteRenderer?.value.renderVideo ?? false) {
          final Uint8List? img =
              await captureFrame(remoteRenderer, canNull: canNull);
          if (img != null) {
            unawaited(GetStorage().write("imageValue[$callUserId]", img));
            startupBloc?.updateStreamingStatus(
              targetDeviceId: callUserId,
              isStreaming: 1,
            );
            unawaited(imageSendToApi(callUserId));
          }
        }
      }
    } catch (e) {
      _logger.fine(e);
    }
  }

  Future<void> imageSendToApi(String callUserId) async {
    final sp = GetStorage();
    var imageValue = sp.read("imageValue[$callUserId]");
    if (imageValue == null) {
      return;
    }
    if (imageValue != null && imageValue is List) {
      imageValue = Uint8List.fromList(imageValue.map((e) => e as int).toList());
    }
    if (imageValue != null) {
      final File imageFile = await uint8ListToFile(
        imageValue,
        "imageValue[$callUserId].png",
      );
      await apiService.uploadFile(
        imageFile,
        fileName: "snapshots/$callUserId/snapshot.jpg",
      );
    }
  }

  Future<Uint8List?> captureFrame(
    RTCVideoRenderer? renderer, {
    bool canNull = false,
  }) async {
    try {
      // Check if renderer is null
      if (renderer == null) {
        _logger.warning('Renderer is null');
        unawaited(reinitialize());
        return null;
      }

      // Check if srcObject is null
      if (renderer.srcObject == null) {
        _logger.warning('Renderer srcObject is null');
        unawaited(reinitialize());
        return null;
      }

      // Get video tracks and check if they exist

      final videoTracks = renderer.srcObject?.getVideoTracks();
      if (videoTracks == null || videoTracks.isEmpty) {
        _logger.warning('No video tracks found in renderer');
        unawaited(reinitialize());
        return null;
      }

      // Get the first video track
      final video = videoTracks.first;

      // Check if the track is actually a video track
      if (video.kind != 'video') {
        _logger.warning('Track is not a video track: ${video.kind}');
        unawaited(reinitialize());
        return null;
      }

      // Check if the track is enabled
      if (!video.enabled) {
        _logger.warning('Video track is disabled');
        unawaited(reinitialize());
        return null;
      }

      // Capture the frame
      await Future.delayed(const Duration(seconds: 1));
      final image = await video.captureFrame();

      final Uint8List uint8list = image.asUint8List();
      if (canNull) {
        // unawaited(reinitialize());
      }
      return uint8list;
    } finally {
      if (canNull) {
        await reinitialize();
      }
    }
  }

  Future<void> attemptReconnection(
    BuildContext context,
    isExternalCamera,
    String callUserId, {
    bool fromStreaming = false,
    bool isStreaming = false,
  }) async {
    // Retry signaling or ICE connection renegotiation
    Future.delayed(const Duration(seconds: 5), () async {
      try {
        await streamingPeerConnection?.dispose();
        streamingPeerConnection = null;

        if (context.mounted) {
          await initializeConnection(
            context,
            callUserId,
            isExternalCamera,
            fromStreaming,
            isStreaming,
          );
          await createOffer(isStreaming);
        }
      } catch (e) {
        _logger.severe("Error restarting connection: $e");
      }
    });
  }

  Future<void> createOffer(bool isStreaming) async {
    try {
      await streamingPeerConnection?.createOffer().then((offer) async {
        await streamingPeerConnection?.setLocalDescription(offer);
        await callStreamingApi(offer.sdp!, isStreaming);
      });
    } catch (e) {
      _logger.severe(e);
    }
  }

  Future<void> callStreamingApi(String sdp, bool isStreaming) {
    return CubitUtils.makeApiCall<VoipState, VoipStateBuilder, void>(
      cubit: this,
      apiState: state.voipApi,
      updateApiState: (final b, final apiState) => b.voipApi.replace(apiState),
      callApi: () async {
        emit(
          state.rebuild(
            (final b) => b
              ..isLiveStreamingLoading = true
              ..isLiveStreamAvailable = true,
          ),
        );
        final response = await apiService.streamingFunction(sdp, isStreaming);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final String location =
              response.headers['location']?.toString() ?? '';
          if (location.isNotEmpty) {
            emit(
              state.rebuild(
                (final b) => b
                  ..isLiveStreamingLoading = true
                  ..location = location,
              ),
            );
            final RTCSessionDescription desc = RTCSessionDescription(
              response.data,
              "answer",
            );
            await createAnswer(desc);
          } else {
            emit(
              state.rebuild(
                (final b) => b
                  ..isLiveStreamingLoading = false
                  ..isLiveStreamAvailable = false
                  ..location = "",
              ),
            );
          }
        } else {
          emit(
            state.rebuild(
              (final b) => b
                ..isLiveStreamingLoading = false
                ..isLiveStreamAvailable = false
                ..location = "",
            ),
          );
        }
      },
    );
  }

  void updateState() => emit(
        state.rebuild(
          (final b) => b
            ..isLiveStreamingLoading = true
            ..isLiveStreamAvailable = true
            ..recordingApi.replace(ApiState())
            ..location = "",
        ),
      );

  Future<void> createAnswer(RTCSessionDescription sdp) async {
    try {
      await streamingPeerConnection!.setRemoteDescription(sdp);
    } catch (e) {
      return;
    }
    emit(state.rebuild((final b) => b..isLiveStreamingLoading = false));
  }

  bool isAudioEnabled() {
    if (localStream == null) {
      return false;
    }

    if (localStream!.getAudioTracks().isNotEmpty) {
      final audioTrack = localStream?.getAudioTracks()[0];
      return audioTrack?.enabled ?? false;
    }
    return false;
  }

  Future<void> onAudioToggle() async {
    if (localRenderer?.srcObject != null) {
      localRenderer?.muted =
          localRenderer == null ? true : !localRenderer!.muted;
      localStream?.getAudioTracks()[0].enabled = !localRenderer!.muted;
      Future.delayed(const Duration(seconds: 2), () async {
        // Delay helps ensure WebRTC doesn't override the setting
        await Helper.setSpeakerphoneOn(
          state.enabledSpeakerInCall,
        ); // Force audio to earpiece
      });
      emit(state.rebuild((final b) => b..muted = !b.muted!));
    }
  }

  void convertCall({
    bool isConverting = false,
  }) {
    streamSubscription?.cancel();
    if (state.isTwoWayCall) {
      shiftTo1WayVideoCall(isConverting: isConverting);
    } else {
      shiftTo2WayVideoCall(isConverting: isConverting);
    }
  }

  void shiftToVideoCallOverlay({
    required BuildContext context,
    String? callType,
    String? callUserId,
    VisitorsModel? visitor,
    String? notificationImage,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                DefaultImages.VIDEO_CALL_IMAGE,
                height: 120,
                width: 160,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                context.appLocalizations.video_call,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                context.appLocalizations.video_call_dialog_description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: CommonFunctions.getDialogDescriptionColor(context),
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomGradientButton(
                onSubmit: () async {
                  Navigator.pop(dialogContext);
                  if (state.isCallConnected) {
                    unawaited(streamSubscription?.cancel());
                    shiftTo2WayVideoCall(isConverting: true);
                  } else {
                    isTwoWayEmit();
                    unawaited(
                      CallingScreen.push(
                        context,
                        callUserId!,
                        false,
                        callType: Constants.doorbellVideoCall,
                        visitor: visitor,
                        notificationImage: notificationImage,
                      ),
                    );
                  }
                },
                label: context.appLocalizations.start_two_way,
              ),
              const SizedBox(height: 20),
              CustomCancelButton(
                onSubmit: () async {
                  Navigator.pop(dialogContext);
                  if (state.isCallConnected) {
                    await shiftTo1WayVideoCall(
                      isConverting: true,
                      fromOneWay: true,
                    );
                  } else {
                    isOneWayEmit();
                    unawaited(
                      CallingScreen.push(
                        context,
                        callUserId!,
                        false,
                        callType: "one_way_video",
                        visitor: visitor,
                        notificationImage: notificationImage,
                      ),
                    );
                  }
                },
                customWidth: 100.w,
                label: context.appLocalizations.start_one_way,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> shiftTo1WayVideoCall({
    bool isConverting = false,
    bool fromOneWay = false,
  }) async {
    await localStream?.dispose();
    localStream = null;
    localRenderer?.srcObject = null;
    await localRenderer?.dispose();
    localRenderer = null;
    localStream = await enableFullLocalStream(true);
    localRenderer = RTCVideoRenderer();
    await localRenderer?.initialize();
    localRenderer?.srcObject = localStream;
    if (localRenderer?.srcObject != null) {
      localRenderer?.muted = state.muted;
    }

    await addAudioTrack();

    if (fromOneWay) {
      await streamSubscription?.cancel();
    }
    // unawaited(EasyLoading.show());
    Constants.showLoader();

    // Future.delayed(const Duration(seconds: 2), EasyLoading.dismiss);
    Future.delayed(const Duration(seconds: 2), Constants.dismissLoader);
    await shiftToAudioCall(isConverting: isConverting, needShifted: false);
    await Future.delayed(const Duration(milliseconds: 100));
    emit(
      state.rebuild(
        (final b) => b
          ..localRenderer = localRenderer
          ..isAudioCall = false
          ..isTwoWayCall = false
          ..isOneWayCall = true,
      ),
    );
  }

  Future<void> shiftToAudioCall({
    bool needShifted = true,
    bool isConverting = false,
    bool onlyAudio = false,
    bool isLoader = false,
  }) async {
    ///TODO: MY NEW NON TESTED IMPLEMENTATION
    if (needShifted) {
      await localStream?.dispose();
      localStream = null;
      localRenderer?.srcObject = null;
      await localRenderer?.dispose();
      localRenderer = null;
      localStream = await enableFullLocalStream(true);
      localRenderer = RTCVideoRenderer();
      await localRenderer?.initialize();
      localRenderer?.srcObject = localStream;
      if (localRenderer?.srcObject != null) {
        localRenderer?.muted = state.muted;
      }

      await addAudioTrack();

      emit(
        state.rebuild(
          (final b) => b
            ..localRenderer = localRenderer
            ..isAudioCall = true
            ..isTwoWayCall = false
            ..isOneWayCall = false,
        ),
      );
    }
    if (isLoader) {
      // unawaited(EasyLoading.show());
      Constants.showLoader();

      // Future.delayed(const Duration(seconds: 2), EasyLoading.dismiss);
      Future.delayed(const Duration(seconds: 2), Constants.dismissLoader);
    }
    unawaited(
      singletonBloc.socketEmitterWithAck(
        roomName: Constants.voip,
        deviceId: selectedDevice!.deviceId,
        request: isConverting
            ? Constants.convertToAudioCall
            : Constants.doorbellAudioCall,
      ),
    );

    unawaited(Helper.setSpeakerphoneOn(state.enabledSpeakerInCall));
    if (onlyAudio) {
      if (state.enabledSpeakerInCall) {
        await streamSubscription?.cancel();
      } else {
        await listenToSensor();
      }
    }
  }

  void shiftTo2WayVideoCall({
    bool shouldEndCall = false,
    bool isConverting = false,
  }) {
    // EasyLoading.show();
    Constants.dismissLoader();

    // Future.delayed(const Duration(seconds: 2), EasyLoading.dismiss);
    Future.delayed(const Duration(seconds: 2), Constants.dismissLoader);
    onVideoToggle(isConverting: isConverting);
  }

  void recordedVideoToggle(bool isPlaying) {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
      emit(
        state.rebuild(
          (final b) => b
            ..videoController = videoController
            ..isPlaying = false,
        ),
      );
    } else {
      videoController!.play();
      emit(
        state.rebuild(
          (final b) => b
            ..videoController = videoController
            ..isPlaying = true,
        ),
      );
    }
  }

  Future<void> addAudioTrack() async {
    try {
      final audioTrack = localStream?.getAudioTracks();
      localStream?.getAudioTracks()[0].enabled = true;
      localStream?.getAudioTracks().forEach((track) async {
        track.enabled = true;
        if (localStream != null && callingPeerConnection != null) {
          await callingPeerConnection?.addTrack(track, localStream!);
        }
      });

      await _audioTransceiver?.sender.replaceTrack(audioTrack![0]);
    } catch (e) {
      _logger.fine("Error in Adding Audio Track, $e");
    }
  }

  Future<void> addVideoTrack() async {
    try {
      final videoTrack = localStream?.getVideoTracks();

      localStream?.getVideoTracks()[0].enabled = true;

      // await _videoTransceiver?.sender.replaceTrack(videoTrack![0]);

      localStream?.getVideoTracks().forEach((track) async {
        track.enabled = true;
        if (track.kind == "video" &&
            localStream != null &&
            callingPeerConnection != null) {
          await callingPeerConnection?.addTrack(track, localStream!);
        }
      });
      // } catch (e) {}

      await _videoTransceiver?.sender.replaceTrack(videoTrack![0]);
    } catch (e) {
      _logger.fine("Error in Adding Video Track, $e");
    }
  }

  Future<void> onVideoToggle({
    bool isConverting = false,
  }) async {
    await localStream?.dispose();
    localStream = null;
    localRenderer?.srcObject = null;
    await localRenderer?.dispose();
    localRenderer = null;
    localStream = await enableFullLocalStream(false);
    localRenderer = RTCVideoRenderer();
    await localRenderer?.initialize();
    localRenderer?.srcObject = localStream;
    if (localRenderer?.srcObject != null) {
      localRenderer?.muted = state.muted;
    }

    await addAudioTrack();

    await addVideoTrack();

    _logger.fine(callingPeerConnection?.getRemoteStreams());
    if (callingPeerConnection?.getRemoteStreams().isNotEmpty ?? false) {
      remoteRenderer?.srcObject = callingPeerConnection!.getRemoteStreams()[0];
      emit(
        state.rebuild((final b) => b..remoteRenderer = remoteRenderer),
      );
    }

    unawaited(
      singletonBloc.socketEmitterWithAck(
        roomName: Constants.voip,
        deviceId: selectedDevice!.deviceId,
        request: isConverting
            ? Constants.convertToVideoCall
            : Constants.doorbellVideoCall,
      ),
    );

    // isTwoWayEmit();

    emit(
      state.rebuild(
        (final b) => b
          ..localRenderer = localRenderer
          ..isTwoWayCall = true
          ..isOneWayCall = false
          ..isAudioCall = false,
      ),
    );
  }

  void isOneWayEmit() {
    emit(
      state.rebuild(
        (final b) => b
          ..isAudioCall = false
          ..isTwoWayCall = false
          ..isOneWayCall = true,
      ),
    );
  }

  void isTwoWayEmit() {
    emit(
      state.rebuild(
        (final b) => b
          ..isAudioCall = false
          ..isTwoWayCall = true
          ..isOneWayCall = false,
      ),
    );
  }

  void isAudioEmit() {
    emit(
      state.rebuild(
        (final b) => b
          ..isAudioCall = true
          ..isTwoWayCall = false
          ..isOneWayCall = false,
      ),
    );
  }

  bool isVideoEnabled() {
    if (localStream != null) {
      final videoTrack = localStream?.getVideoTracks()[0];
      return videoTrack?.enabled ?? false;
    }
    return false;
  }

  void toggleCallControlSheet({required bool isExpanded}) {
    emit(
      state.rebuild((final b) => b..isCallControlsSheetExpanded = isExpanded),
    );
  }

  Future<void> getStartUpApis(StartupBloc bloc, String callUserId) async {
    final BuiltList<UserDeviceModel> doorBells =
        bloc.state.doorbellApi.data ?? await bloc.getDoorbells();
    updateDoorBells(doorBells, callUserId);
  }

  void updateDoorBells(
    BuiltList<UserDeviceModel> userDoorBell,
    String callUserId,
  ) {
    emit(state.rebuild((final b) => b..userDoorBell.replace(userDoorBell)));
    selectedDevice = userDoorBell.firstWhere((e) => e.callUserId == callUserId);
  }

  void updateSpeaker(bool enabledSpeakerInCall) {
    emit(
      state
          .rebuild((final b) => b..enabledSpeakerInCall = enabledSpeakerInCall),
    );
  }

  Timer? timer;

  void resetTimer() {
    timer?.cancel();
    emit(state.rebuild((final b) => b..seconds = 0));
  }

  void startTimer({bool isZero = true}) {
    if (isZero) {
      emit(state.rebuild((final b) => b..seconds = 0));
    }

    if (timer != null && timer!.isActive) {
      return;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.rebuild((final b) => b..seconds = b.seconds! + 1));
    });
  }

  Future<void> reinitialize({bool forRecording = false}) async {
    _logger.fine('reinitialize(forRecording: $forRecording) called.');
    await _disposeStreamingResources();
    updateSpeakerStatus(false);

    // unawaited(EasyLoading.dismiss());
    Constants.dismissLoader();

    if (!forRecording) {
      emit(
        state.rebuild(
          (final b) => b
            ..isLiveModeActivated = true
            ..voipApi.replace(ApiState())
            ..recordingApi.replace(ApiState())
            ..isRecordedStreamLoading = false
            ..isAudioCall = false
            ..isOneWayCall = false
            ..isTwoWayCall = false
            ..isCalling = false
            ..isSilentAudioCall = false
            ..enabledSpeakerInCall = true
            ..isMicrophoneOnStreamEnabled = false
            ..isCallControlsSheetExpanded = true
            ..isInternetConnected = true
            ..muted = false
            ..location = ""
            ..meetingConnected = false
            ..isReAttempt = false
            ..remoteRenderer = null
            ..localRenderer = null
            ..meetingId = ""
            ..seconds = 0
            ..isLiveStreamingLoading = true
            ..isLiveStreamAvailable = true,
        ),
      );
      startTimer();
    } else {
      emit(
        state.rebuild(
          (final b) => b
            ..isRecordedStreamLoading = true
            ..voipApi.replace(ApiState())
            ..recordingApi.replace(ApiState())
            ..isCameraOnStreamEnabled = false
            ..isCallStarted = false
            ..isReconnecting = false
            ..isMicrophoneOnStreamEnabled = false
            ..localRenderer = null
            ..videoController = null
            ..enabledSpeakerInCall = true,
        ),
      );
      startTimer(isZero: false);
    }
  }

  Future<void> disposeWithoutRenders() async {
    try {
      emit(state.rebuild((final b) => b..seconds = 0));
      await _disposeStreamingResources();
      _videoTransceiver = null;
      _audioTransceiver = null;
      resetTimer();
      emit(
        state.rebuild(
          (final b) => b
            ..voipApi.replace(ApiState())
            ..recordingApi.replace(ApiState())
            ..isCameraOnStreamEnabled = false
            ..isCallStarted = false
            ..isReconnecting = false
            ..videoController = videoController
            ..isMicrophoneOnStreamEnabled = false
            ..localRenderer = null
            ..remoteRenderer = null
            ..enabledSpeakerInCall = true
            ..isCallConnected = false,
        ),
      );
      _logger.fine('disposeWithoutRenders → state reset after cleanup.');
    } catch (e) {
      // unawaited(EasyLoading.dismiss());
      Constants.dismissLoader();

      _logger.fine(e);
    }
  }

  Future<void> dispose() async {
    try {
      if (localStream != null) {
        _logger.fine('dispose() → localStream present, calling endSilentCall.');
        await endSilentCall();
      } else {
        _logger
            .fine('dispose() → no localStream, calling disposeWithoutRenders.');
        await disposeWithoutRenders();
      }
      emit(
        state.rebuild(
          (final b) => b..isLiveModeActivated = true,
        ),
      );
    } catch (e) {
      _logger.fine(e);
    }
  }

  Future<void> endCall() async {
    try {
      callingEndTimer?.cancel();
      updateIsCallConnected(false);
      await disposeWithoutRenders();
      // unawaited(EasyLoading.dismiss());
      Constants.dismissLoader();

      // if (state.isCallConnected) {
      unawaited(
        singletonBloc.socketEmitterWithAck(
          roomName: Constants.voip,
          deviceId: selectedDevice!.deviceId,
          request: Constants.notificationEndCall,
        ),
      );
      await stopService();
      // }

      emit(
        state.rebuild(
          (final b) => b..isLiveModeActivated = true,
        ),
      );

      return;
    } catch (e) {
      // unawaited(EasyLoading.dismiss());
      Constants.dismissLoader();

      _logger.fine(e);
    }
  }

  Future<void> stopService() async {
    if (Platform.isAndroid) {
      final sdkInt = await _getSdkInt();
      if (sdkInt >= 35) {
        // ✅ Android 16 (API 35+) → must use CallKeep / ConnectionService
        await FlutterCallkeep().endAllCalls();
      } else {
        await FlutterForegroundTask.stopService();
      }
    } else {
      await FlutterForegroundTask.stopService();
    }
  }

  Future<void> endSilentCall({bool isChangeMode = false}) async {
    try {
      if (!isChangeMode) {
        emit(
          state.rebuild(
            (final b) => b
              ..isLiveModeActivated = true
              ..isCallConnected = false,
          ),
        );
      }
      unawaited(disposeWithoutRenders());
      if (remoteRenderer != null && remoteRenderer?.textureId != null) {
        // await remoteRenderer?.dispose();
        remoteRenderer = null;
        emit(
          state.rebuild(
            (final b) => b
              ..localRenderer = null
              ..remoteRenderer = null
              ..isSilentAudioCall = false,
          ),
        );
      }

      return;
    } catch (e) {
      _logger.fine(e);
    }
  }

  Future<void> endStreamingCall(
    BuildContext context,
  ) async {
    _logger.fine('endStreamingCall requested.');
    callingEndTimer?.cancel();
    final bool hasMediaSession =
        _hasActiveStreamingSession || videoController != null;
    final bool shouldNotifyServer = selectedDevice != null &&
        (hasMediaSession ||
            state.isSilentAudioCall ||
            state.isCameraOnStreamEnabled ||
            state.isCallConnected ||
            state.isCallStarted);

    if (!hasMediaSession && !shouldNotifyServer) {
      _logger.fine('No active streaming session to end.');
      return;
    }

    try {
      if (shouldNotifyServer && selectedDevice != null) {
        unawaited(
          singletonBloc.socketEmitterWithAck(
            roomName: Constants.voip,
            deviceId: selectedDevice!.deviceId,
            request: Constants.notificationEndCall,
          ),
        );
        if (state.isSilentAudioCall || state.isCameraOnStreamEnabled) {
          unawaited(
            singletonBloc.socketEmitterWithAck(
              roomName: Constants.voip,
              deviceId: selectedDevice!.deviceId,
              request: Constants.notificationSilentEndCall,
            ),
          );
        }
      }

      await _disposeStreamingResources();
    } catch (e) {
      _logger.fine(e);
    } finally {
      _logger.fine('endStreamingCall → stopping foreground service.');
      await stopService();
      emit(
        state.rebuild(
          (final b) => b
            ..isLiveModeActivated = true
            ..isCameraOnStreamEnabled = false
            ..isCallConnected = false
            ..isCallStarted = false
            ..isMicrophoneOnStreamEnabled = false
            ..enabledSpeakerInCall = true
            ..isSilentAudioCall = false
            ..muted = false
            ..seconds = 0
            ..remoteRenderer = remoteRenderer
            ..localRenderer = localRenderer
            ..videoController = videoController,
        ),
      );
    }
  }

  Future<void> endOnlyCall() async {
    unawaited(
      singletonBloc.socketEmitterWithAck(
        roomName: Constants.voip,
        deviceId: selectedDevice!.deviceId,
        request: Constants.notificationEndCall,
      ),
    );
    await stopService();
  }

  Future<void> silentEndCall() async {
    try {
      if (localRenderer?.srcObject != null) {
        localRenderer?.muted = true;
      }
      unawaited(
        singletonBloc.socketEmitterWithAck(
          roomName: Constants.voip,
          deviceId: selectedDevice!.deviceId,
          request: Constants.notificationSilentEndCall,
        ),
      );
      await stopService();
      await localStream?.dispose();
      localStream = null;
      if (localRenderer != null && localRenderer?.textureId != null) {
        await localRenderer?.dispose();
        localRenderer = null;
      }
      emit(
        state.rebuild(
          (final b) => b
            ..localRenderer = null
            ..muted = true
            ..isCallConnected = false
            ..isReconnecting = false,
        ),
      );
      localRenderer = RTCVideoRenderer();
      await localRenderer?.initialize();
      return;
    } catch (e) {
      _logger.fine(e);
    }
  }

  bool isSeeking = false;
  bool scrollRelease = false;
  bool isScrolling = false;
  bool isPlaying = false;
  double? maxScroll;
  // ScrollController scrollController = ScrollController();
  DateTime calendarDate = DateTime.now();
  DateTime timerDate = DateTime.now();

  bool get areRecordedVideosLoading =>
      state.recordingApi.data != null &&
      ((state.recordingApi.data?.aiAlert ?? <AiAlert>[].build()).isNotEmpty) &&
      videoController != null;

  void updatePlaying({bool isPlay = true}) {
    isPlaying = isPlay;
    emit(
      state.rebuild(
        (b) => b..isPlaying = isPlay,
      ),
    );
  }

  void updateVideoTimer(DateTime time) {
    emit(
      state.rebuild(
        (final b) =>
            b..videoTimer = DateFormat("MM-dd-yyyy HH:mm:ss").format(time),
      ),
    );
  }

  /// Get the real timestamp for a given video position using M3U8 time mapping
  DateTime? getRealTimestampForVideoPosition(double videoPositionSeconds) {
    // if (m3u8TimeMapping == null) {
    // Fallback to simple calculation if no time mapping available
    // if (state.recordingApi.data != null) {
    final startTime =
        DateTime.parse(state.recordingApi.data!.fileStartTime).toLocal();
    return startTime.add(Duration(seconds: videoPositionSeconds.toInt()));
    // }
    // return null;
    // }

    // return apiService.getRealTimestampForVideoPosition(
    //   m3u8TimeMapping!,
    //   videoPositionSeconds,
    // );
  }

  /// Get the real timestamp for a given video position using M3U8 time mapping
  SegmentDateTime? getRealTimestampForScrollPosition(
    double videoPositionSeconds,
  ) {
    // if (m3u8TimeMapping == null) {
    //   // Fallback to simple calculation if no time mapping available
    //   if (state.recordingApi.data != null) {
    //     final startTime =
    //         DateTime.parse(state.recordingApi.data!.fileStartTime).toLocal();
    //     return startTime.add(Duration(seconds: videoPositionSeconds.toInt()));
    //   }
    //   return null;
    // }

    return apiService.getRealTimestampForScrollPosition(
      m3u8TimeMapping!,
      videoPositionSeconds,
    );
  }

  /// Get the video position for a given real timestamp using M3U8 time mapping
  double? getVideoPositionForRealTimestamp(DateTime realTimestamp) {
    if (m3u8TimeMapping == null) {
      // Fallback to simple calculation if no time mapping available
      if (state.recordingApi.data != null) {
        final startTime =
            DateTime.parse(state.recordingApi.data!.fileStartTime).toLocal();
        return realTimestamp.difference(startTime).inSeconds.toDouble();
      }
      return null;
    }

    return apiService.getVideoPositionForRealTimestamp(
      m3u8TimeMapping!,
      realTimestamp,
    );
  }

  /// Test method to extract durations from M3U8 file URLs
  Future<void> testDurationExtraction(String m3u8Url) async {
    try {
      _logger.fine('Testing duration extraction from: $m3u8Url');

      // Extract all durations
      final durations = await apiService.extractDurationsFromM3U8(m3u8Url);
      _logger.fine('Extracted ${durations.length} duration values');

      // Get statistics
      final stats = await apiService.getDurationStatistics(m3u8Url);
      _logger.fine('Duration statistics: $stats');

      // Show first few durations as examples
      if (durations.isNotEmpty) {
        _logger.fine('First 5 duration examples:');
        for (int i = 0; i < math.min(5, durations.length); i++) {
          final duration = durations[i];
          _logger.fine(
            '  ${duration['fileName']}: ${duration['duration']}s (${duration['extractedDuration']})',
          );
        }
      }

      // Parse with URL duration method
      final timeMapping = await apiService.parseM3U8WithUrlDuration(m3u8Url);
      _logger.fine(
        'Created time mapping with ${timeMapping.segments.length} segments, total duration: ${timeMapping.totalDuration}s',
      );
    } catch (e) {
      _logger.severe('Error testing duration extraction: $e');
    }
  }

  /// Update video timer with accurate time based on current video position
  void updateVideoTimerWithAccurateTime() {
    if (videoController == null || !videoController!.value.isInitialized) {
      return;
    }

    final currentPosition =
        videoController!.value.position.inSeconds.toDouble();
    final realTimestamp = getRealTimestampForVideoPosition(currentPosition);

    if (realTimestamp != null) {
      updateVideoTimer(realTimestamp);
    }
  }

  /// Seek to a specific real timestamp with accurate positioning
  Future<void> seekToRealTimestamp(DateTime targetTimestamp) async {
    if (videoController == null || !videoController!.value.isInitialized) {
      return;
    }

    final videoPosition = getVideoPositionForRealTimestamp(targetTimestamp);
    if (videoPosition != null) {
      await videoController!.seekTo(Duration(seconds: videoPosition.toInt()));
      updateVideoTimer(targetTimestamp);
    }
  }

  Future<void> getRecording({
    required String callUserId,
    DateTime? notificationTime,
    bool isExternalCamera = false,
  }) async {
    emit(
      state.rebuild(
        (b) => b
          ..recordingApi.replace(ApiState())
          ..recordingApi.isApiInProgress = true
          ..recordingApi.currentPage = 0,
      ),
    );
    final String uuid = await CommonFunctions.getUUID();
    return CubitUtils.makeApiCall<VoipState, VoipStateBuilder,
        StreamingAlertsData>(
      cubit: this,
      apiState: state.recordingApi,
      updateApiState: (final b, final apiState) =>
          b.recordingApi.replace(apiState),
      callApi: () async {
        emit(state.rebuild((final b) => b..isRecordedStreamLoading = true));
        if (notificationTime == null) {
          notificationTime = calendarDate;
        } else {
          calendarDate = notificationTime!;
        }
        final StreamingAlertsData data = await apiService.getRecodedM3U8(
          calendarDate,
          callUserId,
          uuid,
          this,
        );

        calendarDate = DateTime.parse(data.fileStartTime).toLocal();
        timerDate = DateTime.parse(data.fileStartTime).toLocal();
        emit(
          state.rebuild((final b) => b..videoTimer = ""),
        );
        if (data.duration != 0) {
          unawaited(initPlayer(data, isExternalCamera: isExternalCamera));
        } else {
          emit(
            state.rebuild((final b) => b..isRecordedStreamLoading = false),
          );
        }

        return data;
      },
      onError: (dioException) {
        emit(
          state.rebuild(
            (final b) => b
              ..isRecordedStreamLoading = false
              ..videoController = null,
          ),
        );
      },
    );
  }

  Future<void> disposeVideoController() async {
    if (videoController != null) {
      await videoController!.dispose();
    }
    // videoController = null;
    m3u8TimeMapping = null; // Clear M3U8 time mapping when disposing
    emit(state.rebuild((b) => b..videoController = videoController));
  }

  Future<List<M3U8Second>> buildM3U8Timeline(
    String path, {
    double pixelsPerSecond = 5,
  }) async {
    final response = await http.get(Uri.parse(path));
    if (response.statusCode != 200) {
      throw Exception('Failed to load .m3u8 file');
    }

    final lines = response.body.split('\n');

    final List<M3U8Second> list = [];
    double currentPixel = 0;
    double carriedover = 0;
    double carryOver = 0; // store leftover fractional seconds
    int secondCounter = 1;
    int position = 0;

    double? currentDuration;

    for (final line in lines) {
      if (line.startsWith('#EXTINF:')) {
        final durationStr = line.split(':')[1].split(',')[0];
        currentDuration = double.tryParse(durationStr);
      } else if (line.isNotEmpty && !line.startsWith('#')) {
        if (currentDuration != null) {
          final fname = line.split('/').last;

          final regex = RegExp(r'(\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2})');
          final match = regex.firstMatch(fname);

          if (match != null) {
            final tsStr = match.group(1)!;
            final startTime = DateFormat("yyyy-MM-dd HH-mm-ss")
                .parseUTC(tsStr.replaceAll("_", " "))
                .toLocal();

            // Add carryOver to this segment’s duration
            final double segDuration = currentDuration + carryOver;

            final int wholeSeconds = segDuration.floor();
            carryOver =
                segDuration - wholeSeconds; // leftover fraction to push forward

            carriedover = carriedover + carryOver;

            _logger
                .fine("carry over $carryOver  ||  carried over $carriedover");

            for (int i = 0; i < wholeSeconds; i++) {
              final tickTime = startTime.add(Duration(seconds: i));

              list.add(
                M3U8Second(
                  timestamp: DateFormat("yyyy-MM-dd HH:mm:ss").format(tickTime),
                  pixel: currentPixel,
                  position: position,
                  second: secondCounter,
                ),
              );

              currentPixel += pixelsPerSecond;
              secondCounter++;
              position++;
            }
          }
          currentDuration = null;
        }
      }
    }

// ⚡ After loop, if carryOver ~ 1s, push a final second
    if (carriedover >= 1000) {
      final lastTime =
          DateTime.parse(list.last.timestamp).add(const Duration(seconds: 1));
      list.add(
        M3U8Second(
          timestamp: DateFormat("yyyy-MM-dd HH:mm:ss").format(lastTime),
          pixel: currentPixel,
          position: position,
          second: secondCounter,
        ),
      );
    }

    return list;
  }

  Future<void> initPlayer(
    StreamingAlertsData data, {
    bool isExternalCamera = false,
  }) async {
    try {
      // Validate input data
      if (data.fileUrl == null || data.fileUrl!.isEmpty) {
        _logger.severe('File URL is null or empty');
        emit(state.rebuild((final b) => b..isRecordedStreamLoading = false));
        return;
      }

      // Dispose existing controller
      await disposeVideoController();

      // Reset state
      emit(
        state.rebuild(
          (b) => b
            ..videoController = null
            ..isPlaying = false
            ..isVideoInitialized = false
            ..isRecordedStreamLoading = true,
        ),
      );

      _logger.fine('Initializing video player with URL: ${data.fileUrl}');
      // Parse M3U8 file to create time mapping for accurate synchronization
      try {
        timestampList = await buildM3U8Timeline(
          data.fileUrl!,
        );
        m3u8TimeMapping = await apiService.parseM3U8WithUrlDuration(
          data.fileUrl!,
        );
      } catch (e) {
        _logger.warning('Failed to parse M3U8 time mapping: $e');
        m3u8TimeMapping = null;
      }
      // videoController = VlcPlayerController.network(
      //   data.fileUrl!,
      //   hwAcc: HwAcc.full,
      //   options: VlcPlayerOptions(
      //     rtp: VlcRtpOptions(["--no-rtsp-tcp"]),
      //     video: VlcVideoOptions(["--no-drop-late-frames", "--no-skip-frames"]),
      //   ),
      // );
      // emit(
      //   state.rebuild(
      //     (b) => b
      //       ..videoController = videoController
      //       ..isPlaying = true
      //       ..isRecordedStreamLoading = false,
      //   ),
      // );
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(
          data.fileUrl!,
        ),
        httpHeaders: {
          "Authorization": "Bearer ${config.key}",
          "User-Agent": "FlutterApp",
        },
        formatHint: VideoFormat.hls,
        // viewType: VideoViewType.textureView,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      if (videoController == null) {
        _logger.severe('Failed to create video controller');
        emit(state.rebuild((final b) => b..isRecordedStreamLoading = false));
        return;
      }

      Timer? tim;

      tim = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (videoController != null) {
          if (videoController!.value.isInitialized) {
            tim?.cancel();
            emit(
              state.rebuild(
                (b) => b.isVideoInitialized = true,
              ),
            );
          }
        }
      });
      // Initialize with timeout
      try {
        await videoController!.initialize();
        // await videoController!.seekTo(
        //     Duration(seconds: videoController!.value.duration.inSeconds - 1));
        // videoController!.value = videoController!.value.copyWith(
        //   duration: Duration(seconds: m3u8TimeMapping!.totalDuration.toInt()),
        // );
        emit(
          state.rebuild(
            (b) => b
              ..videoController = videoController
              ..isPlaying = false
              ..isRecordedStreamLoading = false,
          ),
        );

        _logger.fine("Video initialized successfully");
      } catch (e) {
        _logger.fine("Video init error: $e");
      }
      await videoController!.setVolume(1);

      // Get duration
      final duration = videoController!.value.duration;
      if (duration.inSeconds <= 0) {
        _logger.warning(
          'Video duration is invalid: ${duration.inSeconds} seconds',
        );
      }

      // Update state with initialized controller

      // Calculate and set video timer using M3U8 time mapping if available
      try {
        if (m3u8TimeMapping != null && m3u8TimeMapping!.segments.isNotEmpty) {
          // Use the last segment's end time for accurate end time
          final lastSegment = m3u8TimeMapping!.segments.last;
          final endTime = lastSegment.startTime.add(
            Duration(milliseconds: (lastSegment.duration * 1000).round()),
          );

          _logger.fine('Using M3U8 time mapping for end time: $endTime');
          emit(
            state.rebuild(
              (b) => b..videoTimer = endTime.toIso8601String(),
            ),
          );
        } else {
          // Fallback to original calculation
          final localTime = DateTime.parse(data.fileStartTime).toLocal();
          final endTime = localTime.add(duration - const Duration(seconds: 3));
          await videoController?.seekTo(duration);
          emit(
            state.rebuild(
              (b) => b..videoTimer = endTime.toIso8601String(),
            ),
          );
        }
      } catch (e) {
        _logger.warning('Error calculating video timer: $e');
      }

      _logger.fine('Video player initialized successfully');
    } catch (e) {
      _logger.severe('Error initializing video player: $e');

      // Handle specific error types
      if (e is PlatformException) {
        if (e.message?.contains("VideoError") == true) {
          _logger.warning('Video error detected, attempting retry...');
          // Add retry logic with delay to prevent infinite loops
          await Future.delayed(const Duration(seconds: 2));
          // Only retry once to prevent infinite recursion
          if (data.fileUrl != null && data.fileUrl!.isNotEmpty) {
            await initPlayer(data, isExternalCamera: isExternalCamera);
          }
        } else {
          _logger.severe('Platform exception: ${e.message}');
          emit(state.rebuild((final b) => b..isRecordedStreamLoading = false));
        }
      } else if (e is TimeoutException) {
        _logger.severe('Video initialization timed out');
        emit(state.rebuild((final b) => b..isRecordedStreamLoading = false));
      } else {
        _logger.severe('Unknown error during video initialization: $e');
        emit(state.rebuild((final b) => b..isRecordedStreamLoading = false));
      }
    }
  }

  void toggleFilter(
    String filter,
    bool value, {
    required List<String> children,
  }) {
    if (value) {
      emit(state.rebuild((final b) => b..tempAiAlertList.add(filter)));
      if (children.isNotEmpty) {
        for (final child in children) {
          emit(state.rebuild((final b) => b..tempAiAlertList.add(child)));
        }
      }
    } else {
      emit(state.rebuild((final b) => b..tempAiAlertList.remove(filter)));
      if (children.isNotEmpty) {
        for (final child in children) {
          emit(state.rebuild((final b) => b..tempAiAlertList.remove(child)));
        }
      }
    }
  }

  void activateLiveMode(bool isLiveModeActivated) {
    emit(
      state.rebuild((final b) => b..isLiveModeActivated = isLiveModeActivated),
    );
  }

  Future<void> changeLiveMode(
    BuildContext context,
    String callUserId, {
    bool fromStreaming = true,
    bool? isStreaming = false,
  }) async {
    if (state.isLiveModeActivated) {
      unawaited(endSilentCall(isChangeMode: true));
      emit(
        state.rebuild(
          (final b) => b
            ..isLiveModeActivated = !b.isLiveModeActivated!
            ..isLiveStreamingLoading = true
            ..isReconnecting = false
            ..isLiveStreamAvailable = false
            ..isRecordedStreamLoading = false
            ..voipApi.replace(ApiState())
            ..recordingApi.replace(ApiState()),
        ),
      );
    } else {
      unawaited(videoController?.pause());
      unawaited(videoController?.dispose());
      videoController = null;
      emit(
        state.rebuild((b) => b..videoController = videoController),
      );

      emit(
        state.rebuild(
          (final b) => b
            ..isLiveStreamingLoading = true
            ..voipApi.replace(ApiState())
            ..recordingApi.replace(ApiState())
            ..recordingApi.data = null
            ..isLiveModeActivated = !b.isLiveModeActivated!
            ..isReconnecting = false
            ..isRecordedStreamLoading = false
            ..isLiveStreamAvailable = true,
        ),
      );
      // if (context.mounted) {
      await initializeRenders();
      // if (context.mounted) {
      await initiateVoipWithDoorBell(
        context.mounted ? context : context,
        callUserId,
        isStreaming: isStreaming!,
        fromStreaming: fromStreaming,
      );
    }
    // }
    // }
  }

  void resetFilters() {
    emit(state.rebuild((final b) => b..tempAiAlertList.clear()));
    emit(state.rebuild((final b) => b..confirmedAlertFilters.clear()));
  }

  void copySelectedFiltersToTempFilters() {
    emit(state.rebuild((final b) => b..tempAiAlertList.clear()));
    emit(
      state.rebuild(
        (final b) => b..tempAiAlertList.addAll(b.confirmedAlertFilters.build()),
      ),
    );
  }

  void applyFilters(BuildContext context, String callUserId) {
    emit(state.rebuild((final b) => b..tempAiAlertList.clear()));
    emit(
      state.rebuild(
        (final b) => b..confirmedAlertFilters.addAll(b.tempAiAlertList.build()),
      ),
    );
    // getRecording(callUserId: callUserId,isExternalCamera:isExternalCamera);
    Navigator.pop(context);
  }

  bool isAnyChildOrParentSelected({
    required String parent,
    required List<String> children,
  }) {
    return state.tempAiAlertList.contains(parent) ||
        children.any((element) => state.tempAiAlertList.contains(element));
  }

  Future<void> toggleCalendarDate(
    BuildContext context,
    String callUserId,
    bool isExternalCamera,
  ) async {
    final value = await showCustomDatePicker(
      context: context,
      value: [calendarDate],
    );
    if (value != null && context.mounted) {
      calendarDate = DateTime(
        value[0].year,
        value[0].month,
        value[0].day,
      );

      await getRecording(
        callUserId: callUserId,
        isExternalCamera: isExternalCamera,
      );
    }
  }

  // Add a method to monitor connection during fullscreen transitions
  Future<void> handleFullscreenTransition(bool isEntering) async {
    if (isEntering) {
      // Ensure connection is stable before entering fullscreen
      if (streamingPeerConnection != null) {
        final connectionState = streamingPeerConnection!.connectionState;
        if (connectionState ==
            RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
          // Connection is stable, proceed with fullscreen
          updateIsFullScreen(true);
        } else {
          // Wait for connection to stabilize
          await Future.delayed(const Duration(milliseconds: 1000));
          updateIsFullScreen(true);
        }
      }
    }
  }
}
