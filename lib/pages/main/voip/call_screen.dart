import 'dart:async';
import 'dart:io';

import 'package:admin/bloc/singleton_bloc.dart';
import 'package:admin/bloc/startup_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/voice_control/bloc/voice_control_bloc.dart';
import 'package:admin/pages/main/voice_control/component/voice_control_audio_visualizer.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/audio_call.dart';
import 'package:admin/pages/main/voip/components/call_controls.dart';
import 'package:admin/pages/main/voip/components/remote_render_widget.dart';
import 'package:admin/pages/main/voip/components/speaker.dart';
import 'package:admin/pages/main/voip/components/video_call.dart';
import 'package:admin/utils/navigator.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:admin/widgets/progress_indicator.dart';
import 'package:admin/widgets/scaffold.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({
    super.key,
    required this.callUserId,
    required this.fromStreaming,
    this.visitor,
    this.notificationImage,
    required this.callType,
  });

  final String callUserId;
  final VisitorsModel? visitor;
  final String? notificationImage;

  final bool fromStreaming;
  final String callType;

  static const routeName = 'callingScreen';

  static Future<void> push(
    final BuildContext context,
    String callUserId,
    bool fromStreaming, {
    VisitorsModel? visitor,
    String? notificationImage,
    required String callType,
  }) {
    singletonBloc.removeInstance();
    return pushMaterialPageRoute(
      context,
      name: routeName,
      builder: (final _) => CallingScreen(
        callUserId: callUserId,
        fromStreaming: fromStreaming,
        callType: callType,
        visitor: visitor,
        notificationImage: notificationImage,
      ),
    ).then((_) {
      final navigatorState = singletonBloc.navigatorKey?.currentState;
      if (navigatorState == null) {
        return;
      }
      final context = navigatorState.context;
      if (!context.mounted) {
        return;
      }
      VoiceControlBloc.of(context).reinitializeWakeWord(context);
      // SpeechRecognition.instance.initSpeechState(context);
    });
  }

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen>
    with WidgetsBindingObserver {
  late VoipBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();

    bloc = VoipBloc.of(context);

    if (Platform.isAndroid) {
      unawaited(
        Helper.setSpeakerphoneOn(false),
      );
    } else {
      unawaited(
        SpeakerphoneController.setSpeakerphoneOn(
          false,
        ),
      );
    }
    // Mirror the hardware route so first speaker toggle actually enables loud audio.
    bloc..updateSpeaker(false)
    ..socketListener(context);
    if (widget.callType == Constants.doorbellAudioCall ||
        widget.callType == "audio") {
      bloc.listenToSensor();
    }
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(initConnectivity);
    final device = StartupBloc.of(context)
        .state
        .userDeviceModel!
        .firstWhere((e) => e.callUserId == widget.callUserId);
    bloc
      ..selectedDevice = device
      ..initializeRenders()
      ..createCall(
        context,
        callUserId: widget.callUserId,
        isExternalCamera: false,
        isStreaming: false,
        callType: widget.callType,
      )
      ..updateIsOnCallingScreen(true);
  }

  String getCallType() {
    if (bloc.state.isTwoWayCall) {
      return Constants.doorbellVideoCall;
    } else if (bloc.state.isOneWayCall) {
      return Constants.doorbellOneWayVideo;
    } else {
      return Constants.doorbellAudioCall;
    }
  }

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  bool isVoipInitialized = false;

  Future<void> detectNetworkChange() async {
    final currentBSSID = await bloc.wifiInfo.getWifiBSSID();
    if (bloc.lastBSSID != null && currentBSSID != bloc.lastBSSID) {
      logger
        ..fine('Wi-Fi network changed! Trigger WebRTC reconnection.')
        ..fine('ghora ${getCallType()}');
      unawaited(bloc.socketListener(context.mounted ? context : context));
      unawaited(bloc.callingPeerConnection?.close());
      unawaited(bloc.callingPeerConnection?.dispose());
      unawaited(bloc.localStream?.dispose());
      bloc.callingPeerConnection = null;
      unawaited(
        bloc.createCall(
          context.mounted ? context : context,
          callType: getCallType(),
          callUserId: widget.callUserId,
          isStreaming: false,
          isNetworkSwitch: true,
          isExternalCamera: false,
        ),
      );
    }
    bloc.lastBSSID = currentBSSID;
  }

  Future<void> initConnectivity(
    List<ConnectivityResult> connectivityResult,
  ) async {
    if (!isVoipInitialized) {
      isVoipInitialized = true;
      return;
    }
    // final bloc = VoipBloc.of(context);
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      unawaited(detectNetworkChange());

      // bloc.updateIsInternetConnected(true);
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      unawaited(detectNetworkChange());

      // bloc.updateIsInternetConnected(true);
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      unawaited(detectNetworkChange());

      // bloc.updateIsInternetConnected(true);
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      unawaited(detectNetworkChange());

      // bloc.updateIsInternetConnected(true);
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // bloc.updateIsInternetConnected(false);
    }
  }

  @override
  void dispose() {
    bloc.streamSubscription?.cancel();
    WakelockPlus.disable();
    _connectivitySubscription.cancel();
    if (bloc.state.callValue != null) {
      bloc
        ..toggleSpeaker(isEnable: true, isCalling: true)
        ..updateIsCallConnected(false)
        ..updateIsOnCallingScreen(false)
        ..disposeWithoutRenders()
        ..updateCallValue(null);
    } else {
      bloc
        ..toggleSpeaker(isEnable: true, isCalling: true)
        ..endCall()
        ..updateIsOnCallingScreen(false)
        ..updateCallValue(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = VoipBloc.of(context);
    // EasyLoading.dismiss();
    // bloc.emit(
    //   bloc.state.rebuild((final b) => b..isCallConnected = true),
    // );

    final startupBloc = StartupBloc.of(context);

    // final height = MediaQuery.of(context).size.height;
    return PopScope(
      onPopInvokedWithResult: (_, r) async {
        await bloc.streamingPeerConnection?.dispose();
        await bloc.callingPeerConnection?.dispose();
        bloc
          ..streamingPeerConnection = null
          ..callingPeerConnection = null;
      },
      child: VoipBlocBuilder(
        builder: (context, state) {
          // if (state.userDoorBell.isEmpty) {
          //   return const AppScaffold(
          //     body: Center(child: PrimaryCircularLoading()),
          //   );
          // }
          final UserDeviceModel device =
              (startupBloc.state.doorbellApi.data ?? [].toList().toBuiltList())
                  .singleWhere((e) => e.callUserId == widget.callUserId);
          return VoipBlocSelector.isAudioCall(
            builder: (isAudioCall) {
              return VoipBlocSelector.isTwoWayCall(
                builder: (isTwoWayCall) {
                  return VoipBlocSelector.isOneWayCall(
                    builder: (isOneWayCall) {
                      return AppScaffold(
                        body: DecoratedBox(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(DefaultImages.CALL_BACKGROUND),
                              fit: BoxFit.fill,
                              opacity: 0.08,
                            ),
                          ),
                          child: Stack(
                            children: [
                              if (isAudioCall)
                                SizedBox(
                                  width: 100.w,
                                  height: 100.h,
                                  child: AudioCall(
                                    visitorName: widget.visitor?.name ??
                                        "Unknown Visitor",
                                    visitorImage: widget.visitor?.imageUrl,
                                    notificationImage: widget.notificationImage,
                                    isAudioOnly: true,
                                    isAudioEnabled: bloc.isAudioEnabled(),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: RemoteRenderWidget(
                                    deviceName: device.name ?? "",
                                    device: device,
                                    visitor: widget.visitor,
                                    callUserId: widget.callUserId,
                                    imageValue: null,
                                    notificationImage: widget.notificationImage,
                                  ),
                                ),
                              VoipBlocSelector.isCallControlsSheetExpanded(
                                builder: (isExpanded) {
                                  logger.fine("isExpanded $isExpanded");
                                  return VoipBlocSelector.seconds(
                                    builder: (seconds) {
                                      return VoipBlocSelector.isCallConnected(
                                        builder: (isCallConnected) {
                                          return VoipBlocSelector
                                              .remoteRenderer(
                                            builder: (remoteRenderer) {
                                              if (remoteRenderer == null) {
                                                return const SizedBox.shrink();
                                              } else if (!remoteRenderer
                                                      .value.renderVideo ||
                                                  !isCallConnected) {
                                                return const SizedBox.shrink();
                                              }
                                              return VoipBlocSelector
                                                  .isReconnecting(
                                                builder: (isReconnecting) {
                                                  return Stack(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          // Time will be shown for Video call same as Audio Call

                                                          // Padding(
                                                          //   padding:
                                                          //       const EdgeInsets.only(
                                                          //     left: 5,
                                                          //     bottom: 100,
                                                          //   ),
                                                          //   child: DecoratedBox(
                                                          //     decoration: BoxDecoration(
                                                          //       boxShadow: [
                                                          //         BoxShadow(
                                                          //           color: Theme.of(
                                                          //             context,
                                                          //           )
                                                          //               .tabBarTheme
                                                          //               .indicatorColor!
                                                          //               .withValues(
                                                          //                 alpha: 0.25,
                                                          //               ),
                                                          //           offset: const Offset(
                                                          //             1,
                                                          //             1,
                                                          //           ),
                                                          //           spreadRadius: 5,
                                                          //           blurRadius: 20,
                                                          //         ),
                                                          //       ],
                                                          //     ),
                                                          //     child: VoipBlocSelector
                                                          //         .seconds(
                                                          //       builder: (seconds) {
                                                          //         return Text(
                                                          //           seconds == 0
                                                          //               ? ""
                                                          //               : state
                                                          //                       .isAudioCall
                                                          //                   ? ""
                                                          //                   : CommonFunctions
                                                          //                       .formatAudioVisualiserTime(
                                                          //                       state
                                                          //                           .seconds,
                                                          //                     ),
                                                          //           style: Theme.of(
                                                          //             context,
                                                          //           )
                                                          //               .textTheme
                                                          //               .bodyMedium!
                                                          //               .copyWith(
                                                          //                 fontSize: 16,
                                                          //                 color: Theme.of(
                                                          //                   context,
                                                          //                 ).primaryColor,
                                                          //                 fontWeight:
                                                          //                     FontWeight
                                                          //                         .bold,
                                                          //               ),
                                                          //           textAlign:
                                                          //               TextAlign.start,
                                                          //         );
                                                          //       },
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          // Spacer()
                                                          if (isTwoWayCall &&
                                                              bloc.localRenderer !=
                                                                  null)
                                                            VoipBlocSelector
                                                                .isCallConnected(
                                                              builder:
                                                                  (isCallConnected) {
                                                                return VoipBlocSelector
                                                                    .remoteRenderer(
                                                                  builder:
                                                                      (remoteRenderer) {
                                                                    if (remoteRenderer ==
                                                                        null) {
                                                                      return const SizedBox
                                                                          .shrink();
                                                                    } else if (!isCallConnected ||
                                                                        !remoteRenderer
                                                                            .value
                                                                            .renderVideo) {
                                                                      return const SizedBox
                                                                          .shrink();
                                                                    }
                                                                    return localWidget(
                                                                      bloc,
                                                                      state,
                                                                      isExpanded,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            )
                                                          else if (isOneWayCall &&
                                                              bloc.localRenderer !=
                                                                  null)
                                                            oneWayLocalWidget()
                                                          else
                                                            Container(),
                                                        ],
                                                      ),
                                                      if (isReconnecting)
                                                        const Center(
                                                          child:
                                                              PrimaryCircularLoading(),
                                                        ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              // if (!state.isInternetConnected)
                              //   CallLoading(
                              //     visitorName: device.title!,
                              //     visitorImage: device.image ?? "",
                              //     status: Constants.reconnecting,
                              //   ),
                              Positioned(
                                bottom: 0,
                                child: CallControls(
                                  isAudioCall: state.isAudioCall,
                                  isVideoEnabled: state.isTwoWayCall,
                                  isSpeakerEnabledInCall:
                                      state.enabledSpeakerInCall,
                                  isAudioEnabled: state.localRenderer == null
                                      ? false
                                      : state.localRenderer?.muted ?? true,
                                  isCallConnected: state.isCallConnected &&
                                      state.isCallButtonEnabled,
                                  onVideoToggle: () => bloc.convertCall(
                                    isConverting: true,
                                  ),
                                  onShiftToVideo: () =>
                                      bloc.shiftToVideoCallOverlay(
                                    context: context,
                                    visitor: widget.visitor,
                                    notificationImage: widget.notificationImage,
                                  ),
                                  onShiftToAudio: () => bloc.shiftToAudioCall(
                                    isConverting: true,
                                    isLoader: true,
                                    onlyAudio: true,
                                  ),
                                  onAudioToggle: bloc.onAudioToggle,
                                  onSpeakerToggle: () => bloc.toggleSpeaker(
                                    isEnable: !state.enabledSpeakerInCall,
                                    isCalling: true,
                                  ),
                                  onCallEnd: () async {
                                    // unawaited(EasyLoading.show());
                                    Constants.showLoader();

                                    await bloc.streamingPeerConnection
                                        ?.dispose();
                                    await bloc.callingPeerConnection?.dispose();
                                    bloc
                                      ..streamingPeerConnection = null
                                      ..callingPeerConnection = null;
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      await bloc.remoteRenderer?.dispose();
                                      bloc
                                        ..remoteRenderer = null
                                        ..updateRemoteRenderer(
                                          bloc.remoteRenderer,
                                        );
                                    }
                                    unawaited(
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        // EasyLoading.dismiss,
                                        Constants.dismissLoader,
                                      ),
                                    );
                                  },
                                  onSheetStateChanged: (isOpened) =>
                                      bloc.toggleCallControlSheet(
                                    isExpanded: isOpened,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget localWidget(bloc, state, isExpanded, {height, width}) {
    return Hero(
      tag: "hero",
      child: VideoCall(
        // isVideoEnabled: !state.isOneWayCall && bloc.isVideoEnabled(),
        isVideoEnabled: !state.isOneWayCall,
        areCallControlsExpanded: isExpanded,
        visitorName: widget.visitor?.name ?? "Unknown Visitor",
        heights: height,
        widths: width,
      ),
    );
  }

  Widget oneWayLocalWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CommonFunctions.videoCallTopWidget(
          context,
          widget.visitor?.name ?? "Unknown Visitor",
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15, bottom: 100),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 150,
              height: 220,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: BoxBorder.all(color: Theme.of(context).primaryColor),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // User Image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: singletonBloc.profileBloc.state?.image ?? "",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return Image.asset(
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                            DefaultImages.USER_IMG_PLACEHOLDER,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // AudioVisualizer
                  VoipBlocBuilder(
                    builder: (context, state) {
                      final bloc = VoipBloc.of(context);
                      if (bloc.isAudioEnabled()) {
                        return VoiceControlAudioVisualizer(
                          fromCall: true,
                          height: 10,
                          width: 100,
                          isRecording: true,
                          isActive: bloc.isAudioEnabled(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
