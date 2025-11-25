// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voip_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VoipState extends VoipState {
  @override
  final ApiState<void> voipApi;
  @override
  final bool isLiveModeActivated;
  @override
  final bool isRecordedStreamLoading;
  @override
  final bool isLiveStreamingLoading;
  @override
  final bool isCallButtonEnabled;
  @override
  final bool isLiveStreamAvailable;
  @override
  final bool isCalling;
  @override
  final bool isReAttempt;
  @override
  final bool isAudioCall;
  @override
  final bool isCallConnected;
  @override
  final bool isOneWayCall;
  @override
  final bool isTwoWayCall;
  @override
  final bool enabledSpeakerInCall;
  @override
  final bool enabledSpeakerInStream;
  @override
  final bool enableCameraControls;
  @override
  final bool isMicrophoneOnStreamEnabled;
  @override
  final bool isSilentAudioCall;
  @override
  final bool isFullScreen;
  @override
  final bool isBuffering;
  @override
  final bool isScrollLoading;
  @override
  final bool isCameraOnStreamEnabled;
  @override
  final bool isReconnecting;
  @override
  final bool isOnCallingScreen;
  @override
  final String callState;
  @override
  final bool isPoorInternet;
  @override
  final bool muted;
  @override
  final String location;
  @override
  final bool meetingConnected;
  @override
  final bool isCallControlsSheetExpanded;
  @override
  final bool isCallStarted;
  @override
  final bool isPlaying;
  @override
  final bool isInternetConnected;
  @override
  final bool isStreamReconnecting;
  @override
  final bool isSpeakerLoading;
  @override
  final bool isVideoInitialized;
  @override
  final String meetingId;
  @override
  final double sliderValue;
  @override
  final String videoTimer;
  @override
  final String? thumbnailImage;
  @override
  final String? callValue;
  @override
  final int seconds;
  @override
  final ApiState<StreamingAlertsData> recordingApi;
  @override
  final BuiltList<UserDeviceModel> userDoorBell;
  @override
  final BuiltList<String> tempAiAlertList;
  @override
  final BuiltList<String> confirmedAlertFilters;
  @override
  final RTCVideoRenderer? remoteRenderer;
  @override
  final RTCVideoRenderer? localRenderer;
  @override
  final VideoPlayerController? videoController;
  @override
  final SocketState<Map<String, dynamic>> socketResponse;

  factory _$VoipState([void Function(VoipStateBuilder)? updates]) =>
      (VoipStateBuilder()..update(updates))._build();

  _$VoipState._(
      {required this.voipApi,
      required this.isLiveModeActivated,
      required this.isRecordedStreamLoading,
      required this.isLiveStreamingLoading,
      required this.isCallButtonEnabled,
      required this.isLiveStreamAvailable,
      required this.isCalling,
      required this.isReAttempt,
      required this.isAudioCall,
      required this.isCallConnected,
      required this.isOneWayCall,
      required this.isTwoWayCall,
      required this.enabledSpeakerInCall,
      required this.enabledSpeakerInStream,
      required this.enableCameraControls,
      required this.isMicrophoneOnStreamEnabled,
      required this.isSilentAudioCall,
      required this.isFullScreen,
      required this.isBuffering,
      required this.isScrollLoading,
      required this.isCameraOnStreamEnabled,
      required this.isReconnecting,
      required this.isOnCallingScreen,
      required this.callState,
      required this.isPoorInternet,
      required this.muted,
      required this.location,
      required this.meetingConnected,
      required this.isCallControlsSheetExpanded,
      required this.isCallStarted,
      required this.isPlaying,
      required this.isInternetConnected,
      required this.isStreamReconnecting,
      required this.isSpeakerLoading,
      required this.isVideoInitialized,
      required this.meetingId,
      required this.sliderValue,
      required this.videoTimer,
      this.thumbnailImage,
      this.callValue,
      required this.seconds,
      required this.recordingApi,
      required this.userDoorBell,
      required this.tempAiAlertList,
      required this.confirmedAlertFilters,
      this.remoteRenderer,
      this.localRenderer,
      this.videoController,
      required this.socketResponse})
      : super._();
  @override
  VoipState rebuild(void Function(VoipStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VoipStateBuilder toBuilder() => VoipStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VoipState &&
        voipApi == other.voipApi &&
        isLiveModeActivated == other.isLiveModeActivated &&
        isRecordedStreamLoading == other.isRecordedStreamLoading &&
        isLiveStreamingLoading == other.isLiveStreamingLoading &&
        isCallButtonEnabled == other.isCallButtonEnabled &&
        isLiveStreamAvailable == other.isLiveStreamAvailable &&
        isCalling == other.isCalling &&
        isReAttempt == other.isReAttempt &&
        isAudioCall == other.isAudioCall &&
        isCallConnected == other.isCallConnected &&
        isOneWayCall == other.isOneWayCall &&
        isTwoWayCall == other.isTwoWayCall &&
        enabledSpeakerInCall == other.enabledSpeakerInCall &&
        enabledSpeakerInStream == other.enabledSpeakerInStream &&
        enableCameraControls == other.enableCameraControls &&
        isMicrophoneOnStreamEnabled == other.isMicrophoneOnStreamEnabled &&
        isSilentAudioCall == other.isSilentAudioCall &&
        isFullScreen == other.isFullScreen &&
        isBuffering == other.isBuffering &&
        isScrollLoading == other.isScrollLoading &&
        isCameraOnStreamEnabled == other.isCameraOnStreamEnabled &&
        isReconnecting == other.isReconnecting &&
        isOnCallingScreen == other.isOnCallingScreen &&
        callState == other.callState &&
        isPoorInternet == other.isPoorInternet &&
        muted == other.muted &&
        location == other.location &&
        meetingConnected == other.meetingConnected &&
        isCallControlsSheetExpanded == other.isCallControlsSheetExpanded &&
        isCallStarted == other.isCallStarted &&
        isPlaying == other.isPlaying &&
        isInternetConnected == other.isInternetConnected &&
        isStreamReconnecting == other.isStreamReconnecting &&
        isSpeakerLoading == other.isSpeakerLoading &&
        isVideoInitialized == other.isVideoInitialized &&
        meetingId == other.meetingId &&
        sliderValue == other.sliderValue &&
        videoTimer == other.videoTimer &&
        thumbnailImage == other.thumbnailImage &&
        callValue == other.callValue &&
        seconds == other.seconds &&
        recordingApi == other.recordingApi &&
        userDoorBell == other.userDoorBell &&
        tempAiAlertList == other.tempAiAlertList &&
        confirmedAlertFilters == other.confirmedAlertFilters &&
        remoteRenderer == other.remoteRenderer &&
        localRenderer == other.localRenderer &&
        videoController == other.videoController &&
        socketResponse == other.socketResponse;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, voipApi.hashCode);
    _$hash = $jc(_$hash, isLiveModeActivated.hashCode);
    _$hash = $jc(_$hash, isRecordedStreamLoading.hashCode);
    _$hash = $jc(_$hash, isLiveStreamingLoading.hashCode);
    _$hash = $jc(_$hash, isCallButtonEnabled.hashCode);
    _$hash = $jc(_$hash, isLiveStreamAvailable.hashCode);
    _$hash = $jc(_$hash, isCalling.hashCode);
    _$hash = $jc(_$hash, isReAttempt.hashCode);
    _$hash = $jc(_$hash, isAudioCall.hashCode);
    _$hash = $jc(_$hash, isCallConnected.hashCode);
    _$hash = $jc(_$hash, isOneWayCall.hashCode);
    _$hash = $jc(_$hash, isTwoWayCall.hashCode);
    _$hash = $jc(_$hash, enabledSpeakerInCall.hashCode);
    _$hash = $jc(_$hash, enabledSpeakerInStream.hashCode);
    _$hash = $jc(_$hash, enableCameraControls.hashCode);
    _$hash = $jc(_$hash, isMicrophoneOnStreamEnabled.hashCode);
    _$hash = $jc(_$hash, isSilentAudioCall.hashCode);
    _$hash = $jc(_$hash, isFullScreen.hashCode);
    _$hash = $jc(_$hash, isBuffering.hashCode);
    _$hash = $jc(_$hash, isScrollLoading.hashCode);
    _$hash = $jc(_$hash, isCameraOnStreamEnabled.hashCode);
    _$hash = $jc(_$hash, isReconnecting.hashCode);
    _$hash = $jc(_$hash, isOnCallingScreen.hashCode);
    _$hash = $jc(_$hash, callState.hashCode);
    _$hash = $jc(_$hash, isPoorInternet.hashCode);
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, meetingConnected.hashCode);
    _$hash = $jc(_$hash, isCallControlsSheetExpanded.hashCode);
    _$hash = $jc(_$hash, isCallStarted.hashCode);
    _$hash = $jc(_$hash, isPlaying.hashCode);
    _$hash = $jc(_$hash, isInternetConnected.hashCode);
    _$hash = $jc(_$hash, isStreamReconnecting.hashCode);
    _$hash = $jc(_$hash, isSpeakerLoading.hashCode);
    _$hash = $jc(_$hash, isVideoInitialized.hashCode);
    _$hash = $jc(_$hash, meetingId.hashCode);
    _$hash = $jc(_$hash, sliderValue.hashCode);
    _$hash = $jc(_$hash, videoTimer.hashCode);
    _$hash = $jc(_$hash, thumbnailImage.hashCode);
    _$hash = $jc(_$hash, callValue.hashCode);
    _$hash = $jc(_$hash, seconds.hashCode);
    _$hash = $jc(_$hash, recordingApi.hashCode);
    _$hash = $jc(_$hash, userDoorBell.hashCode);
    _$hash = $jc(_$hash, tempAiAlertList.hashCode);
    _$hash = $jc(_$hash, confirmedAlertFilters.hashCode);
    _$hash = $jc(_$hash, remoteRenderer.hashCode);
    _$hash = $jc(_$hash, localRenderer.hashCode);
    _$hash = $jc(_$hash, videoController.hashCode);
    _$hash = $jc(_$hash, socketResponse.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VoipState')
          ..add('voipApi', voipApi)
          ..add('isLiveModeActivated', isLiveModeActivated)
          ..add('isRecordedStreamLoading', isRecordedStreamLoading)
          ..add('isLiveStreamingLoading', isLiveStreamingLoading)
          ..add('isCallButtonEnabled', isCallButtonEnabled)
          ..add('isLiveStreamAvailable', isLiveStreamAvailable)
          ..add('isCalling', isCalling)
          ..add('isReAttempt', isReAttempt)
          ..add('isAudioCall', isAudioCall)
          ..add('isCallConnected', isCallConnected)
          ..add('isOneWayCall', isOneWayCall)
          ..add('isTwoWayCall', isTwoWayCall)
          ..add('enabledSpeakerInCall', enabledSpeakerInCall)
          ..add('enabledSpeakerInStream', enabledSpeakerInStream)
          ..add('enableCameraControls', enableCameraControls)
          ..add('isMicrophoneOnStreamEnabled', isMicrophoneOnStreamEnabled)
          ..add('isSilentAudioCall', isSilentAudioCall)
          ..add('isFullScreen', isFullScreen)
          ..add('isBuffering', isBuffering)
          ..add('isScrollLoading', isScrollLoading)
          ..add('isCameraOnStreamEnabled', isCameraOnStreamEnabled)
          ..add('isReconnecting', isReconnecting)
          ..add('isOnCallingScreen', isOnCallingScreen)
          ..add('callState', callState)
          ..add('isPoorInternet', isPoorInternet)
          ..add('muted', muted)
          ..add('location', location)
          ..add('meetingConnected', meetingConnected)
          ..add('isCallControlsSheetExpanded', isCallControlsSheetExpanded)
          ..add('isCallStarted', isCallStarted)
          ..add('isPlaying', isPlaying)
          ..add('isInternetConnected', isInternetConnected)
          ..add('isStreamReconnecting', isStreamReconnecting)
          ..add('isSpeakerLoading', isSpeakerLoading)
          ..add('isVideoInitialized', isVideoInitialized)
          ..add('meetingId', meetingId)
          ..add('sliderValue', sliderValue)
          ..add('videoTimer', videoTimer)
          ..add('thumbnailImage', thumbnailImage)
          ..add('callValue', callValue)
          ..add('seconds', seconds)
          ..add('recordingApi', recordingApi)
          ..add('userDoorBell', userDoorBell)
          ..add('tempAiAlertList', tempAiAlertList)
          ..add('confirmedAlertFilters', confirmedAlertFilters)
          ..add('remoteRenderer', remoteRenderer)
          ..add('localRenderer', localRenderer)
          ..add('videoController', videoController)
          ..add('socketResponse', socketResponse))
        .toString();
  }
}

