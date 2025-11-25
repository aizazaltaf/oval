import 'dart:async';

import 'package:admin/pages/main/voice_control/bloc/voice_control_state.dart';

import '../../mocks/bloc/bloc_mocks.dart';

class VoiceControlBlocTestHelper {
  VoiceControlBlocTestHelper() {
    voiceControlStateController =
        StreamController<VoiceControlState>.broadcast();
  }
  late MockVoiceControlBloc mockVoiceControlBloc;
  late StreamController<VoiceControlState> voiceControlStateController;
  late VoiceControlState currentVoiceControlState;

  void setup() {
    // Use a real VoiceControlState instead of mocking it
    currentVoiceControlState = VoiceControlState();
    mockVoiceControlBloc = MockVoiceControlBloc(currentVoiceControlState);
  }

  void dispose() {
    voiceControlStateController.close();
  }
}
