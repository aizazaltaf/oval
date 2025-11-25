import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/core/images.dart';
import 'package:admin/extensions/context.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/data/visitors_model.dart';
import 'package:admin/pages/main/iot_devices/bloc/iot_bloc.dart';
import 'package:admin/pages/main/voip/bloc/voip_bloc.dart';
import 'package:admin/pages/main/voip/components/audio_call.dart';
import 'package:admin/pages/main/voip/components/no_stream_view.dart';
import 'package:admin/pages/main/voip/components/speaker.dart';
import 'package:admin/pages/main/voip/full_screen.dart';
import 'package:admin/pages/main/voip/full_screen_rtc_view.dart';
import 'package:admin/widgets/common_functions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemoteRenderWidget extends StatelessWidget {
  RemoteRenderWidget({
    super.key,
    required this.deviceName,
    required this.device,
    this.visitor,
    required this.callUserId,
    required this.imageValue,
    this.remoteRenderer,
    this.fromLiveStreaming = false,
    this.isExternalCamera = false,
    this.notificationImage,
  });

  final String deviceName;
  final String callUserId;
  final VisitorsModel? visitor;
  final bool fromLiveStreaming;
  final bool isExternalCamera;
  final String? notificationImage;
  final UserDeviceModel device;
  final RTCVideoRenderer? remoteRenderer;
  final Uint8List? imageValue;

  Future<void> enterFullscreen(context) async {
    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // unawaited(FullScreenVideo.push(
    //     context, "webrtc-video", device, false, callUserId));
    unawaited(
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) {
            return FadeTransition(
              opacity: animation,
              child: FullScreenVideo(
                isVlc: false,
                device: device,
                tag: "webrtc-video",
                callUserId: callUserId,
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, dynamic>? subDevices;

  List<dynamic>? subDevicesEntities;
  @override
  Widget build(BuildContext context) {
    final bloc = VoipBloc.of(context);

    return VoipBlocSelector.isLiveStreamingLoading(
      builder: (isLiveStreamingLoading) {
        return VoipBlocSelector.isPoorInternet(
          builder: (isPoorInternet) {
            return VoipBlocSelector.isStreamReconnecting(
              builder: (isStreamReconnecting) {
                return VoipBlocSelector.isInternetConnected(
                  builder: (isInternetConnected) {
                    return VoipBlocSelector.thumbnailImage(
                      builder: (image) {
                        return VoipBlocSelector.isLiveStreamAvailable(
                          builder: (isLiveStreamAvailable) {
                            return VoipBlocSelector.remoteRenderer(
                              builder: (remoteRenderer) {
                                if (fromLiveStreaming) {
                                  if (!isInternetConnected) {
                                    return NoStreamView(
                                      icon: DefaultIcons
                                          .NO_INTERNET_LIVE_STREAM_ICON,
                                      title:
                                          "${context.appLocalizations.no_internet_connection}.",
                                      image: image,
                                      titleSize: 16,
                                      imageValue: imageValue,
                                    );
                                  }
                                  if (!isLiveStreamAvailable) {
                                    return NoStreamView(
                                      icon: DefaultIcons.DOORBELL_OFFLINE,
                                      image: image,
                                      imageValue: imageValue,
                                      title:
                                          "${isExternalCamera ? 'Camera' : 'Doorbell'} is offline",
                                      titleSize: 16,
                                    );
                                  }

                                  if (isPoorInternet) {
                                    return CommonFunctions.loadingStreamVideo(
                                      context,
                                      image: image,
                                      imageValue: imageValue,
                                      title: "Poor Internet!! Reconnecting",
                                    );
                                  }

                                  if (remoteRenderer == null) {
                                    return CommonFunctions.loadingStreamVideo(
                                      context,
                                      image: image,
                                      imageValue: imageValue,
                                      title: isStreamReconnecting
                                          ? "Reconnecting"
                                          : "Connecting to ${isExternalCamera ? 'Live Camera' : 'Live Stream'}",
                                    );
                                  }

                                  // if (!remoteRenderer.value.renderVideo) {
                                  //   return ClipRRect(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     child: CommonFunctions.loadingStreamVideo(
                                  //       context,
                                  //       image: image,
                                  //       imageValue: imageValue,
                                  //       title: isStreamReconnecting
                                  //           ? "Reconnecting"
                                  //           : "Connecting to ${isExternalCamera ? 'Live Camera' : 'Live Stream'}",
                                  //     ),
                                  //   );
                                  // }

                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AspectRatio(
                                      aspectRatio: remoteRenderer.videoWidth /
                                          remoteRenderer.videoHeight,
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: "webrtc-video",
                                            child: RTCVideoView(
                                              remoteRenderer,
                                            ),
                                          ),
                                          Positioned(
                                            top: 20,
                                            right: 20,
                                            child: Image.asset(
                                              DefaultImages.STREAM_LOGO,
                                              width: 60,
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child:
                                                VoipBlocSelector.localRenderer(
                                              builder: (localRenderer) {
                                                if (localRenderer == null ||
                                                    localRenderer.srcObject ==
                                                        null) {
                                                  return SizedBox(
                                                    width: bloc.heightLocalView,
                                                    height: bloc.widthLocalView,
                                                  );
                                                }

                                                if (localRenderer.srcObject!
                                                    .getVideoTracks()
                                                    .isEmpty) {
                                                  return SizedBox(
                                                    width: bloc.heightLocalView,
                                                    height: bloc.widthLocalView,
                                                  );
                                                }

                                                return VoipBlocSelector
                                                    .isCallConnected(
                                                  builder: (isCallConnected) {
                                                    return Opacity(
                                                      opacity: isCallConnected
                                                          ? 1
                                                          : 0,
                                                      child: SizedBox(
                                                        width: bloc
                                                            .heightLocalView,
                                                        height:
                                                            bloc.widthLocalView,
                                                        child: RTCVideoView(
                                                          localRenderer,
                                                          objectFit:
                                                              RTCVideoViewObjectFit
                                                                  .RTCVideoViewObjectFitCover,
                                                          mirror: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          if (device.entityId == null)
                                            BottomButtonsClass(
                                              bloc: bloc,
                                              callUserId: callUserId,
                                            )
                                          else
                                            cameraControlIcon(bloc),
                                          Positioned(
                                            bottom: 10,
                                            right: 10,
                                            child: DecoratedBox(
                                              decoration: const BoxDecoration(
                                                color: Colors.black26,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                onPressed: () async {
                                                  bloc.updateIsFullScreen(true);
                                                  await enterFullscreen(
                                                    context,
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.fullscreen,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return VoipBlocSelector.seconds(
                                  builder: (seconds) {
                                    return VoipBlocSelector.isCallConnected(
                                      builder: (isCallConnected) {
                                        if (!isCallConnected) {
                                          return Center(
                                            child: AudioCall(
                                              visitorName: visitor?.name ??
                                                  "Unknown Visitor",
                                              visitorImage: visitor?.imageUrl,
                                              notificationImage:
                                                  notificationImage,
                                              isAudioEnabled: false,
                                              isAudioCall: false,
                                            ),
                                          );
                                        }
                                        return VoipBlocSelector.remoteRenderer(
                                          builder: (remoteRenderer) {
                                            if (remoteRenderer == null ||
                                                !isCallConnected) {
                                              return Center(
                                                child: AudioCall(
                                                  visitorName: visitor?.name ??
                                                      "Unknown Visitor",
                                                  visitorImage:
                                                      visitor?.imageUrl,
                                                  notificationImage:
                                                      notificationImage,
                                                  isAudioEnabled: false,
                                                  isAudioCall: false,
                                                ),
                                              );
                                            } else if (!remoteRenderer
                                                .value.renderVideo) {
                                              return Center(
                                                child: AudioCall(
                                                  visitorName: visitor?.name ??
                                                      "Unknown Visitor",
                                                  visitorImage:
                                                      visitor?.imageUrl,
                                                  notificationImage:
                                                      notificationImage,
                                                  isAudioEnabled: false,
                                                  isAudioCall: false,
                                                ),
                                              );
                                            }
                                            return FullScreenRTCVideo(
                                              renderer: remoteRenderer,
                                              fromLiveStreaming:
                                                  fromLiveStreaming,
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
    );
  }

  Widget cameraControlIcon(VoipBloc bloc) {
    return Stack(
      children: [
        Positioned(
          bottom: 10,
          left: 10,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: VoipBlocSelector.enabledSpeakerInStream(
              builder: (enabledSpeakerInStream) {
                return IconButton(
                  onPressed: () async {
                    if (enabledSpeakerInStream) {
                      bloc.removeStreamRemoteAudio();
                    } else {
                      await bloc.resumeRemoteAudio();
                    }
                    if (Platform.isAndroid) {
                      unawaited(
                        Helper.setSpeakerphoneOn(!enabledSpeakerInStream),
                      );
                      bloc.updateEnabledSpeakerInStream(
                        !enabledSpeakerInStream,
                      );
                    } else {
                      unawaited(
                        SpeakerphoneController.setSpeakerphoneOn(
                          !enabledSpeakerInStream,
                        ),
                      );
                      bloc.updateEnabledSpeakerInStream(
                        !enabledSpeakerInStream,
                      );
                    }
                  },
                  icon: SvgPicture.asset(
                    enabledSpeakerInStream
                        ? DefaultIcons.VOLUME_ON
                        : DefaultIcons.VOLUME_MUTE,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        IotBlocSelector(
          selector: (state) =>
              state.getAllDevicesWithSubDevices.isSocketInProgress ||
              state.iotApi.isApiInProgress,
          builder: (isLoading) {
            return IotBlocSelector.allDevicesWithSubDevices(
              builder: (data) {
                if (data != null) {
                  final List<dynamic> decodedJson = jsonDecode(
                    data.isEmpty ? "[]" : data,
                  );
                  subDevices = decodedJson.firstWhereOrNull(
                    (e) => e['entity_id'] == device.entityId,
                  );
                  subDevicesEntities = subDevices?["entities"];
                  subDevicesEntities = subDevicesEntities?.where((subDevices) {
                    return CommonFunctions.containsAnyFromList(
                      subDevices['entity_id'],
                    );
                  }).toList();
                }

                if ((subDevicesEntities ?? []).any(
                  (e) => CommonFunctions.isMoveAble(
                    e['entity_id'],
                  ),
                )) {
                  return Positioned(
                    bottom: 10,
                    left: 65,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          bloc.updateEnableCameraControls(
                            !bloc.state.enableCameraControls,
                          );
                        },
                        icon: const Icon(
                          Icons.control_camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            );
          },
        ),
      ],
    );
  }
}

class BottomButtonsClass extends StatelessWidget {
  const BottomButtonsClass({
    super.key,
    required this.bloc,
    required this.callUserId,
  });

  final VoipBloc bloc;
  final String callUserId;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Row(
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: VoipBlocSelector.isMicrophoneOnStreamEnabled(
              builder: (isMicrophoneOnStreamEnabled) {
                return IconButton(
                  onPressed: () {
                    bloc.enableInStreamMicrophone(
                      context,
                      callUserId,
                      isMicrophoneEnable: !isMicrophoneOnStreamEnabled,
                    );
                  },
                  icon: SvgPicture.asset(
                    isMicrophoneOnStreamEnabled
                        ? DefaultIcons.MICROPHONE_ON
                        : DefaultIcons.MICROPHONE_OFF,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: VoipBlocSelector.enabledSpeakerInStream(
              builder: (enabledSpeakerInStream) {
                return IconButton(
                  onPressed: () async {
                    if (enabledSpeakerInStream) {
                      bloc.removeStreamRemoteAudio();
                    } else {
                      await bloc.resumeRemoteAudio();
                    }
                    if (Platform.isAndroid) {
                      unawaited(
                        Helper.setSpeakerphoneOn(!enabledSpeakerInStream),
                      );
                      bloc.updateEnabledSpeakerInStream(
                        !enabledSpeakerInStream,
                      );
                    } else {
                      unawaited(
                        SpeakerphoneController.setSpeakerphoneOn(
                          !enabledSpeakerInStream,
                        ),
                      );
                      bloc.updateEnabledSpeakerInStream(
                        !enabledSpeakerInStream,
                      );
                    }
                  },
                  icon: SvgPicture.asset(
                    enabledSpeakerInStream
                        ? DefaultIcons.VOLUME_ON
                        : DefaultIcons.VOLUME_MUTE,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          VoipBlocSelector.isCameraOnStreamEnabled(
            builder: (isCameraOnStreamEnabled) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    await Future.delayed(
                      const Duration(
                        milliseconds: 300,
                      ),
                    );
                    if (bloc.state.isSilentAudioCall) {
                      if (context.mounted) {
                        await bloc.endStreamingCall(
                          context,
                        );
                      }
                      // await EasyLoading.show();
                      Constants.showLoader();

                      await Future.delayed(
                          const Duration(
                            seconds: 2,
                          ), () {
                        if (context.mounted) {
                          // EasyLoading.dismiss();
                          Constants.dismissLoader();

                          bloc.enableInStreamCamera(
                            context,
                            callUserId,
                            isCameraEnable: !isCameraOnStreamEnabled,
                          );
                        }
                      });
                    } else {
                      if (bloc.callingPeerConnection == null) {
                        // await EasyLoading.show();
                        Constants.showLoader();

                        Future.delayed(
                            const Duration(
                              seconds: 1,
                            ), () {
                          if (context.mounted) {
                            // EasyLoading.dismiss();
                            Constants.dismissLoader();

                            bloc.enableInStreamCamera(
                              context,
                              callUserId,
                              isCall: true,
                              isCameraEnable: !isCameraOnStreamEnabled,
                            );
                          }
                        });
                      } else {
                        if (context.mounted) {
                          await bloc.enableInStreamCamera(
                            context,
                            callUserId,
                            isCall: true,
                            isCameraEnable: !isCameraOnStreamEnabled,
                          );
                        }
                      }
                    }
                  },
                  icon: SvgPicture.asset(
                    isCameraOnStreamEnabled
                        ? DefaultIcons.CAMERA_ON
                        : DefaultIcons.CAMERA_OFF,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