class VoipStateBuilder implements Builder<VoipState, VoipStateBuilder> {
  _$VoipState? _$v;

  ApiStateBuilder<void>? _voipApi;
  ApiStateBuilder<void> get voipApi =>
      _$this._voipApi ??= ApiStateBuilder<void>();
  set voipApi(ApiStateBuilder<void>? voipApi) => _$this._voipApi = voipApi;

  bool? _isLiveModeActivated;
  bool? get isLiveModeActivated => _$this._isLiveModeActivated;
  set isLiveModeActivated(bool? isLiveModeActivated) =>
      _$this._isLiveModeActivated = isLiveModeActivated;

  bool? _isRecordedStreamLoading;
  bool? get isRecordedStreamLoading => _$this._isRecordedStreamLoading;
  set isRecordedStreamLoading(bool? isRecordedStreamLoading) =>
      _$this._isRecordedStreamLoading = isRecordedStreamLoading;

  bool? _isLiveStreamingLoading;
  bool? get isLiveStreamingLoading => _$this._isLiveStreamingLoading;
  set isLiveStreamingLoading(bool? isLiveStreamingLoading) =>
      _$this._isLiveStreamingLoading = isLiveStreamingLoading;

  bool? _isCallButtonEnabled;
  bool? get isCallButtonEnabled => _$this._isCallButtonEnabled;
  set isCallButtonEnabled(bool? isCallButtonEnabled) =>
      _$this._isCallButtonEnabled = isCallButtonEnabled;

