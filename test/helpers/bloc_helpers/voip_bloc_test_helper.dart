import 'dart:async';

import 'package:admin/models/data/api_meta_data.dart';
import 'package:admin/models/data/user_device_model.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/voip/bloc/voip_state.dart';
import 'package:admin/pages/main/voip/model/streaming_alerts_data.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/bloc/bloc_mocks.dart';
import '../../mocks/bloc/state_mocks.dart';
import '../fake_build_context.dart';

class VoipBlocTestHelper {
  late MockVoipBloc mockVoipBloc;
  late VoipState currentVoipState;

  void setup() {
    mockVoipBloc = MockVoipBloc();
    currentVoipState = MockVoipState();

    when(() => mockVoipBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockVoipBloc.state).thenReturn(currentVoipState);

    // Register fallback value for BuildContext
    registerFallbackValue(FakeBuildContext());

    // Note: The async methods are already implemented in MockVoipBloc
    // so we don't need to stub them with when()

    // Setup default state properties
    setupDefaultState();
  }

  void setupDefaultState() {
    // Stub all required VoipState properties
    when(() => currentVoipState.voipApi).thenReturn(ApiState<void>());
    when(() => currentVoipState.isLiveModeActivated).thenReturn(true);
    when(() => currentVoipState.isRecordedStreamLoading).thenReturn(false);
    when(() => currentVoipState.isLiveStreamingLoading).thenReturn(true);
    when(() => currentVoipState.isCallButtonEnabled).thenReturn(true);
    when(() => currentVoipState.isLiveStreamAvailable).thenReturn(true);
    when(() => currentVoipState.isCalling).thenReturn(false);
    when(() => currentVoipState.isReAttempt).thenReturn(false);
    when(() => currentVoipState.isAudioCall).thenReturn(false);
    when(() => currentVoipState.isCallConnected).thenReturn(false);
    when(() => currentVoipState.isOneWayCall).thenReturn(false);
    when(() => currentVoipState.isTwoWayCall).thenReturn(false);
    when(() => currentVoipState.enabledSpeakerInCall).thenReturn(true);
    when(() => currentVoipState.enabledSpeakerInStream).thenReturn(false);
    when(() => currentVoipState.isMicrophoneOnStreamEnabled).thenReturn(false);
    when(() => currentVoipState.isSilentAudioCall).thenReturn(false);
    when(() => currentVoipState.isFullScreen).thenReturn(false);
    when(() => currentVoipState.isBuffering).thenReturn(false);
    when(() => currentVoipState.isScrollLoading).thenReturn(false);
    when(() => currentVoipState.isCameraOnStreamEnabled).thenReturn(false);
    when(() => currentVoipState.isReconnecting).thenReturn(false);
    when(() => currentVoipState.isOnCallingScreen).thenReturn(false);
    when(() => currentVoipState.callState).thenReturn("Calling");
    when(() => currentVoipState.isPoorInternet).thenReturn(false);
    when(() => currentVoipState.muted).thenReturn(true);
    when(() => currentVoipState.location).thenReturn("");
    when(() => currentVoipState.meetingConnected).thenReturn(false);
    when(() => currentVoipState.isCallControlsSheetExpanded).thenReturn(true);
    when(() => currentVoipState.isCallStarted).thenReturn(false);
    when(() => currentVoipState.isPlaying).thenReturn(false);
    when(() => currentVoipState.isInternetConnected).thenReturn(true);
    when(() => currentVoipState.isStreamReconnecting).thenReturn(false);
    when(() => currentVoipState.isSpeakerLoading).thenReturn(false);
    when(() => currentVoipState.meetingId).thenReturn("");
    when(() => currentVoipState.sliderValue).thenReturn(0);
    when(() => currentVoipState.videoTimer).thenReturn("");
    when(() => currentVoipState.thumbnailImage).thenReturn(null);
    when(() => currentVoipState.callValue).thenReturn(null);
    when(() => currentVoipState.seconds).thenReturn(0);
    when(() => currentVoipState.recordingApi)
        .thenReturn(ApiState<StreamingAlertsData>());
    when(() => currentVoipState.userDoorBell).thenReturn(
      BuiltList([
        UserDeviceModel(
          (b) => b
            ..id = 1
            ..deviceId = "test_device_1"
            ..callUserId = "test_uuid_1"
            ..name = "Test Doorbell"
            ..locationId = 1
            ..isDefault = 1
            ..isStreaming = 0,
        ),
      ]),
    );
    when(() => currentVoipState.tempAiAlertList)
        .thenReturn(BuiltList<String>([]));
    when(() => currentVoipState.confirmedAlertFilters)
        .thenReturn(BuiltList<String>([]));
    when(() => currentVoipState.remoteRenderer).thenReturn(null);
    when(() => currentVoipState.localRenderer).thenReturn(null);
    when(() => currentVoipState.videoController).thenReturn(null);
    when(() => currentVoipState.socketResponse)
        .thenReturn(SocketState<Map<String, dynamic>>());
  }

  void setupWithCalling() {
    // Setup state with calling active
    when(() => currentVoipState.isCalling).thenReturn(true);
    when(() => currentVoipState.callState).thenReturn("Connecting");
    when(() => currentVoipState.isCallButtonEnabled).thenReturn(false);
  }

