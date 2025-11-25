// ignore_for_file: type=lint, unused_element

part of 'voip_bloc.dart';

// **************************************************************************
// BlocGenerator
// **************************************************************************

class VoipBlocBuilder extends StatelessWidget {
  final BlocBuilderCondition<VoipState>? buildWhen;
  final BlocWidgetBuilder<VoipState> builder;

  const VoipBlocBuilder({
    Key? key,
    this.buildWhen,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<VoipBloc, VoipState>(
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}

class VoipBlocSelector<T> extends StatelessWidget {
  final BlocWidgetSelector<VoipState, T> selector;
  final Widget Function(T state) builder;
  final VoipBloc? bloc;

  const VoipBlocSelector({
    final Key? key,
    required this.selector,
    required this.builder,
    this.bloc,
  }) : super(key: key);

  static VoipBlocSelector<ApiState<void>> voipApi({
    final Key? key,
    required Widget Function(ApiState<void> voipApi) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.voipApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isLiveModeActivated({
    final Key? key,
    required Widget Function(bool isLiveModeActivated) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isLiveModeActivated,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isRecordedStreamLoading({
    final Key? key,
    required Widget Function(bool isRecordedStreamLoading) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isRecordedStreamLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isLiveStreamingLoading({
    final Key? key,
    required Widget Function(bool isLiveStreamingLoading) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isLiveStreamingLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isCallButtonEnabled({
    final Key? key,
    required Widget Function(bool isCallButtonEnabled) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isCallButtonEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isLiveStreamAvailable({
    final Key? key,
    required Widget Function(bool isLiveStreamAvailable) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isLiveStreamAvailable,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isCalling({
    final Key? key,
    required Widget Function(bool isCalling) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isCalling,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isReAttempt({
    final Key? key,
    required Widget Function(bool isReAttempt) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isReAttempt,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isAudioCall({
    final Key? key,
    required Widget Function(bool isAudioCall) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isAudioCall,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isCallConnected({
    final Key? key,
    required Widget Function(bool isCallConnected) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isCallConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isOneWayCall({
    final Key? key,
    required Widget Function(bool isOneWayCall) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isOneWayCall,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isTwoWayCall({
    final Key? key,
    required Widget Function(bool isTwoWayCall) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isTwoWayCall,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> enabledSpeakerInCall({
    final Key? key,
    required Widget Function(bool enabledSpeakerInCall) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.enabledSpeakerInCall,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> enabledSpeakerInStream({
    final Key? key,
    required Widget Function(bool enabledSpeakerInStream) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.enabledSpeakerInStream,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> enableCameraControls({
    final Key? key,
    required Widget Function(bool enableCameraControls) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.enableCameraControls,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isMicrophoneOnStreamEnabled({
    final Key? key,
    required Widget Function(bool isMicrophoneOnStreamEnabled) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isMicrophoneOnStreamEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isSilentAudioCall({
    final Key? key,
    required Widget Function(bool isSilentAudioCall) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isSilentAudioCall,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isFullScreen({
    final Key? key,
    required Widget Function(bool isFullScreen) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isFullScreen,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isBuffering({
    final Key? key,
    required Widget Function(bool isBuffering) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isBuffering,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isScrollLoading({
    final Key? key,
    required Widget Function(bool isScrollLoading) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isScrollLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isCameraOnStreamEnabled({
    final Key? key,
    required Widget Function(bool isCameraOnStreamEnabled) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isCameraOnStreamEnabled,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isReconnecting({
    final Key? key,
    required Widget Function(bool isReconnecting) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isReconnecting,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isOnCallingScreen({
    final Key? key,
    required Widget Function(bool isOnCallingScreen) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isOnCallingScreen,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<String> callState({
    final Key? key,
    required Widget Function(String callState) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.callState,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isPoorInternet({
    final Key? key,
    required Widget Function(bool isPoorInternet) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isPoorInternet,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> muted({
    final Key? key,
    required Widget Function(bool muted) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.muted,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<String> location({
    final Key? key,
    required Widget Function(String location) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.location,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> meetingConnected({
    final Key? key,
    required Widget Function(bool meetingConnected) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.meetingConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isCallControlsSheetExpanded({
    final Key? key,
    required Widget Function(bool isCallControlsSheetExpanded) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isCallControlsSheetExpanded,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isCallStarted({
    final Key? key,
    required Widget Function(bool isCallStarted) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isCallStarted,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isPlaying({
    final Key? key,
    required Widget Function(bool isPlaying) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isPlaying,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isInternetConnected({
    final Key? key,
    required Widget Function(bool isInternetConnected) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isInternetConnected,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isStreamReconnecting({
    final Key? key,
    required Widget Function(bool isStreamReconnecting) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isStreamReconnecting,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isSpeakerLoading({
    final Key? key,
    required Widget Function(bool isSpeakerLoading) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isSpeakerLoading,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<bool> isVideoInitialized({
    final Key? key,
    required Widget Function(bool isVideoInitialized) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.isVideoInitialized,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<String> meetingId({
    final Key? key,
    required Widget Function(String meetingId) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.meetingId,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<double> sliderValue({
    final Key? key,
    required Widget Function(double sliderValue) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.sliderValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<String> videoTimer({
    final Key? key,
    required Widget Function(String videoTimer) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.videoTimer,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<String?> thumbnailImage({
    final Key? key,
    required Widget Function(String? thumbnailImage) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.thumbnailImage,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<String?> callValue({
    final Key? key,
    required Widget Function(String? callValue) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.callValue,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<int> seconds({
    final Key? key,
    required Widget Function(int seconds) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.seconds,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<ApiState<StreamingAlertsData>> recordingApi({
    final Key? key,
    required Widget Function(ApiState<StreamingAlertsData> recordingApi)
        builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.recordingApi,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<BuiltList<UserDeviceModel>> userDoorBell({
    final Key? key,
    required Widget Function(BuiltList<UserDeviceModel> userDoorBell) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.userDoorBell,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<BuiltList<String>> tempAiAlertList({
    final Key? key,
    required Widget Function(BuiltList<String> tempAiAlertList) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.tempAiAlertList,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<BuiltList<String>> confirmedAlertFilters({
    final Key? key,
    required Widget Function(BuiltList<String> confirmedAlertFilters) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.confirmedAlertFilters,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<RTCVideoRenderer?> remoteRenderer({
    final Key? key,
    required Widget Function(RTCVideoRenderer? remoteRenderer) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.remoteRenderer,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<RTCVideoRenderer?> localRenderer({
    final Key? key,
    required Widget Function(RTCVideoRenderer? localRenderer) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.localRenderer,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<VideoPlayerController?> videoController({
    final Key? key,
    required Widget Function(VideoPlayerController? videoController) builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.videoController,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  static VoipBlocSelector<SocketState<Map<String, dynamic>>> socketResponse({
    final Key? key,
    required Widget Function(SocketState<Map<String, dynamic>> socketResponse)
        builder,
    final VoipBloc? bloc,
  }) {
    return VoipBlocSelector(
      key: key,
      selector: (state) => state.socketResponse,
      builder: (value) => builder(value),
      bloc: bloc,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocSelector<VoipBloc, VoipState, T>(
      selector: selector,
      builder: (_, value) => builder(value),
      bloc: bloc,
    );
  }
}

mixin _VoipBlocMixin on Cubit<VoipState> {
  @mustCallSuper
  void updateIsLiveModeActivated(final bool isLiveModeActivated) {
    if (this.state.isLiveModeActivated == isLiveModeActivated) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isLiveModeActivated = isLiveModeActivated));

    $onUpdateIsLiveModeActivated();
  }

  @protected
  void $onUpdateIsLiveModeActivated() {}

  @mustCallSuper
  void updateIsRecordedStreamLoading(final bool isRecordedStreamLoading) {
    if (this.state.isRecordedStreamLoading == isRecordedStreamLoading) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.isRecordedStreamLoading = isRecordedStreamLoading));

    $onUpdateIsRecordedStreamLoading();
  }

  @protected
  void $onUpdateIsRecordedStreamLoading() {}

  @mustCallSuper
  void updateIsLiveStreamingLoading(final bool isLiveStreamingLoading) {
    if (this.state.isLiveStreamingLoading == isLiveStreamingLoading) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.isLiveStreamingLoading = isLiveStreamingLoading));

    $onUpdateIsLiveStreamingLoading();
  }

  @protected
  void $onUpdateIsLiveStreamingLoading() {}

  @mustCallSuper
  void updateIsCallButtonEnabled(final bool isCallButtonEnabled) {
    if (this.state.isCallButtonEnabled == isCallButtonEnabled) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isCallButtonEnabled = isCallButtonEnabled));

    $onUpdateIsCallButtonEnabled();
  }

  @protected
  void $onUpdateIsCallButtonEnabled() {}

  @mustCallSuper
  void updateIsLiveStreamAvailable(final bool isLiveStreamAvailable) {
    if (this.state.isLiveStreamAvailable == isLiveStreamAvailable) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isLiveStreamAvailable = isLiveStreamAvailable));

    $onUpdateIsLiveStreamAvailable();
  }

  @protected
  void $onUpdateIsLiveStreamAvailable() {}

  @mustCallSuper
  void updateIsCalling(final bool isCalling) {
    if (this.state.isCalling == isCalling) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isCalling = isCalling));

    $onUpdateIsCalling();
  }

  @protected
  void $onUpdateIsCalling() {}

  @mustCallSuper
  void updateIsReAttempt(final bool isReAttempt) {
    if (this.state.isReAttempt == isReAttempt) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isReAttempt = isReAttempt));

    $onUpdateIsReAttempt();
  }

  @protected
  void $onUpdateIsReAttempt() {}

  @mustCallSuper
  void updateIsAudioCall(final bool isAudioCall) {
    if (this.state.isAudioCall == isAudioCall) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isAudioCall = isAudioCall));

    $onUpdateIsAudioCall();
  }

  @protected
  void $onUpdateIsAudioCall() {}

  @mustCallSuper
  void updateIsCallConnected(final bool isCallConnected) {
    if (this.state.isCallConnected == isCallConnected) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isCallConnected = isCallConnected));

    $onUpdateIsCallConnected();
  }

  @protected
  void $onUpdateIsCallConnected() {}

  @mustCallSuper
  void updateIsOneWayCall(final bool isOneWayCall) {
    if (this.state.isOneWayCall == isOneWayCall) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isOneWayCall = isOneWayCall));

    $onUpdateIsOneWayCall();
  }

  @protected
  void $onUpdateIsOneWayCall() {}

  @mustCallSuper
  void updateEnabledSpeakerInCall(final bool enabledSpeakerInCall) {
    if (this.state.enabledSpeakerInCall == enabledSpeakerInCall) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.enabledSpeakerInCall = enabledSpeakerInCall));

    $onUpdateEnabledSpeakerInCall();
  }

  @protected
  void $onUpdateEnabledSpeakerInCall() {}

  @mustCallSuper
  void updateEnabledSpeakerInStream(final bool enabledSpeakerInStream) {
    if (this.state.enabledSpeakerInStream == enabledSpeakerInStream) {
      return;
    }

    emit(this.state.rebuild(
        (final b) => b.enabledSpeakerInStream = enabledSpeakerInStream));

    $onUpdateEnabledSpeakerInStream();
  }

  @protected
  void $onUpdateEnabledSpeakerInStream() {}

  @mustCallSuper
  void updateEnableCameraControls(final bool enableCameraControls) {
    if (this.state.enableCameraControls == enableCameraControls) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.enableCameraControls = enableCameraControls));

    $onUpdateEnableCameraControls();
  }

  @protected
  void $onUpdateEnableCameraControls() {}

  @mustCallSuper
  void updateIsFullScreen(final bool isFullScreen) {
    if (this.state.isFullScreen == isFullScreen) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isFullScreen = isFullScreen));

    $onUpdateIsFullScreen();
  }

  @protected
  void $onUpdateIsFullScreen() {}

  @mustCallSuper
  void updateIsBuffering(final bool isBuffering) {
    if (this.state.isBuffering == isBuffering) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isBuffering = isBuffering));

    $onUpdateIsBuffering();
  }

  @protected
  void $onUpdateIsBuffering() {}

  @mustCallSuper
  void updateIsScrollLoading(final bool isScrollLoading) {
    if (this.state.isScrollLoading == isScrollLoading) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isScrollLoading = isScrollLoading));

    $onUpdateIsScrollLoading();
  }

  @protected
  void $onUpdateIsScrollLoading() {}

  @mustCallSuper
  void updateIsReconnecting(final bool isReconnecting) {
    if (this.state.isReconnecting == isReconnecting) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isReconnecting = isReconnecting));

    $onUpdateIsReconnecting();
  }

  @protected
  void $onUpdateIsReconnecting() {}

  @mustCallSuper
  void updateIsOnCallingScreen(final bool isOnCallingScreen) {
    if (this.state.isOnCallingScreen == isOnCallingScreen) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isOnCallingScreen = isOnCallingScreen));

    $onUpdateIsOnCallingScreen();
  }

  @protected
  void $onUpdateIsOnCallingScreen() {}

  @mustCallSuper
  void updateCallState(final String callState) {
    if (this.state.callState == callState) {
      return;
    }

    emit(this.state.rebuild((final b) => b.callState = callState));

    $onUpdateCallState();
  }

  @protected
  void $onUpdateCallState() {}

  @mustCallSuper
  void updateIsPoorInternet(final bool isPoorInternet) {
    if (this.state.isPoorInternet == isPoorInternet) {
      return;
    }

    emit(this.state.rebuild((final b) => b.isPoorInternet = isPoorInternet));

    $onUpdateIsPoorInternet();
  }

  @protected
  void $onUpdateIsPoorInternet() {}

  @mustCallSuper
  void updateIsInternetConnected(final bool isInternetConnected) {
    if (this.state.isInternetConnected == isInternetConnected) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isInternetConnected = isInternetConnected));

    $onUpdateIsInternetConnected();
  }

  @protected
  void $onUpdateIsInternetConnected() {}

  @mustCallSuper
  void updateIsStreamReconnecting(final bool isStreamReconnecting) {
    if (this.state.isStreamReconnecting == isStreamReconnecting) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isStreamReconnecting = isStreamReconnecting));

    $onUpdateIsStreamReconnecting();
  }

  @protected
  void $onUpdateIsStreamReconnecting() {}

  @mustCallSuper
  void updateIsSpeakerLoading(final bool isSpeakerLoading) {
    if (this.state.isSpeakerLoading == isSpeakerLoading) {
      return;
    }

    emit(
        this.state.rebuild((final b) => b.isSpeakerLoading = isSpeakerLoading));

    $onUpdateIsSpeakerLoading();
  }

  @protected
  void $onUpdateIsSpeakerLoading() {}

  @mustCallSuper
  void updateIsVideoInitialized(final bool isVideoInitialized) {
    if (this.state.isVideoInitialized == isVideoInitialized) {
      return;
    }

    emit(this
        .state
        .rebuild((final b) => b.isVideoInitialized = isVideoInitialized));

    $onUpdateIsVideoInitialized();
  }

  @protected
  void $onUpdateIsVideoInitialized() {}

  @mustCallSuper
  void updateThumbnailImage(final String? thumbnailImage) {
    if (this.state.thumbnailImage == thumbnailImage) {
      return;
    }

    emit(this.state.rebuild((final b) => b.thumbnailImage = thumbnailImage));

    $onUpdateThumbnailImage();
  }

  @protected
  void $onUpdateThumbnailImage() {}

  @mustCallSuper
  void updateCallValue(final String? callValue) {
    if (this.state.callValue == callValue) {
      return;
    }

    emit(this.state.rebuild((final b) => b.callValue = callValue));

    $onUpdateCallValue();
  }

  @protected
  void $onUpdateCallValue() {}

  @mustCallSuper
  void updateRecordingApi(final ApiState<StreamingAlertsData> recordingApi) {
    if (this.state.recordingApi == recordingApi) {
      return;
    }

    emit(this.state.rebuild((final b) {
      b.recordingApi.replace(recordingApi);
    }));

    $onUpdateRecordingApi();
  }

  @protected
  void $onUpdateRecordingApi() {}

  @mustCallSuper
  void updateRemoteRenderer(final RTCVideoRenderer? remoteRenderer) {
    if (this.state.remoteRenderer == remoteRenderer) {
      return;
    }

    emit(this.state.rebuild((final b) => b.remoteRenderer = remoteRenderer));

    $onUpdateRemoteRenderer();
  }

  @protected
  void $onUpdateRemoteRenderer() {}
}