  bool? _isLiveStreamAvailable;
  bool? get isLiveStreamAvailable => _$this._isLiveStreamAvailable;
  set isLiveStreamAvailable(bool? isLiveStreamAvailable) =>
      _$this._isLiveStreamAvailable = isLiveStreamAvailable;

  bool? _isCalling;
  bool? get isCalling => _$this._isCalling;
  set isCalling(bool? isCalling) => _$this._isCalling = isCalling;

  bool? _isReAttempt;
  bool? get isReAttempt => _$this._isReAttempt;
  set isReAttempt(bool? isReAttempt) => _$this._isReAttempt = isReAttempt;

  bool? _isAudioCall;
  bool? get isAudioCall => _$this._isAudioCall;
  set isAudioCall(bool? isAudioCall) => _$this._isAudioCall = isAudioCall;

  bool? _isCallConnected;
  bool? get isCallConnected => _$this._isCallConnected;
  set isCallConnected(bool? isCallConnected) =>
      _$this._isCallConnected = isCallConnected;

  bool? _isOneWayCall;
  bool? get isOneWayCall => _$this._isOneWayCall;
  set isOneWayCall(bool? isOneWayCall) => _$this._isOneWayCall = isOneWayCall;

  bool? _isTwoWayCall;
  bool? get isTwoWayCall => _$this._isTwoWayCall;
  set isTwoWayCall(bool? isTwoWayCall) => _$this._isTwoWayCall = isTwoWayCall;