  void setupWithCallConnected() {
    // Setup state with call connected
    when(() => currentVoipState.isCallConnected).thenReturn(true);
    when(() => currentVoipState.isCalling).thenReturn(false);
    when(() => currentVoipState.callState).thenReturn("Connected");
    when(() => currentVoipState.seconds).thenReturn(30);
  }

  void setupWithAudioCall() {
    // Setup state with audio call
    when(() => currentVoipState.isAudioCall).thenReturn(true);
    when(() => currentVoipState.isOneWayCall).thenReturn(false);
    when(() => currentVoipState.isTwoWayCall).thenReturn(false);
  }

  void setupWithVideoCall() {
    // Setup state with video call
    when(() => currentVoipState.isAudioCall).thenReturn(false);
    when(() => currentVoipState.isTwoWayCall).thenReturn(true);
    when(() => currentVoipState.isOneWayCall).thenReturn(false);
  }

  void setupWithOneWayCall() {
    // Setup state with one-way call
    when(() => currentVoipState.isAudioCall).thenReturn(false);
    when(() => currentVoipState.isOneWayCall).thenReturn(true);
    when(() => currentVoipState.isTwoWayCall).thenReturn(false);
  }

  void setupWithLiveStreaming() {
    // Setup state with live streaming
    when(() => currentVoipState.isLiveModeActivated).thenReturn(true);
    when(() => currentVoipState.isLiveStreamAvailable).thenReturn(true);
    when(() => currentVoipState.isLiveStreamingLoading).thenReturn(false);
  }

  void setupWithRecordedStreaming() {
    // Setup state with recorded streaming
    when(() => currentVoipState.isLiveModeActivated).thenReturn(false);
    when(() => currentVoipState.isRecordedStreamLoading).thenReturn(false);
  }

  void setupWithMuted() {
    // Setup state with muted audio
    when(() => currentVoipState.muted).thenReturn(true);
    when(() => currentVoipState.enabledSpeakerInCall).thenReturn(false);
  }

  void setupWithUnmuted() {
    // Setup state with unmuted audio
    when(() => currentVoipState.muted).thenReturn(false);
    when(() => currentVoipState.enabledSpeakerInCall).thenReturn(true);
  }

  void setupWithFullScreen() {
    // Setup state with full screen
    when(() => currentVoipState.isFullScreen).thenReturn(true);
  }

  void setupWithBuffering() {
    // Setup state with buffering
    when(() => currentVoipState.isBuffering).thenReturn(true);
  }

  void setupWithReconnecting() {
    // Setup state with reconnecting
    when(() => currentVoipState.isReconnecting).thenReturn(true);
    when(() => currentVoipState.isStreamReconnecting).thenReturn(true);
  }

  void setupWithPoorInternet() {
    // Setup state with poor internet
    when(() => currentVoipState.isPoorInternet).thenReturn(true);
    when(() => currentVoipState.isInternetConnected).thenReturn(false);
  }

  void setupWithUserDoorbells() {
    // Setup state with user doorbells
    final mockDoorbell = UserDeviceModel(
      (b) => b
        ..id = 1
        ..deviceId = "test_device_1"
        ..callUserId = "test_uuid_1"
        ..name = "Test Doorbell"
        ..locationId = 1
        ..isDefault = 1
        ..isStreaming = 0,
    );

    when(() => currentVoipState.userDoorBell)
        .thenReturn(BuiltList([mockDoorbell]));
  }

  void setupWithAiAlerts() {
    // Setup state with AI alerts
    when(() => currentVoipState.tempAiAlertList)
        .thenReturn(BuiltList(["person", "vehicle"]));
    when(() => currentVoipState.confirmedAlertFilters)
        .thenReturn(BuiltList(["person"]));
  }

  void setupWithCallTimer() {
    // Setup state with call timer
    when(() => currentVoipState.seconds).thenReturn(120);
    when(() => currentVoipState.videoTimer).thenReturn("02:00");
  }

  void setupWithThumbnail() {
    // Setup state with thumbnail image
    when(() => currentVoipState.thumbnailImage)
        .thenReturn("https://example.com/thumbnail.jpg");
  }

  void setupLoadingState() {
    // Setup loading state
    when(() => currentVoipState.isLiveStreamingLoading).thenReturn(true);
    when(() => currentVoipState.isRecordedStreamLoading).thenReturn(true);
    when(() => currentVoipState.isSpeakerLoading).thenReturn(true);
    when(() => currentVoipState.voipApi.isApiInProgress).thenReturn(true);
    when(() => currentVoipState.recordingApi.isApiInProgress).thenReturn(true);
  }

  void setupErrorState() {
    // Setup error state
    final mockError = ApiMetaData(
      (b) => b
        ..message = "Test error"
        ..statusCode = 400,
    );
    when(() => currentVoipState.voipApi.error).thenReturn(mockError);
    when(() => currentVoipState.recordingApi.error).thenReturn(mockError);
  }

  void setupSuccessState() {
    // Setup success state - ApiState doesn't have isSuccess property
    // We can check if data is not null or error is null
    when(() => currentVoipState.voipApi.data).thenReturn(null);
    when(() => currentVoipState.voipApi.error).thenReturn(null);
    when(() => currentVoipState.recordingApi.data).thenReturn(null);
    when(() => currentVoipState.recordingApi.error).thenReturn(null);
  }

  void dispose() {
    // No stream controller to dispose
  }
}
