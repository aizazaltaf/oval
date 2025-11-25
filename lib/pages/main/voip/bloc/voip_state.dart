import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_player/video_player.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'voip_state.g.dart';

abstract class VoipState implements Built<VoipState, VoipStateBuilder> {
  factory VoipState([
    final void Function(VoipStateBuilder) updates,
  ]) = _$VoipState;

  VoipState._();

  @BuiltValueHook(initializeBuilder: true)
  static void _initialize(final VoipStateBuilder b) => b
    ..isLiveModeActivated = true
    ..isAudioCall = false
    ..isOneWayCall = false
    ..isTwoWayCall = false
    ..isCalling = false
    ..isCallControlsSheetExpanded = true
    ..enabledSpeakerInCall = true
    ..isPlaying = false
    ..location = ""
    ..meetingConnected = false
    ..isCallConnected = false
    ..isMicrophoneOnStreamEnabled = false
    ..isSilentAudioCall = false
    ..isCallStarted = false
    ..isCameraOnStreamEnabled = false
    ..enabledSpeakerInStream = false
    ..isRecordedStreamLoading = false
    ..muted = true
    ..isReconnecting = false
    ..isOnCallingScreen = false
    ..enableCameraControls = false
    ..isScrollLoading = false
    ..remoteRenderer = null
    ..localRenderer = null
    ..isReAttempt = false
    ..isFullScreen = false
    ..isSpeakerLoading = false
    ..isVideoInitialized = false
    ..meetingId = ""
    ..sliderValue = 0.0
    ..videoTimer = ""
    ..callState = "Calling"
    ..seconds = 0
    ..userDoorBell = <UserDeviceModel>[].toBuiltList().toBuilder()
    ..tempAiAlertList = <String>[].toBuiltList().toBuilder()
    ..confirmedAlertFilters = <String>[].toBuiltList().toBuilder()
    ..isLiveStreamingLoading = true
    ..isInternetConnected = true
    ..isCallButtonEnabled = true
    ..isStreamReconnecting = false
    ..isPoorInternet = false
    ..isBuffering = false
    ..isLiveStreamAvailable = true;

  ApiState<void> get voipApi;

  @BlocUpdateField()
  bool get isLiveModeActivated;

  @BlocUpdateField()
  bool get isRecordedStreamLoading;

  @BlocUpdateField()
  bool get isLiveStreamingLoading;

  @BlocUpdateField()
  bool get isCallButtonEnabled;

  @BlocUpdateField()
  bool get isLiveStreamAvailable;

  @BlocUpdateField()
  bool get isCalling;

  @BlocUpdateField()
  bool get isReAttempt;

  @BlocUpdateField()
  bool get isAudioCall;

  @BlocUpdateField()
  bool get isCallConnected;

  @BlocUpdateField()
  bool get isOneWayCall;

  bool get isTwoWayCall;

  @BlocUpdateField()
  bool get enabledSpeakerInCall;

  @BlocUpdateField()
  bool get enabledSpeakerInStream;

  @BlocUpdateField()
  bool get enableCameraControls;

  bool get isMicrophoneOnStreamEnabled;

  bool get isSilentAudioCall;

  @BlocUpdateField()
  bool get isFullScreen;

  @BlocUpdateField()
  bool get isBuffering;

  @BlocUpdateField()
  bool get isScrollLoading;

  bool get isCameraOnStreamEnabled;

  @BlocUpdateField()
  bool get isReconnecting;

  @BlocUpdateField()
  bool get isOnCallingScreen;

  @BlocUpdateField()
  String get callState;

  @BlocUpdateField()
  bool get isPoorInternet;

  bool get muted;

  String get location;

  bool get meetingConnected;

  bool get isCallControlsSheetExpanded;

  bool get isCallStarted;

  bool get isPlaying;

  @BlocUpdateField()
  bool get isInternetConnected;

  @BlocUpdateField()
  bool get isStreamReconnecting;

  @BlocUpdateField()
  bool get isSpeakerLoading;

  @BlocUpdateField()
  bool get isVideoInitialized;

  String get meetingId;

  double get sliderValue;

  String get videoTimer;

  @BlocUpdateField()
  String? get thumbnailImage;

  @BlocUpdateField()
  String? get callValue;

  int get seconds;

  @BlocUpdateField()
  ApiState<StreamingAlertsData> get recordingApi;

  BuiltList<UserDeviceModel> get userDoorBell;

  BuiltList<String> get tempAiAlertList;

  BuiltList<String> get confirmedAlertFilters;

  @BlocUpdateField()
  RTCVideoRenderer? get remoteRenderer;

  RTCVideoRenderer? get localRenderer;

  VideoPlayerController? get videoController;

  SocketState<Map<String, dynamic>> get socketResponse;
}