  bool? _enabledSpeakerInCall;
  bool? get enabledSpeakerInCall => _$this._enabledSpeakerInCall;
  set enabledSpeakerInCall(bool? enabledSpeakerInCall) =>
      _$this._enabledSpeakerInCall = enabledSpeakerInCall;

  bool? _enabledSpeakerInStream;
  bool? get enabledSpeakerInStream => _$this._enabledSpeakerInStream;
  set enabledSpeakerInStream(bool? enabledSpeakerInStream) =>
      _$this._enabledSpeakerInStream = enabledSpeakerInStream;

  bool? _enableCameraControls;
  bool? get enableCameraControls => _$this._enableCameraControls;
  set enableCameraControls(bool? enableCameraControls) =>
      _$this._enableCameraControls = enableCameraControls;

  bool? _isMicrophoneOnStreamEnabled;
  bool? get isMicrophoneOnStreamEnabled => _$this._isMicrophoneOnStreamEnabled;
  set isMicrophoneOnStreamEnabled(bool? isMicrophoneOnStreamEnabled) =>
      _$this._isMicrophoneOnStreamEnabled = isMicrophoneOnStreamEnabled;

  bool? _isSilentAudioCall;
  bool? get isSilentAudioCall => _$this._isSilentAudioCall;
  set isSilentAudioCall(bool? isSilentAudioCall) =>
      _$this._isSilentAudioCall = isSilentAudioCall;

  bool? _isFullScreen;
  bool? get isFullScreen => _$this._isFullScreen;
  set isFullScreen(bool? isFullScreen) => _$this._isFullScreen = isFullScreen;

  bool? _isBuffering;
  bool? get isBuffering => _$this._isBuffering;
  set isBuffering(bool? isBuffering) => _$this._isBuffering = isBuffering;

  bool? _isScrollLoading;
  bool? get isScrollLoading => _$this._isScrollLoading;
  set isScrollLoading(bool? isScrollLoading) =>
      _$this._isScrollLoading = isScrollLoading;

  bool? _isCameraOnStreamEnabled;
  bool? get isCameraOnStreamEnabled => _$this._isCameraOnStreamEnabled;
  set isCameraOnStreamEnabled(bool? isCameraOnStreamEnabled) =>
      _$this._isCameraOnStreamEnabled = isCameraOnStreamEnabled;

  bool? _isReconnecting;
  bool? get isReconnecting => _$this._isReconnecting;
  set isReconnecting(bool? isReconnecting) =>
      _$this._isReconnecting = isReconnecting;

  bool? _isOnCallingScreen;
  bool? get isOnCallingScreen => _$this._isOnCallingScreen;
  set isOnCallingScreen(bool? isOnCallingScreen) =>
      _$this._isOnCallingScreen = isOnCallingScreen;

  String? _callState;
  String? get callState => _$this._callState;
  set callState(String? callState) => _$this._callState = callState;

  bool? _isPoorInternet;
  bool? get isPoorInternet => _$this._isPoorInternet;
  set isPoorInternet(bool? isPoorInternet) =>
      _$this._isPoorInternet = isPoorInternet;

  bool? _muted;
  bool? get muted => _$this._muted;
  set muted(bool? muted) => _$this._muted = muted;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  bool? _meetingConnected;
  bool? get meetingConnected => _$this._meetingConnected;
  set meetingConnected(bool? meetingConnected) =>
      _$this._meetingConnected = meetingConnected;

  bool? _isCallControlsSheetExpanded;
  bool? get isCallControlsSheetExpanded => _$this._isCallControlsSheetExpanded;
  set isCallControlsSheetExpanded(bool? isCallControlsSheetExpanded) =>
      _$this._isCallControlsSheetExpanded = isCallControlsSheetExpanded;

  bool? _isCallStarted;
  bool? get isCallStarted => _$this._isCallStarted;
  set isCallStarted(bool? isCallStarted) =>
      _$this._isCallStarted = isCallStarted;

  bool? _isPlaying;
  bool? get isPlaying => _$this._isPlaying;
  set isPlaying(bool? isPlaying) => _$this._isPlaying = isPlaying;

  bool? _isInternetConnected;
  bool? get isInternetConnected => _$this._isInternetConnected;
  set isInternetConnected(bool? isInternetConnected) =>
      _$this._isInternetConnected = isInternetConnected;

  bool? _isStreamReconnecting;
  bool? get isStreamReconnecting => _$this._isStreamReconnecting;
  set isStreamReconnecting(bool? isStreamReconnecting) =>
      _$this._isStreamReconnecting = isStreamReconnecting;

  bool? _isSpeakerLoading;
  bool? get isSpeakerLoading => _$this._isSpeakerLoading;
  set isSpeakerLoading(bool? isSpeakerLoading) =>
      _$this._isSpeakerLoading = isSpeakerLoading;

  bool? _isVideoInitialized;
  bool? get isVideoInitialized => _$this._isVideoInitialized;
  set isVideoInitialized(bool? isVideoInitialized) =>
      _$this._isVideoInitialized = isVideoInitialized;

  String? _meetingId;
  String? get meetingId => _$this._meetingId;
  set meetingId(String? meetingId) => _$this._meetingId = meetingId;

  double? _sliderValue;
  double? get sliderValue => _$this._sliderValue;
  set sliderValue(double? sliderValue) => _$this._sliderValue = sliderValue;

  String? _videoTimer;
  String? get videoTimer => _$this._videoTimer;
  set videoTimer(String? videoTimer) => _$this._videoTimer = videoTimer;

  String? _thumbnailImage;
  String? get thumbnailImage => _$this._thumbnailImage;
  set thumbnailImage(String? thumbnailImage) =>
      _$this._thumbnailImage = thumbnailImage;

  String? _callValue;
  String? get callValue => _$this._callValue;
  set callValue(String? callValue) => _$this._callValue = callValue;

  int? _seconds;
  int? get seconds => _$this._seconds;
  set seconds(int? seconds) => _$this._seconds = seconds;

  ApiStateBuilder<StreamingAlertsData>? _recordingApi;
  ApiStateBuilder<StreamingAlertsData> get recordingApi =>
      _$this._recordingApi ??= ApiStateBuilder<StreamingAlertsData>();
  set recordingApi(ApiStateBuilder<StreamingAlertsData>? recordingApi) =>
      _$this._recordingApi = recordingApi;

  ListBuilder<UserDeviceModel>? _userDoorBell;
  ListBuilder<UserDeviceModel> get userDoorBell =>
      _$this._userDoorBell ??= ListBuilder<UserDeviceModel>();
  set userDoorBell(ListBuilder<UserDeviceModel>? userDoorBell) =>
      _$this._userDoorBell = userDoorBell;

  ListBuilder<String>? _tempAiAlertList;
  ListBuilder<String> get tempAiAlertList =>
      _$this._tempAiAlertList ??= ListBuilder<String>();
  set tempAiAlertList(ListBuilder<String>? tempAiAlertList) =>
      _$this._tempAiAlertList = tempAiAlertList;

  ListBuilder<String>? _confirmedAlertFilters;
  ListBuilder<String> get confirmedAlertFilters =>
      _$this._confirmedAlertFilters ??= ListBuilder<String>();
  set confirmedAlertFilters(ListBuilder<String>? confirmedAlertFilters) =>
      _$this._confirmedAlertFilters = confirmedAlertFilters;

  RTCVideoRenderer? _remoteRenderer;
  RTCVideoRenderer? get remoteRenderer => _$this._remoteRenderer;
  set remoteRenderer(RTCVideoRenderer? remoteRenderer) =>
      _$this._remoteRenderer = remoteRenderer;

  RTCVideoRenderer? _localRenderer;
  RTCVideoRenderer? get localRenderer => _$this._localRenderer;
  set localRenderer(RTCVideoRenderer? localRenderer) =>
      _$this._localRenderer = localRenderer;

  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _$this._videoController;
  set videoController(VideoPlayerController? videoController) =>
      _$this._videoController = videoController;

  SocketStateBuilder<Map<String, dynamic>>? _socketResponse;
  SocketStateBuilder<Map<String, dynamic>> get socketResponse =>
      _$this._socketResponse ??= SocketStateBuilder<Map<String, dynamic>>();
  set socketResponse(
          SocketStateBuilder<Map<String, dynamic>>? socketResponse) =>
      _$this._socketResponse = socketResponse;

  VoipStateBuilder() {
    VoipState._initialize(this);
  }

  VoipStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _voipApi = $v.voipApi.toBuilder();
      _isLiveModeActivated = $v.isLiveModeActivated;
      _isRecordedStreamLoading = $v.isRecordedStreamLoading;
      _isLiveStreamingLoading = $v.isLiveStreamingLoading;
      _isCallButtonEnabled = $v.isCallButtonEnabled;
      _isLiveStreamAvailable = $v.isLiveStreamAvailable;
      _isCalling = $v.isCalling;
      _isReAttempt = $v.isReAttempt;
      _isAudioCall = $v.isAudioCall;
      _isCallConnected = $v.isCallConnected;
      _isOneWayCall = $v.isOneWayCall;
      _isTwoWayCall = $v.isTwoWayCall;
      _enabledSpeakerInCall = $v.enabledSpeakerInCall;
      _enabledSpeakerInStream = $v.enabledSpeakerInStream;
      _enableCameraControls = $v.enableCameraControls;
      _isMicrophoneOnStreamEnabled = $v.isMicrophoneOnStreamEnabled;
      _isSilentAudioCall = $v.isSilentAudioCall;
      _isFullScreen = $v.isFullScreen;
      _isBuffering = $v.isBuffering;
      _isScrollLoading = $v.isScrollLoading;
      _isCameraOnStreamEnabled = $v.isCameraOnStreamEnabled;
      _isReconnecting = $v.isReconnecting;
      _isOnCallingScreen = $v.isOnCallingScreen;
      _callState = $v.callState;
      _isPoorInternet = $v.isPoorInternet;
      _muted = $v.muted;
      _location = $v.location;
      _meetingConnected = $v.meetingConnected;
      _isCallControlsSheetExpanded = $v.isCallControlsSheetExpanded;
      _isCallStarted = $v.isCallStarted;
      _isPlaying = $v.isPlaying;
      _isInternetConnected = $v.isInternetConnected;
      _isStreamReconnecting = $v.isStreamReconnecting;
      _isSpeakerLoading = $v.isSpeakerLoading;
      _isVideoInitialized = $v.isVideoInitialized;
      _meetingId = $v.meetingId;
      _sliderValue = $v.sliderValue;
      _videoTimer = $v.videoTimer;
      _thumbnailImage = $v.thumbnailImage;
      _callValue = $v.callValue;
      _seconds = $v.seconds;
      _recordingApi = $v.recordingApi.toBuilder();
      _userDoorBell = $v.userDoorBell.toBuilder();
      _tempAiAlertList = $v.tempAiAlertList.toBuilder();
      _confirmedAlertFilters = $v.confirmedAlertFilters.toBuilder();
      _remoteRenderer = $v.remoteRenderer;
      _localRenderer = $v.localRenderer;
      _videoController = $v.videoController;
      _socketResponse = $v.socketResponse.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VoipState other) {
    _$v = other as _$VoipState;
  }

  @override
  void update(void Function(VoipStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VoipState build() => _build();

  _$VoipState _build() {
    _$VoipState _$result;
    try {
      _$result = _$v ??
          _$VoipState._(
            voipApi: voipApi.build(),
            isLiveModeActivated: BuiltValueNullFieldError.checkNotNull(
                isLiveModeActivated, r'VoipState', 'isLiveModeActivated'),
            isRecordedStreamLoading: BuiltValueNullFieldError.checkNotNull(
                isRecordedStreamLoading,
                r'VoipState',
                'isRecordedStreamLoading'),
            isLiveStreamingLoading: BuiltValueNullFieldError.checkNotNull(
                isLiveStreamingLoading, r'VoipState', 'isLiveStreamingLoading'),
            isCallButtonEnabled: BuiltValueNullFieldError.checkNotNull(
                isCallButtonEnabled, r'VoipState', 'isCallButtonEnabled'),
            isLiveStreamAvailable: BuiltValueNullFieldError.checkNotNull(
                isLiveStreamAvailable, r'VoipState', 'isLiveStreamAvailable'),
            isCalling: BuiltValueNullFieldError.checkNotNull(
                isCalling, r'VoipState', 'isCalling'),
            isReAttempt: BuiltValueNullFieldError.checkNotNull(
                isReAttempt, r'VoipState', 'isReAttempt'),
            isAudioCall: BuiltValueNullFieldError.checkNotNull(
                isAudioCall, r'VoipState', 'isAudioCall'),
            isCallConnected: BuiltValueNullFieldError.checkNotNull(
                isCallConnected, r'VoipState', 'isCallConnected'),
            isOneWayCall: BuiltValueNullFieldError.checkNotNull(
                isOneWayCall, r'VoipState', 'isOneWayCall'),
            isTwoWayCall: BuiltValueNullFieldError.checkNotNull(
                isTwoWayCall, r'VoipState', 'isTwoWayCall'),
            enabledSpeakerInCall: BuiltValueNullFieldError.checkNotNull(
                enabledSpeakerInCall, r'VoipState', 'enabledSpeakerInCall'),
            enabledSpeakerInStream: BuiltValueNullFieldError.checkNotNull(
                enabledSpeakerInStream, r'VoipState', 'enabledSpeakerInStream'),
            enableCameraControls: BuiltValueNullFieldError.checkNotNull(
                enableCameraControls, r'VoipState', 'enableCameraControls'),
            isMicrophoneOnStreamEnabled: BuiltValueNullFieldError.checkNotNull(
                isMicrophoneOnStreamEnabled,
                r'VoipState',
                'isMicrophoneOnStreamEnabled'),
            isSilentAudioCall: BuiltValueNullFieldError.checkNotNull(
                isSilentAudioCall, r'VoipState', 'isSilentAudioCall'),
            isFullScreen: BuiltValueNullFieldError.checkNotNull(
                isFullScreen, r'VoipState', 'isFullScreen'),
            isBuffering: BuiltValueNullFieldError.checkNotNull(
                isBuffering, r'VoipState', 'isBuffering'),
            isScrollLoading: BuiltValueNullFieldError.checkNotNull(
                isScrollLoading, r'VoipState', 'isScrollLoading'),
            isCameraOnStreamEnabled: BuiltValueNullFieldError.checkNotNull(
                isCameraOnStreamEnabled,
                r'VoipState',
                'isCameraOnStreamEnabled'),
            isReconnecting: BuiltValueNullFieldError.checkNotNull(
                isReconnecting, r'VoipState', 'isReconnecting'),
            isOnCallingScreen: BuiltValueNullFieldError.checkNotNull(
                isOnCallingScreen, r'VoipState', 'isOnCallingScreen'),
            callState: BuiltValueNullFieldError.checkNotNull(
                callState, r'VoipState', 'callState'),
            isPoorInternet: BuiltValueNullFieldError.checkNotNull(
                isPoorInternet, r'VoipState', 'isPoorInternet'),
            muted: BuiltValueNullFieldError.checkNotNull(
                muted, r'VoipState', 'muted'),
            location: BuiltValueNullFieldError.checkNotNull(
                location, r'VoipState', 'location'),
            meetingConnected: BuiltValueNullFieldError.checkNotNull(
                meetingConnected, r'VoipState', 'meetingConnected'),
            isCallControlsSheetExpanded: BuiltValueNullFieldError.checkNotNull(
                isCallControlsSheetExpanded,
                r'VoipState',
                'isCallControlsSheetExpanded'),
            isCallStarted: BuiltValueNullFieldError.checkNotNull(
                isCallStarted, r'VoipState', 'isCallStarted'),
            isPlaying: BuiltValueNullFieldError.checkNotNull(
                isPlaying, r'VoipState', 'isPlaying'),
            isInternetConnected: BuiltValueNullFieldError.checkNotNull(
                isInternetConnected, r'VoipState', 'isInternetConnected'),
            isStreamReconnecting: BuiltValueNullFieldError.checkNotNull(
                isStreamReconnecting, r'VoipState', 'isStreamReconnecting'),
            isSpeakerLoading: BuiltValueNullFieldError.checkNotNull(
                isSpeakerLoading, r'VoipState', 'isSpeakerLoading'),
            isVideoInitialized: BuiltValueNullFieldError.checkNotNull(
                isVideoInitialized, r'VoipState', 'isVideoInitialized'),
            meetingId: BuiltValueNullFieldError.checkNotNull(
                meetingId, r'VoipState', 'meetingId'),
            sliderValue: BuiltValueNullFieldError.checkNotNull(
                sliderValue, r'VoipState', 'sliderValue'),
            videoTimer: BuiltValueNullFieldError.checkNotNull(
                videoTimer, r'VoipState', 'videoTimer'),
            thumbnailImage: thumbnailImage,
            callValue: callValue,
            seconds: BuiltValueNullFieldError.checkNotNull(
                seconds, r'VoipState', 'seconds'),
            recordingApi: recordingApi.build(),
            userDoorBell: userDoorBell.build(),
            tempAiAlertList: tempAiAlertList.build(),
            confirmedAlertFilters: confirmedAlertFilters.build(),
            remoteRenderer: remoteRenderer,
            localRenderer: localRenderer,
            videoController: videoController,
            socketResponse: socketResponse.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'voipApi';
        voipApi.build();

        _$failedField = 'recordingApi';
        recordingApi.build();
        _$failedField = 'userDoorBell';
        userDoorBell.build();
        _$failedField = 'tempAiAlertList';
        tempAiAlertList.build();
        _$failedField = 'confirmedAlertFilters';
        confirmedAlertFilters.build();

        _$failedField = 'socketResponse';
        socketResponse.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VoipState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
